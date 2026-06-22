import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('role', role);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('role');
  }

  static Future<void> clearAuth() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }

  /// =====================================
  /// GET USER
  /// =====================================

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userString = prefs.getString("user");

    if (userString == null) {
      return null;
    }

    return jsonDecode(userString);
  }

  /// =====================================
  /// LOGOUT
  /// =====================================

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}
