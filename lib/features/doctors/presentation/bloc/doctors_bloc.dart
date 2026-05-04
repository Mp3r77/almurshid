// ============================================================================
// DOCTORS BLoC - Presentation Layer
// ============================================================================
//
// PURPOSE:
// - Handle UI state management for doctors feature
// - Process events and emit states
// - Use use cases for business logic
//
// ARCHITECTURE:
// UI Event → BLoC → UseCase → Repository → DataSource
//
// STATE MANAGEMENT:
// - States are immutable (Equatable)
// - Events trigger state changes
// - Only emit new states, never modify existing
// ============================================================================

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_all_doctors.dart';
import '../../domain/usecases/search_doctors.dart';
import 'doctors_event.dart';
import 'doctors_state.dart';

/// Doctors BLoC for managing doctor-related UI state
///
/// Handles:
/// - Loading all doctors
/// - Searching doctors with debounce
/// - Error handling
/// - Loading states
@injectable
class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final GetAllDoctors _getAllDoctors;
  final SearchDoctors _searchDoctors;

  // For debouncing search
  Timer? _debounceTimer;

  DoctorsBloc({
    required GetAllDoctors getAllDoctors,
    required SearchDoctors searchDoctors,
  })  : _getAllDoctors = getAllDoctors,
        _searchDoctors = searchDoctors,
        super(DoctorsState.initial()) {
    // Register event handlers
    on<LoadDoctorsEvent>(_onLoadDoctors);
    on<SearchDoctorsEvent>(_onSearchDoctors);
    on<SearchQueryChangedEvent>(_onSearchQueryChanged);
    on<ClearSearchEvent>(_onClearSearch);
  }

  /// Handle load doctors event
  Future<void> _onLoadDoctors(
    LoadDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    emit(state.copyWith(
      status: DoctorsStatus.loading,
      searchQuery: '',
    ));

    final result = await _getAllDoctors(const NoParams());

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorsStatus.failure,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: DoctorsStatus.success,
        doctors: doctors,
        filteredDoctors: doctors,
      )),
    );
  }

  /// Handle search doctors event (immediate)
  Future<void> _onSearchDoctors(
    SearchDoctorsEvent event,
    Emitter<DoctorsState> emit,
  ) async {
    _debounceTimer?.cancel();

    if (event.query.isEmpty) {
      // Load all if empty search
      add(LoadDoctorsEvent());
      return;
    }

    emit(state.copyWith(
      status: DoctorsStatus.loading,
      searchQuery: event.query,
    ));

    final result = await _searchDoctors(
      SearchDoctorsParams(query: event.query),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: DoctorsStatus.failure,
        errorMessage: failure.message,
      )),
      (doctors) => emit(state.copyWith(
        status: DoctorsStatus.success,
        filteredDoctors: doctors,
      )),
    );
  }

  /// Handle search query change (with debounce)
  void _onSearchQueryChanged(
    SearchQueryChangedEvent event,
    Emitter<DoctorsState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      add(SearchDoctorsEvent(event.query));
    });
  }

  /// Handle clear search event
  void _onClearSearch(
    ClearSearchEvent event,
    Emitter<DoctorsState> emit,
  ) {
    _debounceTimer?.cancel();
    emit(state.copyWith(
      searchQuery: '',
      filteredDoctors: state.doctors,
    ));
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
