import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _localeKey = 'app_locale';

  LocaleCubit() : super(const Locale('ar')) {
    _loadInitialLocale();
  }

  Future<void> setArabic() async {
    await _setLocale(const Locale('ar'));
  }

  Future<void> setEnglish() async {
    await _setLocale(const Locale('en'));
  }

  Future<void> _setLocale(Locale locale) async {
    emit(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> _loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_localeKey) ?? 'ar';
    emit(Locale(code));
  }
}
