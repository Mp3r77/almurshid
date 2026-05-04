import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterPatientRequested>(_onRegisterPatientRequested);
    on<RegisterProviderRequested>(_onRegisterProviderRequested);
    on<ForgotPasswordRequested>(_onForgotPasswordRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));

    if (event.password == '123456') {
      // Mock condition for provider login
      emit(state.copyWith(status: AuthStatus.providerPendingApproval));
    } else {
      emit(state.copyWith(status: AuthStatus.authenticated));
    }
  }

  Future<void> _onRegisterPatientRequested(
    RegisterPatientRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: AuthStatus.registered));
  }

  Future<void> _onRegisterProviderRequested(
    RegisterProviderRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 2));
    emit(state.copyWith(status: AuthStatus.providerPendingApproval));
  }

  Future<void> _onForgotPasswordRequested(
    ForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(
      status: AuthStatus.otpSent,
      phoneNumber: event.phone,
    ));
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));
    if (event.otp == "123456") {
      emit(state.copyWith(status: AuthStatus.otpVerified));
    } else {
      emit(state.copyWith(
          status: AuthStatus.error, errorMessage: "رمز التحقق غير صحيح"));
    }
  }

  Future<void> _onResetPasswordRequested(
    ResetPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(status: AuthStatus.passwordReset));
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));

    // Simulate API Call
    await Future.delayed(const Duration(milliseconds: 500));
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }
}
