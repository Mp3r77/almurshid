// ============================================================================
// BASE EVENT - Generic Event for all BLoCs
// ============================================================================

import 'package:equatable/equatable.dart';

/// Base event class for all BLoCs
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load data
class LoadDataEvent extends BaseEvent {}

/// Event to refresh data
class RefreshDataEvent extends BaseEvent {}

/// Event to clear data
class ClearDataEvent extends BaseEvent {}

/// Event with parameters
class ParamEvent<T> extends BaseEvent {
  final T params;

  const ParamEvent(this.params);

  @override
  List<Object?> get props => [params];
}
