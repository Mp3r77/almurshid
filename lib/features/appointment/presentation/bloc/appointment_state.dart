part of 'appointment_bloc.dart';

enum AppointmentStatus { initial, loading, success, failure }

enum AppointmentActionStatus { idle, submitting, success, failure }

class AppointmentState extends Equatable {
  final DateTime selectedDate;
  final String selectedTime;
  final List<AppointmentEntity> upcomingAppointments;
  final List<AppointmentEntity> previousAppointments;
  final List<AppointmentEntity> cancelledAppointments;
  final List<AppointmentEntity> localBookedAppointments;
  final List<AppointmentEntity> localPreviousAppointments;
  final List<AppointmentEntity> localCancelledAppointments;
  final DateTime rescheduleDate;
  final String rescheduleTime;
  final String cancellationReason;
  final String cancellationNote;
  final AppointmentStatus status;
  final AppointmentActionStatus actionStatus;
  final String? errorMessage;
  final String? actionMessage;

  const AppointmentState({
    required this.selectedDate,
    required this.selectedTime,
    required this.rescheduleDate,
    required this.rescheduleTime,
    this.upcomingAppointments = const [],
    this.previousAppointments = const [],
    this.cancelledAppointments = const [],
    this.localBookedAppointments = const [],
    this.localPreviousAppointments = const [],
    this.localCancelledAppointments = const [],
    this.cancellationReason = '',
    this.cancellationNote = '',
    this.status = AppointmentStatus.initial,
    this.actionStatus = AppointmentActionStatus.idle,
    this.errorMessage,
    this.actionMessage,
  });

  factory AppointmentState.initial() {
    final now = DateTime.now();
    return AppointmentState(
      selectedDate: now,
      selectedTime: '',
      rescheduleDate: now,
      rescheduleTime: '',
    );
  }

  AppointmentState copyWith({
    DateTime? selectedDate,
    String? selectedTime,
    List<AppointmentEntity>? upcomingAppointments,
    List<AppointmentEntity>? previousAppointments,
    List<AppointmentEntity>? cancelledAppointments,
    List<AppointmentEntity>? localBookedAppointments,
    List<AppointmentEntity>? localPreviousAppointments,
    List<AppointmentEntity>? localCancelledAppointments,
    DateTime? rescheduleDate,
    String? rescheduleTime,
    String? cancellationReason,
    String? cancellationNote,
    AppointmentStatus? status,
    AppointmentActionStatus? actionStatus,
    String? errorMessage,
    String? actionMessage,
  }) {
    return AppointmentState(
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      upcomingAppointments: upcomingAppointments ?? this.upcomingAppointments,
      previousAppointments: previousAppointments ?? this.previousAppointments,
      cancelledAppointments:
          cancelledAppointments ?? this.cancelledAppointments,
      localBookedAppointments:
          localBookedAppointments ?? this.localBookedAppointments,
      localPreviousAppointments:
          localPreviousAppointments ?? this.localPreviousAppointments,
      localCancelledAppointments:
          localCancelledAppointments ?? this.localCancelledAppointments,
      rescheduleDate: rescheduleDate ?? this.rescheduleDate,
      rescheduleTime: rescheduleTime ?? this.rescheduleTime,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      cancellationNote: cancellationNote ?? this.cancellationNote,
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }

  @override
  List<Object?> get props => [
        selectedDate,
        selectedTime,
        upcomingAppointments,
        previousAppointments,
        cancelledAppointments,
        localBookedAppointments,
        localPreviousAppointments,
        localCancelledAppointments,
        rescheduleDate,
        rescheduleTime,
        cancellationReason,
        cancellationNote,
        status,
        actionStatus,
        errorMessage,
        actionMessage,
      ];
}
