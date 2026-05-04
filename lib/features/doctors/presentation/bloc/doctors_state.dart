// ============================================================================
// DOCTORS STATE - BLoC State
// ============================================================================

import 'package:equatable/equatable.dart';
import '../../domain/entities/doctor_entity.dart';

/// Status enum for doctors loading state
enum DoctorsStatus {
  initial,
  loading,
  success,
  failure,
  empty,
}

/// Immutable state class for doctors BLoC
class DoctorsState extends Equatable {
  final List<DoctorEntity> doctors;
  final List<DoctorEntity> filteredDoctors;
  final DoctorsStatus status;
  final String? errorMessage;
  final String searchQuery;
  final bool isSearching;

  const DoctorsState({
    required this.doctors,
    required this.filteredDoctors,
    required this.status,
    this.errorMessage,
    required this.searchQuery,
    required this.isSearching,
  });

  /// Initial state factory
  factory DoctorsState.initial() {
    return const DoctorsState(
      doctors: [],
      filteredDoctors: [],
      status: DoctorsStatus.initial,
      searchQuery: '',
      isSearching: false,
    );
  }

  /// Copy with new values
  DoctorsState copyWith({
    List<DoctorEntity>? doctors,
    List<DoctorEntity>? filteredDoctors,
    DoctorsStatus? status,
    String? errorMessage,
    String? searchQuery,
    bool? isSearching,
  }) {
    return DoctorsState(
      doctors: doctors ?? this.doctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      status: status ?? this.status,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  /// Check if data is loading
  bool get isLoading => status == DoctorsStatus.loading;

  /// Check if data loaded successfully
  bool get isSuccess => status == DoctorsStatus.success;

  /// Check if there's an error
  bool get isFailure => status == DoctorsStatus.failure;

  /// Check if search returned no results
  bool get isEmpty =>
      status == DoctorsStatus.success &&
      searchQuery.isNotEmpty &&
      filteredDoctors.isEmpty;

  /// Get doctors to display (filtered if searching, all otherwise)
  List<DoctorEntity> get displayDoctors =>
      searchQuery.isEmpty ? doctors : filteredDoctors;

  @override
  List<Object?> get props => [
        doctors,
        filteredDoctors,
        status,
        errorMessage,
        searchQuery,
        isSearching,
      ];
}
