// ============================================================================
// USER STORAGE SERVICE
// ============================================================================
//
// Service for storing and retrieving user data using SharedPreferences.
// This ensures user information is persisted across app sessions.
// ============================================================================

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';

abstract class UserStorage {
  Future<User> getUser();
  Future<void> saveUser(User user);
  Future<void> clearUser();
}

class UserStorageImpl implements UserStorage {
  static const String _userKey = 'user_data';

  @override
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(userJson);
        return User.fromJson(json);
      } catch (e) {
        // If parsing fails, return default user
        return User.defaultUser;
      }
    }

    // Return default user if no data stored
    return User.defaultUser;
  }

  @override
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  @override
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
