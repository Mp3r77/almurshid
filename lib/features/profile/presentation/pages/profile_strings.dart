import 'package:flutter/widgets.dart';

class ProfileStrings {
  final Locale locale;

  const ProfileStrings(this.locale);

  bool get isArabic => locale.languageCode == 'ar';

  static ProfileStrings of(BuildContext context) {
    return ProfileStrings(Localizations.localeOf(context));
  }

  String get profileTitle => isArabic ? 'الملف الشخصي' : 'Profile';
  String get personalInfoTitle =>
      isArabic ? 'البيانات الشخصية' : 'Personal Info';
  String get securityPrivacyTitle =>
      isArabic ? 'الأمان والخصوصية' : 'Security & Privacy';
  String get settingsAlertsTitle =>
      isArabic ? 'الإعدادات والتنبيهات' : 'Settings & Alerts';
  String get helpCenterTitle => isArabic ? 'مركز المساعدة' : 'Help Center';
  String get fullNameField => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get phoneField => isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get emailField => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get birthDateField => isArabic ? 'تاريخ الميلاد' : 'Birth Date';
  String get genderField => isArabic ? 'الجنس' : 'Gender';
  String get bloodTypeField => isArabic ? 'فصيلة الدم' : 'Blood Type';
  String get saveChanges => isArabic ? 'حفظ التغييرات' : 'Save Changes';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Log Out';
  String get changeProfilePhoto =>
      isArabic ? 'تغيير الصورة الشخصية' : 'Change Profile Photo';
  String get editBasicInfo =>
      isArabic ? 'تعديل معلوماتك الأساسية' : 'Edit your basic information';
  String get managePasswordPrivacy => isArabic
      ? 'إدارة كلمة المرور والبيانات المخزنة'
      : 'Manage password and stored data';
  String get appLanguageAlerts =>
      isArabic ? 'اللغة وتنبيهات التطبيق' : 'Language and app alerts';
  String get faqAndSupport =>
      isArabic ? 'الأسئلة الشائعة والدعم الفني' : 'FAQs and technical support';
  String get profileSaved =>
      isArabic ? 'تم حفظ البيانات الشخصية' : 'Personal information saved';
  String get camera => isArabic ? 'الكاميرا' : 'Camera';
  String get gallery => isArabic ? 'المعرض' : 'Gallery';
  String get passwordSection => isArabic ? 'كلمة المرور' : 'Password';
  String get changePassword =>
      isArabic ? 'تغيير كلمة المرور' : 'Change Password';
  String get passkeys => isArabic ? 'كلمة المرور (Passkeys)' : 'Passkeys';
  String get biometricSection =>
      isArabic ? 'الأمان الحيوي' : 'Biometric Security';
  String get biometricLogin =>
      isArabic ? 'تسجيل الدخول بالبصمة' : 'Biometric Login';
  String get faceRecognition =>
      isArabic ? 'التعرف على الوجه' : 'Face Recognition';
  String get privacySection => isArabic ? 'الخصوصية' : 'Privacy';
  String get whoCanSeeMedicalFile =>
      isArabic ? 'من يمكنه رؤية ملفي الطبي؟' : 'Who can see my medical file?';
  String get privacyDoctorsOnly =>
      isArabic ? 'الأطباء المخولون برقم فقط' : 'Authorized doctors only';
  String get privacyAllStaff =>
      isArabic ? 'الكل (جميع العاملين في المنصة)' : 'All staff on the platform';
  String get twoFactor =>
      isArabic ? 'التحقق بخطوتين' : 'Two-factor verification';
  String get passwordServerLater => isArabic
      ? 'سيتم ربط تغيير كلمة المرور بالخادم'
      : 'Password change will be connected to the server later';
  String get passkeysSoon =>
      isArabic ? 'Passkeys قيد الإضافة' : 'Passkeys integration is coming soon';
  String get appLanguage => isArabic ? 'لغة التطبيق' : 'App Language';
  String get appSettings => isArabic ? 'إعدادات التطبيق' : 'App Settings';
  String get bookingAlerts =>
      isArabic ? 'تنبيهات المواعيد' : 'Appointment Alerts';
  String get bookingAlertsSub => isArabic
      ? 'قبل موعدك بساعة أو عند تعديل الموعد'
      : 'One hour before your appointment or when it changes';
  String get messageAlerts => isArabic ? 'تنبيهات الرسائل' : 'Message Alerts';
  String get messageAlertsSub => isArabic
      ? 'تنبيه عند وصول رسائل جديدة من الطبيب'
      : 'Notify when new doctor messages arrive';
  String get medicalOffers => isArabic ? 'العروض الطبية' : 'Medical Offers';
  String get medicalOffersSub => isArabic
      ? 'خصومات وتنبيهات الفحوصات والعيادات'
      : 'Discounts and clinic/lab offer alerts';
  String get appointmentStatusChange =>
      isArabic ? 'تغيير حالة الموعد' : 'Appointment Status Changes';
  String get appointmentStatusChangeSub => isArabic
      ? 'عند تأكيد أو إلغاء أو إعادة الجدولة'
      : 'When appointments are confirmed, cancelled, or rescheduled';
  String get smartDiagnosisResults =>
      isArabic ? 'نتائج التشخيص الذكي' : 'Smart Diagnosis Results';
  String get smartDiagnosisResultsSub => isArabic
      ? 'إشعار عند تجهيز نتيجة تحليل الأعراض'
      : 'Notify when symptom analysis is ready';
  String get faqTitle =>
      isArabic ? 'الأسئلة الشائعة' : 'Frequently Asked Questions';
  String get contactUs => isArabic ? 'تواصل معنا' : 'Contact Us';
  String get liveChat => isArabic ? 'المحادثة المباشرة' : 'Live Chat';
  String get liveChatSub => isArabic
      ? 'دعم فوري مع فريق الدعم الآن'
      : 'Instant support with the team';
  String get phoneCall => isArabic ? 'الاتصال الهاتفي' : 'Phone Call';
  String get phoneCallSub => isArabic
      ? 'متاح 24/7 للحالات العاجلة'
      : 'Available 24/7 for urgent cases';
  String get supportEmail => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get supportEmailSub =>
      isArabic ? 'نرد خلال 24 ساعة' : 'We reply within 24 hours';
  String get liveChatSoon => isArabic
      ? 'سيتم ربط المحادثة المباشرة قريبًا'
      : 'Live chat will be connected soon';
  String get supportPhoneValue =>
      isArabic ? 'رقم الدعم: 920000000' : 'Support number: 920000000';
  String get supportEmailValue =>
      isArabic ? 'support@almurshid.app' : 'support@almurshid.app';

  String get faqCancelQuestion => isArabic
      ? 'كيف يمكنني إلغاء موعد محجوز؟'
      : 'How can I cancel a booked appointment?';
  String get faqCancelAnswer => isArabic
      ? 'من صفحة مواعيدي اختر الموعد المطلوب ثم اضغط إلغاء الموعد وحدد السبب.'
      : 'Open My Appointments, choose the appointment, then tap cancel and select a reason.';
  String get faqPaymentQuestion => isArabic
      ? 'ما هي طرق الدفع المتاحة؟'
      : 'What payment methods are available?';
  String get faqPaymentAnswer => isArabic
      ? 'يمكنك الدفع نقدًا أو عبر الوسائل الإلكترونية المتاحة عند ربط بوابة الدفع.'
      : 'You can pay in cash or through available electronic payment methods once the gateway is connected.';
  String get faqEditProfileQuestion => isArabic
      ? 'هل يمكنني تعديل بياناتي الشخصية؟'
      : 'Can I edit my personal information?';
  String get faqEditProfileAnswer => isArabic
      ? 'نعم، من صفحة البيانات الشخصية يمكنك تعديل الاسم والهاتف والبريد والصورة.'
      : 'Yes. From Personal Info, you can edit your name, phone, email, and profile photo.';
}
