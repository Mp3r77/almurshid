// ============================================================================
// USER BLOC
// ============================================================================
//
// Manages user data state across the application.
// Provides a centralized way to access and update user information.
// ============================================================================

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/user_storage.dart';
import '../../../models/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends UserEvent {}

class UpdateUserEvent extends UserEvent {
  final User user;

  const UpdateUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class UserState extends Equatable {
  final User user;
  final bool isLoading;

  const UserState({
    required this.user,
    this.isLoading = false,
  });

  UserState copyWith({
    User? user,
    bool? isLoading,
  }) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [user, isLoading];
}

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserStorage userStorage;

  UserBloc({required this.userStorage})
      : super(const UserState(user: User.defaultUser)) {
    on<LoadUserEvent>(_onLoadUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onLoadUser(
    LoadUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final user = await userStorage.getUser();
    emit(state.copyWith(user: user, isLoading: false));
  }

  Future<void> _onUpdateUser(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    await userStorage.saveUser(event.user);
    emit(state.copyWith(user: event.user, isLoading: false));
  }
}
