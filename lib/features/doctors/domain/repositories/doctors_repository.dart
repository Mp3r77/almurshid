// ============================================================================
// DOCTORS REPOSITORY CONTRACT - Domain Layer
// ============================================================================
//
// PURPOSE:
// - Abstract interface for data operations
// - Defines contract between domain and data layers
// - No implementation details
//
// ARCHITECTURE:
// Domain Layer (defines) → Data Layer (implements)
//
// RULES:
// 1. Repository is abstract (no implementation)
// 2. Return types are domain entities
// 3. Use Either<Failure, Success> for error handling
// ============================================================================

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/doctor_entity.dart';

/// Abstract repository contract for doctor operations
///
/// This interface defines all doctor-related operations
/// that must be implemented in the data layer
abstract class DoctorsRepository {
  /// Get all available doctors
  ///
  /// Returns Either with:
  /// - [Failure] if operation fails (network, server, etc.)
  /// - [List<DoctorEntity>] if operation succeeds
  Future<Either<Failure, List<DoctorEntity>>> getAllDoctors();

  /// Search doctors by name or specialty
  ///
  /// [query] - Search term (name or specialty)
  ///
  /// Returns Either with:
  /// - [Failure] if operation fails
  /// - [List<DoctorEntity>] matching doctors
  Future<Either<Failure, List<DoctorEntity>>> searchDoctors(String query);

  /// Get doctor by ID
  ///
  /// [doctorId] - Unique doctor identifier
  ///
  /// Returns Either with:
  /// - [Failure] if not found or operation fails
  /// - [DoctorEntity] if found
  Future<Either<Failure, DoctorEntity>> getDoctorById(String doctorId);

  /// Get doctor's available time slots
  ///
  /// [doctorId] - Unique doctor identifier
  /// [date] - Date to check availability
  ///
  /// Returns Either with:
  /// - [Failure] if operation fails
  /// - [List<TimeSlot>] available slots
  Future<Either<Failure, List<Map<String, dynamic>>>> getDoctorAvailability(
    String doctorId,
    DateTime date,
  );
}
