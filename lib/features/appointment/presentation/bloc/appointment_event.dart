part of 'appointment_bloc.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class SelectDate extends AppointmentEvent {
  final DateTime date;

  const SelectDate(this.date);

  @override
  List<Object?> get props => [date];
}

class SelectTime extends AppointmentEvent {
  final String time;

  const SelectTime(this.time);

  @override
  List<Object?> get props => [time];
}

class ProcessBooking extends AppointmentEvent {
  final String doctorId;
  final DateTime dateTime;
  final DoctorEntity? doctor;
  final String? bookingType;
  final String? patientName;
  final String? patientPhone;
  final String? patientGender;
  final String? patientAge;
  final String? bookingPeriod;
  final bool autoConfirm;

  const ProcessBooking({
    required this.doctorId,
    required this.dateTime,
    this.doctor,
    this.bookingType,
    this.patientName,
    this.patientPhone,
    this.patientGender,
    this.patientAge,
    this.bookingPeriod,
    this.autoConfirm = true,
  });

  @override
  List<Object?> get props => [
        doctorId,
        dateTime,
        doctor,
        bookingType,
        patientName,
        patientPhone,
        patientGender,
        patientAge,
        bookingPeriod,
        autoConfirm,
      ];
}

class LoadAppointments extends AppointmentEvent {
  const LoadAppointments();
}

class ConfirmPendingAppointment extends AppointmentEvent {
  final String appointmentId;

  const ConfirmPendingAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CompleteConfirmedAppointment extends AppointmentEvent {
  final String appointmentId;

  const CompleteConfirmedAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class CancelBookedAppointment extends AppointmentEvent {
  final String appointmentId;
  final String reason;
  final String note;

  const CancelBookedAppointment({
    required this.appointmentId,
    required this.reason,
    this.note = '',
  });

  @override
  List<Object?> get props => [appointmentId, reason, note];
}

class PrepareRescheduleDraft extends AppointmentEvent {
  final DateTime initialDateTime;

  const PrepareRescheduleDraft(this.initialDateTime);

  @override
  List<Object?> get props => [initialDateTime];
}

class UpdateRescheduleDate extends AppointmentEvent {
  final DateTime date;

  const UpdateRescheduleDate(this.date);

  @override
  List<Object?> get props => [date];
}

class UpdateRescheduleTime extends AppointmentEvent {
  final String time;

  const UpdateRescheduleTime(this.time);

  @override
  List<Object?> get props => [time];
}

class SubmitRescheduleAppointment extends AppointmentEvent {
  final String appointmentId;

  const SubmitRescheduleAppointment(this.appointmentId);

  @override
  List<Object?> get props => [appointmentId];
}

class UpdateCancellationReason extends AppointmentEvent {
  final String reason;

  const UpdateCancellationReason(this.reason);

  @override
  List<Object?> get props => [reason];
}

class UpdateCancellationNote extends AppointmentEvent {
  final String note;

  const UpdateCancellationNote(this.note);

  @override
  List<Object?> get props => [note];
}

class ResetAppointmentActionState extends AppointmentEvent {
  const ResetAppointmentActionState();
}
