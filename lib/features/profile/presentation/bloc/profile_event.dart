part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfilePreferences extends ProfileEvent {
  const LoadProfilePreferences();
}

class SavePersonalInfo extends ProfileEvent {
  final String birthDate;
  final String gender;
  final String bloodType;

  const SavePersonalInfo({
    required this.birthDate,
    required this.gender,
    required this.bloodType,
  });

  @override
  List<Object?> get props => [birthDate, gender, bloodType];
}

class UpdateProfileImage extends ProfileEvent {
  final String imagePath;

  const UpdateProfileImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}

class ToggleBookingReminders extends ProfileEvent {
  final bool value;

  const ToggleBookingReminders(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleMessageAlerts extends ProfileEvent {
  final bool value;

  const ToggleMessageAlerts(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleMedicalOffers extends ProfileEvent {
  final bool value;

  const ToggleMedicalOffers(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleRescheduleAlerts extends ProfileEvent {
  final bool value;

  const ToggleRescheduleAlerts(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleSmartDiagnosisAlerts extends ProfileEvent {
  final bool value;

  const ToggleSmartDiagnosisAlerts(this.value);

  @override
  List<Object?> get props => [value];
}

class ChangeAppLanguage extends ProfileEvent {
  final String language;

  const ChangeAppLanguage(this.language);

  @override
  List<Object?> get props => [language];
}

class ToggleBiometricLogin extends ProfileEvent {
  final bool value;

  const ToggleBiometricLogin(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleFaceRecognition extends ProfileEvent {
  final bool value;

  const ToggleFaceRecognition(this.value);

  @override
  List<Object?> get props => [value];
}

class ChangePrivacyMode extends ProfileEvent {
  final String mode;

  const ChangePrivacyMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ToggleTwoFactorVerification extends ProfileEvent {
  final bool value;

  const ToggleTwoFactorVerification(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleFaqItem extends ProfileEvent {
  final int index;

  const ToggleFaqItem(this.index);

  @override
  List<Object?> get props => [index];
}
