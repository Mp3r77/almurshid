import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeEvent { toggle }

class ThemeBloc extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeBloc() : super(ThemeMode.light) {
    _loadInitialTheme();
  }

  void toggleTheme() async {
    final newMode = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    emit(newMode);
    await _saveTheme(newMode);
  }

  void _loadInitialTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;
    final themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    emit(themeMode);
  }

  Future<void> _saveTheme(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, mode == ThemeMode.dark);
  }
}
