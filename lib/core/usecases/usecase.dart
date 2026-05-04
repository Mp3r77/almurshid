// ============================================================================
// BASE USECASE - Foundation for all Use Cases
// ============================================================================
//
// PURPOSE:
// - Base class for all use cases following Clean Architecture
// - Enforces the pattern: UseCase<Output, Input>
// - Returns Either<Failure, Output> for error handling
//
// ARCHITECTURE:
// Presentation (BLoC) → UseCase → Repository → DataSource → API/DB
//
// RULES:
// 1. Each use case has ONE responsibility (SRP)
// 2. Use cases are pure Dart (no Flutter dependencies)
// 3. Use cases should be easily testable
// 4. Input should extend UseCaseParams
// ============================================================================

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../error/failures.dart';

/// Abstract base class for all use cases
///
/// Type Parameters:
/// - [Type] - The output type returned on success
/// - [Params] - The input parameters (must extend UseCaseParams)
///
/// Example:
/// ```dart
/// class GetDoctorsUseCase implements UseCase<List<Doctor>, NoParams> {
///   final DoctorsRepository repository;
///
///   GetDoctorsUseCase(this.repository);
///
///   @override
///   Future<Either<Failure, List<Doctor>>> call(NoParams params) {
///     return repository.getDoctors();
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  ///
  /// Returns Either<Failure, Type>:
  /// - Left (Failure) when operation fails
  /// - Right (Type) when operation succeeds
  Future<Either<Failure, Type>> call(Params params);
}

/// Marker class for use case parameters
///
/// All use case parameters should extend this class
/// to ensure type safety and consistency
abstract class UseCaseParams extends Equatable {
  const UseCaseParams();

  /// Create a copy with updated values
  UseCaseParams copyWith();
}

/// Empty parameters class for use cases that don't need input
///
/// Usage:
/// ```dart
/// final result = await getAllDoctors(NoParams());
/// ```
class NoParams extends UseCaseParams {
  const NoParams();

  @override
  List<Object?> get props => [];

  @override
  NoParams copyWith() => const NoParams();
}

// ============================================================================
// USECASE RESULT - Alternative to Either for simpler cases
// ============================================================================

/// A simple Result type for use cases
///
/// This is an alternative to Either<Failure, T> for simpler cases
/// where you don't need the full power of dartz
sealed class UseCaseResult<T> {
  const UseCaseResult();
}

class UseCaseSuccess<T> extends UseCaseResult<T> {
  final T data;
  const UseCaseSuccess(this.data);
}

class UseCaseError<T> extends UseCaseResult<T> {
  final Failure failure;
  const UseCaseError(this.failure);
}

/// Extension to convert Either to UseCaseResult
extension EitherToResult<L, R> on Either<L, R> {
  UseCaseResult<R> toResult() {
    return fold(
      (l) => UseCaseError(l as Failure),
      (r) => UseCaseSuccess(r),
    );
  }
}
