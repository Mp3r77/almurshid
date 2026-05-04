import 'package:equatable/equatable.dart';
import '../../domain/entities/diagnostic_entities.dart';

abstract class DiagnosticsEvent extends Equatable {
  const DiagnosticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDiagnosticsCenters extends DiagnosticsEvent {
  final DiagnosticType? type;
  const LoadDiagnosticsCenters({this.type});

  @override
  List<Object?> get props => [type];
}

class SelectDiagnosticCenter extends DiagnosticsEvent {
  final DiagnosticCenter center;
  const SelectDiagnosticCenter(this.center);

  @override
  List<Object?> get props => [center];
}

class AddDiagnosticServiceToBooking extends DiagnosticsEvent {
  final DiagnosticService service;
  const AddDiagnosticServiceToBooking(this.service);

  @override
  List<Object?> get props => [service];
}

class RemoveDiagnosticServiceFromBooking extends DiagnosticsEvent {
  final DiagnosticService service;
  const RemoveDiagnosticServiceFromBooking(this.service);

  @override
  List<Object?> get props => [service];
}

class SubmitBookingRequest extends DiagnosticsEvent {
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String? prescriptionPath;
  final DateTime appointmentDate;
  final String appointmentTime;

  const SubmitBookingRequest({
    required this.patientName,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    this.prescriptionPath,
    required this.appointmentDate,
    required this.appointmentTime,
  });

  @override
  List<Object?> get props => [
        patientName,
        patientPhone,
        patientAge,
        patientGender,
        prescriptionPath,
        appointmentDate,
        appointmentTime,
      ];
}

class LoadBookingDetails extends DiagnosticsEvent {
  final String bookingId;
  const LoadBookingDetails(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}
