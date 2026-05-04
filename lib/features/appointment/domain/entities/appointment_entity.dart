import 'package:equatable/equatable.dart';

import '../../../../features/doctors/domain/entities/doctor_entity.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final DoctorEntity doctor;
  final DateTime dateTime;
  final String status;
  final String type;
  final String? patientName;
  final String? patientPhone;
  final String? patientGender;
  final String? patientAge;
  final String? bookingPeriod;
  final String? cancelReason;
  final String? cancelNote;

  const AppointmentEntity({
    required this.id,
    required this.doctor,
    required this.dateTime,
    required this.status,
    required this.type,
    this.patientName,
    this.patientPhone,
    this.patientGender,
    this.patientAge,
    this.bookingPeriod,
    this.cancelReason,
    this.cancelNote,
  });

  AppointmentEntity copyWith({
    String? id,
    DoctorEntity? doctor,
    DateTime? dateTime,
    String? status,
    String? type,
    String? patientName,
    String? patientPhone,
    String? patientGender,
    String? patientAge,
    String? bookingPeriod,
    String? cancelReason,
    String? cancelNote,
  }) {
    return AppointmentEntity(
      id: id ?? this.id,
      doctor: doctor ?? this.doctor,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      type: type ?? this.type,
      patientName: patientName ?? this.patientName,
      patientPhone: patientPhone ?? this.patientPhone,
      patientGender: patientGender ?? this.patientGender,
      patientAge: patientAge ?? this.patientAge,
      bookingPeriod: bookingPeriod ?? this.bookingPeriod,
      cancelReason: cancelReason ?? this.cancelReason,
      cancelNote: cancelNote ?? this.cancelNote,
    );
  }

  @override
  List<Object?> get props => [
        id,
        doctor,
        dateTime,
        status,
        type,
        patientName,
        patientPhone,
        patientGender,
        patientAge,
        bookingPeriod,
        cancelReason,
        cancelNote,
      ];
}
