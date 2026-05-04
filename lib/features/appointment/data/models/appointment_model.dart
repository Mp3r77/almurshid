import '../../../../features/doctors/data/models/doctor_model.dart';
import '../../domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    required super.doctor,
    required super.dateTime,
    required super.status,
    required super.type,
    super.patientName,
    super.patientPhone,
    super.patientGender,
    super.patientAge,
    super.bookingPeriod,
    super.cancelReason,
    super.cancelNote,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      doctor: DoctorModel.fromJson(json['doctor'] ?? {}),
      dateTime: DateTime.tryParse(json['dateTime'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? '',
      type: json['type'] ?? '',
      patientName: json['patientName']?.toString(),
      patientPhone: json['patientPhone']?.toString(),
      patientGender: json['patientGender']?.toString(),
      patientAge: json['patientAge']?.toString(),
      bookingPeriod: json['bookingPeriod']?.toString(),
      cancelReason: json['cancelReason']?.toString(),
      cancelNote: json['cancelNote']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor': (doctor as DoctorModel).toJson(),
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'type': type,
      'patientName': patientName,
      'patientPhone': patientPhone,
      'patientGender': patientGender,
      'patientAge': patientAge,
      'bookingPeriod': bookingPeriod,
      'cancelReason': cancelReason,
      'cancelNote': cancelNote,
    };
  }
}
