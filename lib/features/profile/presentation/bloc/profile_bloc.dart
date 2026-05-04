import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  static const _languageKey = 'profile_language';
  static const _bookingReminderKey = 'profile_booking_reminder';
  static const _messageAlertsKey = 'profile_message_alerts';
  static const _medicalOffersKey = 'profile_medical_offers';
  static const _rescheduleAlertsKey = 'profile_reschedule_alerts';
  static const _smartDiagnosisAlertsKey = 'profile_smart_diagnosis_alerts';
  static const _biometricLoginKey = 'profile_biometric_login';
  static const _faceRecognitionKey = 'profile_face_recognition';
  static const _privacyModeKey = 'profile_privacy_mode';
  static const _twoFactorKey = 'profile_two_factor';
  static const _birthDateKey = 'profile_birth_date';
  static const _genderKey = 'profile_gender';
  static const _bloodTypeKey = 'profile_blood_type';

  ProfileBloc() : super(ProfileState.initial()) {
    on<LoadProfilePreferences>(_onLoadProfilePreferences);
    on<SavePersonalInfo>(_onSavePersonalInfo);
    on<UpdateProfileImage>(_onUpdateProfileImage);
    on<ToggleBookingReminders>(_onToggleBookingReminders);
    on<ToggleMessageAlerts>(_onToggleMessageAlerts);
    on<ToggleMedicalOffers>(_onToggleMedicalOffers);
    on<ToggleRescheduleAlerts>(_onToggleRescheduleAlerts);
    on<ToggleSmartDiagnosisAlerts>(_onToggleSmartDiagnosisAlerts);
    on<ChangeAppLanguage>(_onChangeAppLanguage);
    on<ToggleBiometricLogin>(_onToggleBiometricLogin);
    on<ToggleFaceRecognition>(_onToggleFaceRecognition);
    on<ChangePrivacyMode>(_onChangePrivacyMode);
    on<ToggleTwoFactorVerification>(_onToggleTwoFactorVerification);
    on<ToggleFaqItem>(_onToggleFaqItem);
  }

  Future<void> _onLoadProfilePreferences(
    LoadProfilePreferences event,
    Emitter<ProfileState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(
      language: prefs.getString(_languageKey) ?? 'العربية',
      bookingReminders: prefs.getBool(_bookingReminderKey) ?? true,
      messageAlerts: prefs.getBool(_messageAlertsKey) ?? true,
      medicalOffers: prefs.getBool(_medicalOffersKey) ?? false,
      rescheduleAlerts: prefs.getBool(_rescheduleAlertsKey) ?? true,
      smartDiagnosisAlerts: prefs.getBool(_smartDiagnosisAlertsKey) ?? true,
      biometricLogin: prefs.getBool(_biometricLoginKey) ?? true,
      faceRecognition: prefs.getBool(_faceRecognitionKey) ?? false,
      privacyMode: prefs.getString(_privacyModeKey) ?? 'doctors_only',
      twoFactorVerification: prefs.getBool(_twoFactorKey) ?? false,
      birthDate: prefs.getString(_birthDateKey) ?? '12 / 05 / 1990',
      gender: prefs.getString(_genderKey) ?? 'ذكر',
      bloodType: prefs.getString(_bloodTypeKey) ?? 'A+',
      expandedFaqIndex: null,
    ));
  }

  Future<void> _onSavePersonalInfo(
    SavePersonalInfo event,
    Emitter<ProfileState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_birthDateKey, event.birthDate);
    await prefs.setString(_genderKey, event.gender);
    await prefs.setString(_bloodTypeKey, event.bloodType);

    emit(state.copyWith(
      birthDate: event.birthDate,
      gender: event.gender,
      bloodType: event.bloodType,
    ));
  }

  void _onUpdateProfileImage(
    UpdateProfileImage event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(localProfileImage: event.imagePath));
  }

  Future<void> _onToggleBookingReminders(
    ToggleBookingReminders event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_bookingReminderKey, event.value);
    emit(state.copyWith(bookingReminders: event.value));
  }

  Future<void> _onToggleMessageAlerts(
    ToggleMessageAlerts event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_messageAlertsKey, event.value);
    emit(state.copyWith(messageAlerts: event.value));
  }

  Future<void> _onToggleMedicalOffers(
    ToggleMedicalOffers event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_medicalOffersKey, event.value);
    emit(state.copyWith(medicalOffers: event.value));
  }

  Future<void> _onToggleRescheduleAlerts(
    ToggleRescheduleAlerts event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_rescheduleAlertsKey, event.value);
    emit(state.copyWith(rescheduleAlerts: event.value));
  }

  Future<void> _onToggleSmartDiagnosisAlerts(
    ToggleSmartDiagnosisAlerts event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_smartDiagnosisAlertsKey, event.value);
    emit(state.copyWith(smartDiagnosisAlerts: event.value));
  }

  Future<void> _onChangeAppLanguage(
    ChangeAppLanguage event,
    Emitter<ProfileState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, event.language);
    emit(state.copyWith(language: event.language));
  }

  Future<void> _onToggleBiometricLogin(
    ToggleBiometricLogin event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_biometricLoginKey, event.value);
    emit(state.copyWith(biometricLogin: event.value));
  }

  Future<void> _onToggleFaceRecognition(
    ToggleFaceRecognition event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_faceRecognitionKey, event.value);
    emit(state.copyWith(faceRecognition: event.value));
  }

  Future<void> _onChangePrivacyMode(
    ChangePrivacyMode event,
    Emitter<ProfileState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_privacyModeKey, event.mode);
    emit(state.copyWith(privacyMode: event.mode));
  }

  Future<void> _onToggleTwoFactorVerification(
    ToggleTwoFactorVerification event,
    Emitter<ProfileState> emit,
  ) async {
    await _saveBool(_twoFactorKey, event.value);
    emit(state.copyWith(twoFactorVerification: event.value));
  }

  void _onToggleFaqItem(
    ToggleFaqItem event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        expandedFaqIndex:
            state.expandedFaqIndex == event.index ? null : event.index,
      ),
    );
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }
}
