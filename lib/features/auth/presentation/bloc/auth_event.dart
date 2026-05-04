import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String phone;
  final String password;

  const LoginRequested({required this.phone, required this.password});

  @override
  List<Object?> get props => [phone, password];
}

class RegisterPatientRequested extends AuthEvent {
  final String fullName;
  final String phone;
  final String email;
  final String password;

  const RegisterPatientRequested({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, phone, email, password];
}

class RegisterProviderRequested extends AuthEvent {
  final String fullName;
  final String phone;
  final String specialty;
  final String licenseFilePath;
  final String idFilePath;
  // Provider type could be doctor or lab
  final bool isLab;

  const RegisterProviderRequested({
    required this.fullName,
    required this.phone,
    required this.specialty,
    required this.licenseFilePath,
    required this.idFilePath,
    this.isLab = false,
  });

  @override
  List<Object?> get props =>
      [fullName, phone, specialty, licenseFilePath, idFilePath, isLab];
}

class ForgotPasswordRequested extends AuthEvent {
  final String phone;

  const ForgotPasswordRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

class VerifyOtpRequested extends AuthEvent {
  final String phone;
  final String otp;

  const VerifyOtpRequested({required this.phone, required this.otp});

  @override
  List<Object?> get props => [phone, otp];
}

class ResetPasswordRequested extends AuthEvent {
  final String phone;
  final String newPassword;

  const ResetPasswordRequested(
      {required this.phone, required this.newPassword});

  @override
  List<Object?> get props => [phone, newPassword];
}

class LogoutRequested extends AuthEvent {}
