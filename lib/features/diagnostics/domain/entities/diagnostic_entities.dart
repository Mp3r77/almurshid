import 'package:equatable/equatable.dart';

enum DiagnosticType { lab, radiology }

class DiagnosticService extends Equatable {
  final String id;
  final String name;
  final double price;
  final String? description;

  const DiagnosticService({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });

  @override
  List<Object?> get props => [id, name, price, description];
}

class DiagnosticCenter extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String image;
  final String? logoUrl;
  final String rating;
  final int reviewsCount;
  final String distance;
  final String location;
  final DiagnosticType type;
  final List<DiagnosticService> services;
  final bool isOpen;
  final String workingHours;

  const DiagnosticCenter({
    required this.id,
    required this.name,
    this.description,
    required this.image,
    this.logoUrl,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.location,
    required this.type,
    required this.services,
    required this.isOpen,
    required this.workingHours,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        image,
        logoUrl,
        rating,
        reviewsCount,
        distance,
        location,
        type,
        services,
        isOpen,
        workingHours,
      ];
}

enum BookingStatus {
  sent,
  received,
  processing,
  completed,
  cancelled,
}

class DiagnosticBooking extends Equatable {
  final String id;
  final DiagnosticCenter center;
  final List<DiagnosticService> selectedServices;
  final String patientName;
  final String patientPhone;
  final int patientAge;
  final String patientGender;
  final String? prescriptionPath;
  final DateTime appointmentDate;
  final String appointmentTime;
  final BookingStatus status;
  final double totalAmount;
  final DateTime createdAt;

  const DiagnosticBooking({
    required this.id,
    required this.center,
    required this.selectedServices,
    required this.patientName,
    required this.patientPhone,
    required this.patientAge,
    required this.patientGender,
    this.prescriptionPath,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        center,
        selectedServices,
        patientName,
        patientPhone,
        patientAge,
        patientGender,
        prescriptionPath,
        appointmentDate,
        appointmentTime,
        status,
        totalAmount,
        createdAt,
      ];
}
