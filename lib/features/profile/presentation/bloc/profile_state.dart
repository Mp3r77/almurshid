part of 'profile_bloc.dart';

class ProfileState extends Equatable {
  final String language;
  final bool bookingReminders;
  final bool messageAlerts;
  final bool medicalOffers;
  final bool rescheduleAlerts;
  final bool smartDiagnosisAlerts;
  final bool biometricLogin;
  final bool faceRecognition;
  final String privacyMode;
  final bool twoFactorVerification;
  final String birthDate;
  final String gender;
  final String bloodType;
  final int? expandedFaqIndex;
  final String? localProfileImage;

  const ProfileState({
    required this.language,
    required this.bookingReminders,
    required this.messageAlerts,
    required this.medicalOffers,
    required this.rescheduleAlerts,
    required this.smartDiagnosisAlerts,
    required this.biometricLogin,
    required this.faceRecognition,
    required this.privacyMode,
    required this.twoFactorVerification,
    required this.birthDate,
    required this.gender,
    required this.bloodType,
    required this.expandedFaqIndex,
    this.localProfileImage,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      language: 'العربية',
      bookingReminders: true,
      messageAlerts: true,
      medicalOffers: false,
      rescheduleAlerts: true,
      smartDiagnosisAlerts: true,
      biometricLogin: true,
      faceRecognition: false,
      privacyMode: 'doctors_only',
      twoFactorVerification: false,
      birthDate: '12 / 05 / 1990',
      gender: 'ذكر',
      bloodType: 'A+',
      expandedFaqIndex: null,
    );
  }

  ProfileState copyWith({
    String? language,
    bool? bookingReminders,
    bool? messageAlerts,
    bool? medicalOffers,
    bool? rescheduleAlerts,
    bool? smartDiagnosisAlerts,
    bool? biometricLogin,
    bool? faceRecognition,
    String? privacyMode,
    bool? twoFactorVerification,
    String? birthDate,
    String? gender,
    String? bloodType,
    Object? expandedFaqIndex = _sentinel,
    Object? localProfileImage = _sentinel,
  }) {
    return ProfileState(
      language: language ?? this.language,
      bookingReminders: bookingReminders ?? this.bookingReminders,
      messageAlerts: messageAlerts ?? this.messageAlerts,
      medicalOffers: medicalOffers ?? this.medicalOffers,
      rescheduleAlerts: rescheduleAlerts ?? this.rescheduleAlerts,
      smartDiagnosisAlerts: smartDiagnosisAlerts ?? this.smartDiagnosisAlerts,
      biometricLogin: biometricLogin ?? this.biometricLogin,
      faceRecognition: faceRecognition ?? this.faceRecognition,
      privacyMode: privacyMode ?? this.privacyMode,
      twoFactorVerification:
          twoFactorVerification ?? this.twoFactorVerification,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      expandedFaqIndex: identical(expandedFaqIndex, _sentinel)
          ? this.expandedFaqIndex
          : expandedFaqIndex as int?,
      localProfileImage: identical(localProfileImage, _sentinel)
          ? this.localProfileImage
          : localProfileImage as String?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [
        language,
        bookingReminders,
        messageAlerts,
        medicalOffers,
        rescheduleAlerts,
        smartDiagnosisAlerts,
        biometricLogin,
        faceRecognition,
        privacyMode,
        twoFactorVerification,
        birthDate,
        gender,
        bloodType,
        expandedFaqIndex,
        localProfileImage,
      ];
}
