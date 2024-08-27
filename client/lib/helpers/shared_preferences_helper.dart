import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class SharedPreferencesHelper {
  static const String _keyUser = 'user';

  // Lưu đối tượng User vào SharedPreferences
  static Future<void> setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toJson());
    await prefs.setString(_keyUser, userJson);
    print('userJson: $userJson');
  }

  // Lấy đối tượng User từ SharedPreferences
  static Future<User?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userJson = prefs.getString(_keyUser);
    print('userJson: $userJson');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Xóa đối tượng User từ SharedPreferences
  static Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
