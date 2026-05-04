import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/user_storage.dart';
import '../../../../models/user.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadHomeDataEvent extends HomeEvent {}

class ChangeBottomNavIndex extends HomeEvent {
  final int index;

  const ChangeBottomNavIndex(this.index);

  @override
  List<Object> get props => [index];
}

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String? errorMessage;
  final int selectedIndex;
  final List<Map<String, dynamic>> categories;
  final User user;

  const HomeState({
    this.status = HomeStatus.initial,
    this.errorMessage,
    this.selectedIndex = 0,
    this.categories = const [],
    this.user = User.defaultUser,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? errorMessage,
    int? selectedIndex,
    List<Map<String, dynamic>>? categories,
    User? user,
  }) {
    return HomeState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      categories: categories ?? this.categories,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props =>
      [status, errorMessage, selectedIndex, categories, user];
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserStorage userStorage;

  HomeBloc({required this.userStorage}) : super(const HomeState()) {
    on<LoadHomeDataEvent>(_onLoadHomeData);
    on<ChangeBottomNavIndex>(_onChangeBottomNavIndex);
  }

  Future<void> _onLoadHomeData(
    LoadHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading));

    // Load user data
    final user = await userStorage.getUser();

    await Future.delayed(const Duration(milliseconds: 600));

    final categories = [
      {
        'id': 'doctors',
        'name': 'الأطباء',
        'icon': 'doctor',
        'color': 0xFF2196F3
      },
      {
        'id': 'diagnostics',
        'name': 'الأشعة والمختبرات',
        'icon': 'diagnostics',
        'color': 0xFF0097A7
      },
      {
        'id': 'pharmacy',
        'name': 'الصيدليات',
        'icon': 'pharmacy',
        'color': 0xFFFF9800
      },
      {
        'id': 'diagnosis',
        'name': 'التشخيص الذكي',
        'icon': 'diagnosis',
        'color': 0xFF7E57C2
      },
    ];

    emit(state.copyWith(
        status: HomeStatus.success, categories: categories, user: user));
  }

  Future<void> _onChangeBottomNavIndex(
    ChangeBottomNavIndex event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
