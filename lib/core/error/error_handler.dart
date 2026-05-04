import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Utility class for handling and converting exceptions to failures
class ErrorHandler {
  /// Converts any exception to appropriate Failure
  ///
  /// This method should be used in all repository implementations
  /// to ensure consistent error handling across the app.
  static Failure handleException(dynamic error) {
    // Log error for debugging (in debug mode)
    _logError(error);

    // Handle Dio exceptions
    if (error is DioException) {
      return _handleDioException(error);
    }

    // Handle custom exceptions
    if (error is ServerException) {
      return ServerFailure(message: error.message);
    }

    if (error is CacheException) {
      return const CacheReadFailure();
    }

    if (error is NetworkException) {
      return const NetworkFailure();
    }

    if (error is AuthException) {
      return const UnauthenticatedFailure();
    }

    if (error is ValidationException) {
      return ValidationFailure(
        message: error.message,
        fieldErrors: error.fieldErrors,
      );
    }

    if (error is TimeoutException) {
      return const TimeoutFailure();
    }

    // Default to unknown failure
    return UnknownFailure(
      message: error?.toString() ?? 'Unknown error occurred',
    );
  }

  /// Handles Dio-specific exceptions
  static Failure _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure();

      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'SSL certificate error');

      case DioExceptionType.unknown:
      default:
        if (error.error is NetworkException) {
          return const NetworkFailure();
        }
        return UnknownFailure(message: error.message ?? 'Unknown error');
    }
  }

  /// Handles HTTP bad responses (4xx, 5xx)
  static Failure _handleBadResponse(Response? response) {
    if (response == null) {
      return const UnknownFailure();
    }

    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    // Extract message from response if available
    String message = 'Server error';
    if (data is Map<String, dynamic> && data.containsKey('message')) {
      message = data['message'].toString();
    }

    switch (statusCode) {
      // 400 Bad Request
      case 400:
        return BadRequestFailure(
          message: message,
          errorCode: 'BAD_REQUEST',
        );

      // 401 Unauthorized
      case 401:
        return const UnauthenticatedFailure(
          errorCode: 'UNAUTHORIZED',
        );

      // 403 Forbidden
      case 403:
        return const UnauthorizedFailure(
          errorCode: 'FORBIDDEN',
        );

      // 404 Not Found
      case 404:
        return NotFoundFailure(
          message: message,
          errorCode: 'NOT_FOUND',
        );

      // 422 Validation Error
      case 422:
        Map<String, String>? fieldErrors;
        if (data is Map<String, dynamic> && data.containsKey('errors')) {
          fieldErrors = Map<String, String>.from(
            (data['errors'] as Map).map(
              (key, value) => MapEntry(
                key.toString(),
                (value as List).join(', '),
              ),
            ),
          );
        }
        return ValidationFailure(
          message: message,
          fieldErrors: fieldErrors,
          errorCode: 'VALIDATION_ERROR',
        );

      // 429 Too Many Requests
      case 429:
        return const ServerFailure(
          message: 'Too many requests. Please wait and try again.',
          errorCode: 'RATE_LIMITED',
        );

      // 500 Internal Server Error
      case 500:
      case 502:
      case 503:
      case 504:
      default:
        return InternalServerFailure(
          message: message,
          errorCode: 'SERVER_ERROR_$statusCode',
        );
    }
  }

  /// Logs error in debug mode only
  static void _logError(dynamic error) {
    assert(() {
      debugPrint('ErrorHandler: $error');
      return true;
    }());
  }
}
