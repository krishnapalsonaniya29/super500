import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/network/dio_client.dart';

class AuthService {
  static const String baseUrl =
      "/v1/auth";

  /// SEND OTP
  static Future<Map<String, dynamic>> sendOtp(
    String phone,
  ) async {
    try {
      final response =
          await DioClient.instance.post(
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

/// MENTOR REGISTER
static Future<Map<String, dynamic>>
    mentorRegister({
  required String name,
  required String phone,
  required String profession,
}) async {
  try {
    final response =
        await DioClient.instance.post(
      "/v1/public/mentor/register",

      data: {
        "name": name,
        "phone": phone,
        "profession": profession,
      },
    );

    return response.data;
  } catch (e) {
    throw Exception(
      e.toString(),
    );
  }
}

  /// VERIFY OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    try {
      final response =
          await DioClient.instance.post(
        "$baseUrl/verify-otp",
        data: {
          "phone": phone,
          "otp": otp,
        },
      );

     

      final accessToken =
          response.data["data"]?["accessToken"];

      if (accessToken == null) {
        throw Exception(
          "Access token not found",
        );
      }

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
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString(
      "accessToken",
    );
  }

  /// GET CURRENT USER
  static Future<Map<String, dynamic>> getMe() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final token =
          prefs.getString("accessToken");

   

      if (token == null) {
        throw Exception(
          "Token is null",
        );
      }

      final response =
          await DioClient.instance.get(
        "$baseUrl/me",
        options: Options(
          headers: {
            "Authorization":
                "Bearer $token",
          },
        ),
      );

   
      return response.data;
    } catch (e) {
    
      throw Exception(e.toString());
    }
  }
}