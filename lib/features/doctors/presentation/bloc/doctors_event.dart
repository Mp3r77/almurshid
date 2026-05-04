// ============================================================================
// DOCTORS EVENT - BLoC Events
// ============================================================================

import 'package:equatable/equatable.dart';

/// Base class for doctors events
abstract class DoctorsEvent extends Equatable {
  const DoctorsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all doctors
class LoadDoctorsEvent extends DoctorsEvent {}

/// Event to search doctors (debounced)
class SearchQueryChangedEvent extends DoctorsEvent {
  final String query;

  const SearchQueryChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to search doctors (immediate)
class SearchDoctorsEvent extends DoctorsEvent {
  final String query;

  const SearchDoctorsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

/// Event to clear search and show all doctors
class ClearSearchEvent extends DoctorsEvent {}
