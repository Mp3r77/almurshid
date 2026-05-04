import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';

import '../../../../core/usecases/usecase.dart';
import '../../../doctors/domain/entities/doctor_entity.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_model.dart';
import '../../domain/entities/appointment_entity.dart';
import '../../domain/usecases/get_previous_appointments.dart';
import '../../domain/usecases/get_upcoming_appointments.dart';
import '../../domain/usecases/process_booking_usecase.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

@injectable
class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final GetUpcomingAppointments _getUpcomingAppointments;
  final GetPreviousAppointments _getPreviousAppointments;
  final ProcessBookingUseCase _processBookingUseCase;
  final NotificationBloc _notificationBloc;

  AppointmentBloc({
    required GetUpcomingAppointments getUpcomingAppointments,
    required GetPreviousAppointments getPreviousAppointments,
    required ProcessBookingUseCase processBookingUseCase,
    required NotificationBloc notificationBloc,
  })  : _getUpcomingAppointments = getUpcomingAppointments,
        _getPreviousAppointments = getPreviousAppointments,
        _processBookingUseCase = processBookingUseCase,
        _notificationBloc = notificationBloc,
        super(AppointmentState.initial()) {
    on<SelectDate>(_onSelectDate);
    on<SelectTime>(_onSelectTime);
    on<ProcessBooking>(_onProcessBooking);
    on<LoadAppointments>(_onLoadAppointments);
    on<ConfirmPendingAppointment>(_onConfirmPendingAppointment);
    on<CompleteConfirmedAppointment>(_onCompleteConfirmedAppointment);
    on<CancelBookedAppointment>(_onCancelBookedAppointment);
    on<PrepareRescheduleDraft>(_onPrepareRescheduleDraft);
    on<UpdateRescheduleDate>(_onUpdateRescheduleDate);
    on<UpdateRescheduleTime>(_onUpdateRescheduleTime);
    on<SubmitRescheduleAppointment>(_onSubmitRescheduleAppointment);
    on<UpdateCancellationReason>(_onUpdateCancellationReason);
    on<UpdateCancellationNote>(_onUpdateCancellationNote);
    on<ResetAppointmentActionState>(_onResetAppointmentActionState);
  }

  void _onSelectDate(SelectDate event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(selectedDate: event.date));
  }

  void _onSelectTime(SelectTime event, Emitter<AppointmentState> emit) {
    emit(state.copyWith(selectedTime: event.time));
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentStatus.loading));

    final upcomingResult = await _getUpcomingAppointments(const NoParams());
    final previousResult = await _getPreviousAppointments(const NoParams());

    upcomingResult.fold(
      (failure) => emit(state.copyWith(status: AppointmentStatus.failure)),
      (upcoming) {
        previousResult.fold(
          (failure) => emit(state.copyWith(status: AppointmentStatus.failure)),
          (previous) {
            final mergedUpcoming = _mergeAppointments(
              upcoming,
              state.localBookedAppointments,
            );
            final mergedHistory = _mergeAppointments(
              previous,
              [
                ...state.localPreviousAppointments,
                ...state.localCancelledAppointments,
              ],
            );

            emit(
              state.copyWith(
                status: AppointmentStatus.success,
                upcomingAppointments: mergedUpcoming,
                previousAppointments:
                    _excludeCancelledAppointments(mergedHistory),
                cancelledAppointments:
                    _extractCancelledAppointments(mergedHistory),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onProcessBooking(
    ProcessBooking event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(state.copyWith(status: AppointmentStatus.loading));

    final result = await _processBookingUseCase(
      ProcessBookingParams(
        doctorId: event.doctorId,
        dateTime: event.dateTime,
      ),
    );

    result.fold(
      (failure) => emit(state.copyWith(status: AppointmentStatus.failure)),
      (_) {
        final bookedAppointment = _buildLocalAppointment(
          doctor: event.doctor,
          bookingType: event.bookingType,
          dateTime: event.dateTime,
          patientName: event.patientName,
          patientPhone: event.patientPhone,
          patientGender: event.patientGender,
          patientAge: event.patientAge,
          bookingPeriod: event.bookingPeriod,
        );

        final localBookedAppointments = bookedAppointment == null
            ? state.localBookedAppointments
            : [bookedAppointment, ...state.localBookedAppointments];

        emit(
          state.copyWith(
            status: AppointmentStatus.success,
            localBookedAppointments: localBookedAppointments,
            upcomingAppointments: _mergeAppointments(
              state.upcomingAppointments,
              bookedAppointment == null ? const [] : [bookedAppointment],
            ),
          ),
        );

        if (bookedAppointment != null && event.autoConfirm) {
          Future<void>.delayed(const Duration(seconds: 3), () {
            if (!isClosed) {
              add(ConfirmPendingAppointment(bookedAppointment.id));
            }
          });
        }
      },
    );
  }

  void _onConfirmPendingAppointment(
    ConfirmPendingAppointment event,
    Emitter<AppointmentState> emit,
  ) {
    final updatedLocalBookedAppointments =
        state.localBookedAppointments.map((appointment) {
      if (appointment.id != event.appointmentId) {
        return appointment;
      }

      return appointment.copyWith(status: 'مؤكد');
    }).toList();

    final confirmedAppointment =
        updatedLocalBookedAppointments.cast<AppointmentEntity?>().firstWhere(
              (appointment) => appointment?.id == event.appointmentId,
              orElse: () => null,
            );

    emit(
      state.copyWith(
        localBookedAppointments: updatedLocalBookedAppointments,
        upcomingAppointments: _mergeAppointments(
          state.upcomingAppointments
              .where((appointment) => appointment.id != event.appointmentId)
              .toList(),
          confirmedAppointment == null ? const [] : [confirmedAppointment],
        ),
        status: AppointmentStatus.success,
      ),
    );

    if (confirmedAppointment != null) {
      _notificationBloc.add(
        AddNotification(
          NotificationModel(
            id: 'notif_${confirmedAppointment.id}',
            title: 'تم تأكيد حجزك مع ${confirmedAppointment.doctor.name}.',
            subtitle: 'تم اعتماد الدفع من الإدارة',
            type: NotificationType.appointment,
            timeText: 'الآن',
            timestamp: DateTime.now(),
          ),
        ),
      );

      Future<void>.delayed(const Duration(seconds: 6), () {
        if (!isClosed) {
          add(CompleteConfirmedAppointment(confirmedAppointment.id));
        }
      });
    }
  }

  void _onCompleteConfirmedAppointment(
    CompleteConfirmedAppointment event,
    Emitter<AppointmentState> emit,
  ) {
    AppointmentEntity? completedAppointment;
    final remainingLocalUpcoming = <AppointmentEntity>[];

    for (final appointment in state.localBookedAppointments) {
      if (appointment.id == event.appointmentId) {
        completedAppointment = appointment.copyWith(status: 'مكتمل');
      } else {
        remainingLocalUpcoming.add(appointment);
      }
    }

    if (completedAppointment == null) {
      return;
    }

    emit(
      state.copyWith(
        status: AppointmentStatus.success,
        localBookedAppointments: remainingLocalUpcoming,
        localPreviousAppointments: [
          completedAppointment,
          ...state.localPreviousAppointments
              .where((appointment) => appointment.id != event.appointmentId),
        ],
        upcomingAppointments: _mergeAppointments(
          state.upcomingAppointments
              .where((appointment) => appointment.id != event.appointmentId)
              .toList(),
          remainingLocalUpcoming,
        ),
        previousAppointments: _mergeAppointments(
          state.previousAppointments
              .where((appointment) => appointment.id != event.appointmentId)
              .toList(),
          [completedAppointment],
        ),
        cancelledAppointments: state.cancelledAppointments
            .where((appointment) => appointment.id != event.appointmentId)
            .toList(),
      ),
    );
  }

  void _onPrepareRescheduleDraft(
    PrepareRescheduleDraft event,
    Emitter<AppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        rescheduleDate: event.initialDateTime,
        rescheduleTime:
            DateFormat('hh:mm a', 'en').format(event.initialDateTime),
        actionStatus: AppointmentActionStatus.idle,
        actionMessage: null,
      ),
    );
  }

  void _onUpdateRescheduleDate(
    UpdateRescheduleDate event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(rescheduleDate: event.date));
  }

  void _onUpdateRescheduleTime(
    UpdateRescheduleTime event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(rescheduleTime: event.time));
  }

  Future<void> _onSubmitRescheduleAppointment(
    SubmitRescheduleAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    if (state.rescheduleTime.isEmpty) {
      emit(
        state.copyWith(
          actionStatus: AppointmentActionStatus.failure,
          actionMessage: 'اختر وقت الموعد الجديد أولاً',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        actionStatus: AppointmentActionStatus.submitting,
        actionMessage: null,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 500));
    final newDateTime = _combineDateWithTime(
      state.rescheduleDate,
      state.rescheduleTime,
    );

    final updatedUpcoming = _replaceAppointment(
      state.upcomingAppointments,
      event.appointmentId,
      (appointment) => appointment.copyWith(
        dateTime: newDateTime,
        status: 'في الانتظار',
      ),
    );

    final updatedLocal = _replaceAppointment(
      state.localBookedAppointments,
      event.appointmentId,
      (appointment) => appointment.copyWith(
        dateTime: newDateTime,
        status: 'في الانتظار',
      ),
    );

    emit(
      state.copyWith(
        upcomingAppointments: updatedUpcoming,
        localBookedAppointments: updatedLocal,
        actionStatus: AppointmentActionStatus.success,
        actionMessage:
            'تم إرسال طلب تأجيل الموعد إلى ${DateFormat('d MMMM - h:mm a', 'ar').format(newDateTime)}',
      ),
    );
  }

  void _onUpdateCancellationReason(
    UpdateCancellationReason event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(cancellationReason: event.reason));
  }

  void _onUpdateCancellationNote(
    UpdateCancellationNote event,
    Emitter<AppointmentState> emit,
  ) {
    emit(state.copyWith(cancellationNote: event.note));
  }

  Future<void> _onCancelBookedAppointment(
    CancelBookedAppointment event,
    Emitter<AppointmentState> emit,
  ) async {
    emit(
      state.copyWith(
        actionStatus: AppointmentActionStatus.submitting,
        actionMessage: null,
      ),
    );

    await Future<void>.delayed(const Duration(milliseconds: 500));

    AppointmentEntity? cancelledAppointment;
    final remainingLocalUpcoming = <AppointmentEntity>[];

    for (final appointment in state.localBookedAppointments) {
      if (appointment.id == event.appointmentId) {
        cancelledAppointment = appointment.copyWith(
          status: 'مرفوض',
          cancelReason: event.reason,
          cancelNote: event.note,
        );
      } else {
        remainingLocalUpcoming.add(appointment);
      }
    }

    final upcomingMatch =
        state.upcomingAppointments.cast<AppointmentEntity?>().firstWhere(
              (appointment) => appointment?.id == event.appointmentId,
              orElse: () => null,
            );

    cancelledAppointment ??= upcomingMatch?.copyWith(
      status: 'مرفوض',
      cancelReason: event.reason,
      cancelNote: event.note,
    );

    if (cancelledAppointment == null) {
      emit(
        state.copyWith(
          actionStatus: AppointmentActionStatus.failure,
          actionMessage: 'تعذر إلغاء هذا الطلب',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        localBookedAppointments: remainingLocalUpcoming,
        localCancelledAppointments: [
          cancelledAppointment,
          ...state.localCancelledAppointments
              .where((appointment) => appointment.id != event.appointmentId),
        ],
        upcomingAppointments: _mergeAppointments(
          state.upcomingAppointments
              .where((appointment) => appointment.id != event.appointmentId)
              .toList(),
          remainingLocalUpcoming,
        ),
        cancelledAppointments: _mergeAppointments(
          state.cancelledAppointments
              .where((appointment) => appointment.id != event.appointmentId)
              .toList(),
          [cancelledAppointment],
        ),
        cancellationReason: event.reason,
        cancellationNote: event.note,
        actionStatus: AppointmentActionStatus.success,
        actionMessage: 'تم إلغاء الطلب بنجاح',
      ),
    );
  }

  void _onResetAppointmentActionState(
    ResetAppointmentActionState event,
    Emitter<AppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        actionStatus: AppointmentActionStatus.idle,
        actionMessage: null,
        cancellationReason: '',
        cancellationNote: '',
      ),
    );
  }

  List<AppointmentEntity> _mergeAppointments(
    List<AppointmentEntity> primary,
    List<AppointmentEntity> secondary,
  ) {
    final byId = <String, AppointmentEntity>{};

    for (final appointment in [...primary, ...secondary]) {
      byId[appointment.id] = appointment;
    }

    final merged = byId.values.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return merged;
  }

  List<AppointmentEntity> _replaceAppointment(
    List<AppointmentEntity> appointments,
    String appointmentId,
    AppointmentEntity Function(AppointmentEntity appointment) transform,
  ) {
    return appointments
        .map(
          (appointment) => appointment.id == appointmentId
              ? transform(appointment)
              : appointment,
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<AppointmentEntity> _extractCancelledAppointments(
    List<AppointmentEntity> appointments,
  ) {
    return appointments.where(_isCancelledStatus).toList();
  }

  List<AppointmentEntity> _excludeCancelledAppointments(
    List<AppointmentEntity> appointments,
  ) {
    return appointments
        .where((appointment) => !_isCancelledStatus(appointment))
        .toList();
  }

  bool _isCancelledStatus(AppointmentEntity appointment) {
    return appointment.status == 'مرفوض' || appointment.status == 'ملغي';
  }

  DateTime _combineDateWithTime(DateTime date, String time) {
    final parsed = DateFormat('hh:mm a', 'en').parse(time);
    return DateTime(
      date.year,
      date.month,
      date.day,
      parsed.hour,
      parsed.minute,
    );
  }

  AppointmentEntity? _buildLocalAppointment({
    required DoctorEntity? doctor,
    required String? bookingType,
    required DateTime dateTime,
    required String? patientName,
    required String? patientPhone,
    required String? patientGender,
    required String? patientAge,
    required String? bookingPeriod,
  }) {
    if (doctor == null) {
      return null;
    }

    return AppointmentEntity(
      id: 'local_${DateTime.now().microsecondsSinceEpoch}',
      doctor: doctor,
      dateTime: dateTime,
      status: 'في الانتظار',
      type: bookingType ?? 'موعد إلكتروني',
      patientName: patientName,
      patientPhone: patientPhone,
      patientGender: patientGender,
      patientAge: patientAge,
      bookingPeriod: bookingPeriod,
    );
  }
}
