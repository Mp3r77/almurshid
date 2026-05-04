import 'package:flutter/widgets.dart';

extension LocaleTextExtension on BuildContext {
  bool get isArabicLocale => Localizations.localeOf(this).languageCode == 'ar';

  String tr(String ar, String en) {
    return isArabicLocale ? ar : en;
  }
}
