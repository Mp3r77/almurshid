import 'package:equatable/equatable.dart';
import '../../domain/entities/diagnostic_entities.dart';

enum DiagnosticsStatus { initial, loading, success, failure, bookingSubmitting, bookingSuccess }

class DiagnosticsState extends Equatable {
  final DiagnosticsStatus status;
  final List<DiagnosticCenter> centers;
  final List<DiagnosticCenter> filteredCenters;
  final DiagnosticCenter? selectedCenter;
  final List<DiagnosticService> selectedServices;
  final DiagnosticBooking? currentBooking;
  final String? errorMessage;

  const DiagnosticsState({
    this.status = DiagnosticsStatus.initial,
    this.centers = const [],
    this.filteredCenters = const [],
    this.selectedCenter,
    this.selectedServices = const [],
    this.currentBooking,
    this.errorMessage,
  });

  DiagnosticsState copyWith({
    DiagnosticsStatus? status,
    List<DiagnosticCenter>? centers,
    List<DiagnosticCenter>? filteredCenters,
    DiagnosticCenter? selectedCenter,
    List<DiagnosticService>? selectedServices,
    DiagnosticBooking? currentBooking,
    String? errorMessage,
  }) {
    return DiagnosticsState(
      status: status ?? this.status,
      centers: centers ?? this.centers,
      filteredCenters: filteredCenters ?? this.filteredCenters,
      selectedCenter: selectedCenter ?? this.selectedCenter,
      selectedServices: selectedServices ?? this.selectedServices,
      currentBooking: currentBooking ?? this.currentBooking,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        centers,
        filteredCenters,
        selectedCenter,
        selectedServices,
        currentBooking,
        errorMessage,
      ];
}
