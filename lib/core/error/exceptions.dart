// ============================================================================
// EXCEPTION HIERARCHY - Core Error Handling System
// ============================================================================
//
// PURPOSE:
// - Define all custom exceptions for the application
// - Exceptions are thrown in the data layer and caught by repositories
// - Repositories convert exceptions to Failures (Either<Failure, Success>)
//
// ARCHITECTURE:
// Data Layer (throws) → Repository (catches & converts) → Domain/Presentation
//
// RULES:
// 1. All exceptions must be specific and descriptive
// 2. Include original error info for debugging
// 3. Support both sync and async operations
// ============================================================================

/// Base exception class for all server-related errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;

  const ServerException({
    this.message = 'Server error occurred',
    this.statusCode,
    this.originalError,
  });

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}

/// Exception for cache/local storage operations
class CacheException implements Exception {
  final String message;
  final dynamic originalError;

  const CacheException({
    this.message = 'Cache error occurred',
    this.originalError,
  });

  @override
  String toString() => 'CacheException: $message';
}

/// Exception for network connectivity issues
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'No internet connection',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// Exception for authentication/authorization failures
class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({
    this.message = 'Authentication failed',
    this.statusCode,
  });

  @override
  String toString() => 'AuthException: $message (Status: $statusCode)';
}

/// Exception for validation errors
class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException({
    this.message = 'Validation failed',
    this.fieldErrors,
  });

  @override
  String toString() => 'ValidationException: $message';
}

/// Exception for timeout errors
class TimeoutException implements Exception {
  final String message;

  const TimeoutException({
    this.message = 'Request timed out',
  });

  @override
  String toString() => 'TimeoutException: $message';
}

/// Exception for unknown/unexpected errors
class UnknownException implements Exception {
  final String message;
  final dynamic originalError;

  const UnknownException({
    this.message = 'An unknown error occurred',
    this.originalError,
  });

  @override
  String toString() => 'UnknownException: $message';
}
