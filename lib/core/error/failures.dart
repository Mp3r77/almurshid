import 'package:equatable/equatable.dart';

// ============================================================================
// FAILURE HIERARCHY - Domain Layer Error Representation
// ============================================================================
//
// PURPOSE:
// - Represent errors in a pure domain way (no external dependencies)
// - Used in Either<Failure, Success> pattern from dartz
// - Displayed to users in the presentation layer
//
// ARCHITECTURE:
// Data Layer throws Exception → Repository catches → Returns Either<Failure, Data>
//
// USAGE:
// result.fold(
//   (failure) => emit(state.copyWith(status: Status.failure, error: failure.message)),
//   (success) => emit(state.copyWith(status: Status.success, data: success)),
// );
//
// RULES:
// 1. Failures are immutable (use Equatable)
// 2. Include user-friendly messages (localizable)
// 3. Include error codes for tracking/debugging
// ============================================================================

/// Base failure class - all failures must extend this
abstract class Failure extends Equatable {
  final String message;
  final String? errorCode;

  const Failure({
    required this.message,
    this.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode];
}

// ============================================================================
// SERVER FAILURES - Backend/API Related
// ============================================================================

/// Generic server failure for 5xx errors
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'Server error occurred. Please try again later.',
    super.errorCode,
  });
}

/// Bad request (400) failure
class BadRequestFailure extends Failure {
  const BadRequestFailure({
    super.message = 'Invalid request',
    super.errorCode,
  });
}

/// Not found (404) failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'Resource not found',
    super.errorCode,
  });
}

/// Internal server error (500) failure
class InternalServerFailure extends Failure {
  const InternalServerFailure({
    super.message = 'Something went wrong. Please try again later.',
    super.errorCode,
  });
}

// ============================================================================
// NETWORK FAILURES - Connectivity Related
// ============================================================================

/// No internet connection failure
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.errorCode,
  });
}

/// Connection timeout failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'Connection timed out. Please try again.',
    super.errorCode,
  });
}

// ============================================================================
// AUTH FAILURES - Authentication/Authorization Related
// ============================================================================

/// Unauthenticated (401) failure
class UnauthenticatedFailure extends Failure {
  const UnauthenticatedFailure({
    super.message = 'Session expired. Please login again.',
    super.errorCode,
  });
}

/// Unauthorized (403) failure
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'You do not have permission to perform this action.',
    super.errorCode,
  });
}

// ============================================================================
// CACHE FAILURES - Local Storage Related
// ============================================================================

/// Cache read failure
class CacheReadFailure extends Failure {
  const CacheReadFailure({
    super.message = 'Unable to load cached data.',
    super.errorCode,
  });
}

/// Cache write failure
class CacheWriteFailure extends Failure {
  const CacheWriteFailure({
    super.message = 'Unable to save data locally.',
    super.errorCode,
  });
}

// ============================================================================
// VALIDATION FAILURES - Input Validation Related
// ============================================================================

/// Validation failure for user input
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    super.message = 'Please check your input.',
    this.fieldErrors,
    super.errorCode,
  });

  @override
  List<Object?> get props => [message, errorCode, fieldErrors];
}

// ============================================================================
// UNKNOWN FAILURES - Catch-All
// ============================================================================

/// Unknown/unexpected failure
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred. Please try again.',
    super.errorCode,
  });
}
