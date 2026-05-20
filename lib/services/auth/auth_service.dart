import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl =
      "http://localhost:5000/api/v1/auth";

  /// SEND OTP
  static Future<Map<String, dynamic>> sendOtp(
    String phone,
  ) async {
    try {
      final response = await Dio().post(
        "$baseUrl/send-otp",
        data: {
          "phone": phone,
        },
      );

      return response.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// VERIFY OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response = await Dio().post(
        "$baseUrl/verify-otp",
        data: {
          "phone": phone,
          "otp": otp,
        },
      );

      final accessToken =
          response.data["data"]["accessToken"];

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        "accessToken",
        accessToken,
      );

      return response.data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  /// GET TOKEN
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString("accessToken");
  }
  /// GET CURRENT USER
static Future<Map<String, dynamic>> getMe() async {
  try {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("accessToken");

    final response = await Dio().get(
      "$baseUrl/me",
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
      ),
    );

    return response.data;
  } catch (e) {
    throw Exception(e.toString());
  }
}
}