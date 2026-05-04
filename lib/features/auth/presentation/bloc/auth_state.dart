import 'package:equatable/equatable.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  registered,
  otpSent,
  otpVerified,
  passwordReset,
  providerPendingApproval,
  providerRejected,
  error
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final String? phoneNumber; // Used across forgot password/otp flows

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.phoneNumber,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    String? phoneNumber,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage:
          errorMessage, // We don't always want to persist the old error message
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, phoneNumber];
}
