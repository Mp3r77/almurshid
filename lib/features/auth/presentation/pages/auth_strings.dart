import 'package:flutter/widgets.dart';

class AuthStrings {
  final Locale locale;

  const AuthStrings(this.locale);

  bool get isArabic => locale.languageCode == 'ar';

  static AuthStrings of(BuildContext context) {
    return AuthStrings(Localizations.localeOf(context));
  }

  String get loginTitle => isArabic ? 'تسجيل الدخول' : 'Login';
  String get welcomeBack => isArabic ? 'أهلًا بك مجددًا' : 'Welcome Back';
  String get loginSubtitle => isArabic
      ? 'سجل دخولك للوصول إلى ملفك الطبي'
      : 'Sign in to access your medical profile';
  String get phoneNumber => isArabic ? 'رقم الهاتف' : 'Phone Number';
  String get password => isArabic ? 'كلمة المرور' : 'Password';
  String get strongPasswordHint =>
      isArabic ? 'أدخل كلمة مرور قوية' : 'Enter a strong password';
  String get forgotPassword =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';
  String get rememberMe => isArabic ? 'تذكرني' : 'Remember me';
  String get loginButton => isArabic ? 'تسجيل الدخول' : 'Login';
  String get noAccount =>
      isArabic ? 'ليس لديك حساب؟ ' : 'Don\'t have an account? ';
  String get createAccount =>
      isArabic ? 'إنشاء حساب جديد' : 'Create New Account';

  String get forgotPasswordTitle =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot Password?';
  String get forgotPasswordSubtitle => isArabic
      ? 'أدخل رقم هاتفك لإرسال رمز التحقق وإعادة تعيين كلمة المرور'
      : 'Enter your phone number to receive a verification code and reset your password';
  String get sendCode => isArabic ? 'إرسال الرمز' : 'Send Code';
  String get backToLogin => isArabic ? 'العودة لتسجيل الدخول' : 'Back to Login';

  String get verifyAccount =>
      isArabic ? 'التحقق من حسابك' : 'Verify Your Account';
  String otpSentTo(String phone) => isArabic
      ? 'أدخل الرمز المكون من 6 أرقام الذي تم إرساله إلى $phone'
      : 'Enter the 6-digit code sent to $phone';
  String get fallbackPhone => isArabic ? 'رقمك' : 'your number';
  String get enterSixDigits => isArabic
      ? 'الرجاء إدخال الرمز المكون من 6 أرقام'
      : 'Please enter the 6-digit code';
  String get resendCodeHint => isArabic
      ? 'لم تستلم الرمز؟\nإعادة إرسال الرمز في 00:59'
      : 'Didn\'t receive the code?\nResend code in 00:59';
  String get verifyContinue => isArabic ? 'تحقق ومتابعة' : 'Verify & Continue';
  String get genericError => isArabic ? 'حدث خطأ' : 'An error occurred';

  String get resetPasswordTitle =>
      isArabic ? 'تعيين كلمة مرور جديدة' : 'Set a New Password';
  String get resetPasswordSubtitle => isArabic
      ? 'يرجى إدخال كلمة المرور الجديدة القوية والسهلة تذكرها لحماية حسابك الطبي.'
      : 'Enter a strong and memorable new password to protect your medical account.';
  String get newPassword => isArabic ? 'كلمة المرور الجديدة' : 'New Password';
  String get confirmNewPassword =>
      isArabic ? 'تأكيد كلمة المرور الجديدة' : 'Confirm New Password';
  String get passwordsMismatch =>
      isArabic ? 'كلمات المرور غير متطابقة' : 'Passwords do not match';
  String get minLengthRule =>
      isArabic ? '8 أحرف على الأقل' : 'At least 8 characters';
  String get uppercaseRule =>
      isArabic ? 'حرف كبير واحد على الأقل' : 'At least one uppercase letter';
  String get specialCharRule => isArabic
      ? 'رمز خاص واحد (@, #, \$)'
      : 'At least one special character (@, #, \$)';
  String get saveChange => isArabic ? 'حفظ وتغيير' : 'Save & Change';
  String get cancelProcess => isArabic ? 'إلغاء العملية' : 'Cancel';

  String get registerTitle => isArabic ? 'إنشاء حساب' : 'Create Account';
  String get patientWelcome =>
      isArabic ? 'أهلًا بك في تطبيقك الطبي' : 'Welcome to your medical app';
  String get patientRegisterSubtitle => isArabic
      ? 'يرجى إدخال بياناتك لإنشاء حساب مريض للوصول للأطباء والمختبرات'
      : 'Enter your details to create a patient account and access doctors and labs';
  String get fullName => isArabic ? 'الاسم الكامل' : 'Full Name';
  String get fullNameHint =>
      isArabic ? 'أدخل اسمك الثلاثي' : 'Enter your full name';
  String get email => isArabic ? 'البريد الإلكتروني' : 'Email';
  String get agreeTermsError => isArabic
      ? 'يجب الموافقة على شروط الخدمة'
      : 'You must agree to the terms of service';
  String get confirmPassword =>
      isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password';
  String get alreadyHaveAccount =>
      isArabic ? 'لدي حساب بالفعل؟ ' : 'Already have an account? ';
  String get termsPrefix => isArabic ? 'أوافق على ' : 'I agree to the ';
  String get termsOfService => isArabic ? 'شروط الخدمة' : 'Terms of Service';
  String get andWord => isArabic ? ' و ' : ' and ';
  String get privacyPolicy => isArabic ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get appSuffix =>
      isArabic ? ' الخاصة بالتطبيق الطبي.' : ' for the medical application.';

  String get accountTypeTitle =>
      isArabic ? 'اختيار نوع الحساب' : 'Choose Account Type';
  String get createNewAccount =>
      isArabic ? 'إنشاء حساب جديد' : 'Create New Account';
  String get welcomePlatform => isArabic
      ? 'أهلًا بك في منصتك الطبية'
      : 'Welcome to your medical platform';
  String get chooseTrack => isArabic
      ? 'اختر المسار الذي يناسبك لنقدم لك أفضل تجربة رعاية صحية'
      : 'Choose the path that suits you for the best healthcare experience';
  String get patientOption => isArabic ? 'أنا مريض' : 'I am a Patient';
  String get patientOptionSubtitle => isArabic
      ? 'ابحث عن أطباء، احجز مواعيدك، وتابع ملفك الصحي بكل سهولة وأمان'
      : 'Find doctors, book appointments, and manage your health profile easily and safely';
  String get startAsPatient => isArabic ? 'ابدأ كمريض' : 'Start as Patient';
  String get providerOption =>
      isArabic ? 'طبيب / مقدم خدمة' : 'Doctor / Provider';
  String get providerOptionSubtitle => isArabic
      ? 'قدم خدماتك وتابع حالات مرضاك بكل سهولة وأمان'
      : 'Provide your services and follow up with patients easily and safely';
  String get joinAsProvider => isArabic ? 'انضم كمتخصص' : 'Join as Specialist';
  String get labOption =>
      isArabic ? 'مختبر أو أشعة / مقدم خدمة' : 'Lab or Imaging / Provider';
  String get labOptionSubtitle => providerOptionSubtitle;
  String get joinAsLab => isArabic ? 'انضم كمختبر' : 'Join as Lab';
}
