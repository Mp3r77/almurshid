// ============================================================================
// BASE BLOC - Generic BLoC for common operations
// ============================================================================

import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_event.dart';
import 'base_state.dart';

/// Base BLoC that handles common operations
/// Reduces boilerplate code for simple CRUD operations
abstract class BaseBloc<Event extends BaseEvent,
    State extends BaseState<dynamic>> extends Bloc<Event, State> {
  BaseBloc(super.initialState);

  /// Handle load event
  void onLoad(Event event, Emitter<State> emit) {
    emit(state.copyWith(status: Status.loading) as State);
  }

  /// Handle refresh event
  void onRefresh(Event event, Emitter<State> emit) {
    emit(state.copyWith(status: Status.loading) as State);
  }

  /// Handle clear event
  void onClear(Event event, Emitter<State> emit) {
    emit(state.copyWith(status: Status.initial, data: null, errorMessage: null)
        as State);
  }

  /// Handle success
  void handleSuccess(dynamic data, Emitter<State> emit) {
    emit(state.copyWith(status: Status.success, data: data) as State);
  }

  /// Handle failure
  void handleFailure(String message, Emitter<State> emit) {
    emit(
        state.copyWith(status: Status.failure, errorMessage: message) as State);
  }
}

/// Mixin for handling async operations with Either pattern
mixin EitherHandler {
  /// Handle result from Either<Failure, Success>
  void handleEither<T>(
    dynamic result,
    Emitter<dynamic> emit,
    void Function(dynamic) onSuccess,
    void Function(String) onFailure,
  ) {
    result.fold(
      (failure) => onFailure(failure.message),
      (data) => onSuccess(data),
    );
  }
}
