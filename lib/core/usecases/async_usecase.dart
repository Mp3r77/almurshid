// ============================================================================
// ASYNC USECASE - For streaming/cancellable operations
// ============================================================================
//
// PURPOSE:
// - Base class for use cases that need streaming or cancellation
// - Useful for long-running operations
// - Supports progress reporting
// ============================================================================

import 'dart:async';
import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Stream-based use case for real-time updates
///
/// Example: Real-time search, progress tracking
abstract class StreamUseCase<Type, Params> {
  Stream<Either<Failure, Type>> call(Params params);
}

/// Cancellable use case for abortable operations
///
/// Example: Search with debounce, image upload
abstract class CancellableUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(
    Params params, {
    CancelToken? cancelToken,
  });
}

/// Token for cancelling async operations
class CancelToken {
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;

  void cancel() => _isCancelled = true;
}

/// Progress data for long-running operations
class Progress<T> {
  final T? data;
  final double progress; // 0.0 to 1.0
  final String? message;

  const Progress({
    this.data,
    required this.progress,
    this.message,
  });
}

/// Extension for handling Either in async contexts
extension AsyncEither<L, R> on Future<Either<L, R>> {
  /// Execute success callback, return original Either
  Future<Either<L, R>> whenSuccess(
    Future<void> Function(R data) onSuccess,
  ) async {
    final result = await this;
    result.fold(
      (_) {},
      (data) => onSuccess(data),
    );
    return result;
  }

  /// Execute failure callback, return original Either
  Future<Either<L, R>> whenFailure(
    Future<void> Function(L failure) onFailure,
  ) async {
    final result = await this;
    result.fold(
      (failure) => onFailure(failure),
      (_) {},
    );
    return result;
  }
}
