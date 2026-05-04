// ============================================================================
// BASE STATE - Generic State for all BLoCs
// ============================================================================

import 'package:equatable/equatable.dart';

/// Enum for common status values
enum Status { initial, loading, success, failure, empty }

/// Base state class that can be extended by all BLoCs
/// Reduces code duplication across features
abstract class BaseState<T> extends Equatable {
  final Status status;
  final T? data;
  final String? errorMessage;

  const BaseState({
    this.status = Status.initial,
    this.data,
    this.errorMessage,
  });

  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isFailure => status == Status.failure;
  bool get isEmpty => status == Status.empty;
  bool get isInitial => status == Status.initial;

  @override
  List<Object?> get props => [status, data, errorMessage];
}

/// Factory for creating initial states
class StateFactory {
  static BaseState<T> initial<T>() {
    return _InitialState<T>();
  }

  static BaseState<T> loading<T>() {
    return _LoadingState<T>();
  }

  static BaseState<T> success<T>(T data) {
    return _SuccessState<T>(data);
  }

  static BaseState<T> failure<T>(String message) {
    return _FailureState<T>(message);
  }

  static BaseState<T> empty<T>() {
    return _EmptyState<T>();
  }
}

// Private implementations
class _InitialState<T> extends BaseState<T> {
  const _InitialState() : super(status: Status.initial);
}

class _LoadingState<T> extends BaseState<T> {
  const _LoadingState() : super(status: Status.loading);
}

class _SuccessState<T> extends BaseState<T> {
  const _SuccessState(T data) : super(status: Status.success, data: data);
}

class _FailureState<T> extends BaseState<T> {
  const _FailureState(String message)
      : super(status: Status.failure, errorMessage: message);
}

class _EmptyState<T> extends BaseState<T> {
  const _EmptyState() : super(status: Status.empty);
}

// Extension for easy state creation
extension StateExtension<T> on BaseState<T> {
  BaseState<T> copyWith({
    Status? status,
    T? data,
    String? errorMessage,
  }) {
    return _CopiedState<T>(
      status: status ?? this.status,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class _CopiedState<T> extends BaseState<T> {
  const _CopiedState({
    required super.status,
    required super.data,
    required super.errorMessage,
  });
}
