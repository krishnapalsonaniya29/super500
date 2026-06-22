

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../../core/network/dio_client.dart';

class AuthService {
  static const String baseUrl =
      "/v1/auth";
  static const Set<String> _allowedRoles = {
    "STUDENT",
    "MENTOR",
    "ADMIN",
    "SUPER_ADMIN",
  };

  static Map<String, dynamic>? _asMap(
    dynamic value,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(
        value,
      );
    }

    return null;
  }

  static String _formatError(
    Object error,
  ) {
    if (error is DioException) {
      final data = _asMap(
        error.response?.data,
      );
      final message = data?["message"]
          ?.toString()
          .trim();

      if (message != null &&
          message.isNotEmpty) {
        return message;
      }

      return error.message ??
          "Request failed";
    }

    return error.toString();
  }

  static String _normalizeRole(
    String role,
  ) {
    final normalized =
        role.trim().toUpperCase();

    if (!_allowedRoles.contains(
      normalized,
    )) {
      throw Exception(
        "Invalid role: $role",
      );
    }

    return normalized;
  }

  /// =========================
  /// SEND OTP
  /// =========================
  static Future<Map<String, dynamic>>
    sendOtp({
  required String phone,
  required String role,
}) async {
  try {
    final response =
        await DioClient.instance.post(
      "$baseUrl/send-otp",
      data: {
        "phone": phone,
        "role": role,
      },
    );

    debugPrint(
      "SEND OTP RESPONSE => ${response.data}",
    );

    return Map<String, dynamic>.from(
      response.data,
    );
  } catch (e) {
    debugPrint("SEND OTP ERROR => $e");

    throw Exception(
      _formatError(e),
    );
  }
}
  /// =========================
  /// MENTOR REGISTER
  /// =========================
 static Future<Map<String, dynamic>>
    mentorRegister({
  required String name,
  required String phone,
  required String profession,
  required String district,
  MultipartFile? avatar,
}) async {
  try {
    final formData = FormData.fromMap({
      "name": name,
      "phone": phone,
      "profession": profession,
      "district": district,

      if (avatar != null)
        "avatar": avatar,
    });

    final response =
        await DioClient.instance.post(
      "/v1/public/mentor/register",
      data: formData,
    );

    debugPrint(
      "MENTOR REGISTER RESPONSE => ${response.data}",
    );

    return Map<String, dynamic>.from(
      response.data,
    );
  } catch (e) {
    debugPrint(
      "MENTOR REGISTER ERROR => $e",
    );

    throw Exception(
      _formatError(e),
    );
  }
}

  /// =========================
  /// VERIFY OTP
  /// =========================
  static Future<Map<String, dynamic>>
      verifyOtp({
    required String phone,
    required String otp,
    required String role,
  }) async {
    try {
      final normalizedRole =
          _normalizeRole(role);

      final response =
          await DioClient.instance.post(
        "$baseUrl/verify-otp",
        data: {
          "phone": phone,
          "otp": otp,
          "role": normalizedRole,
        },
      );

      debugPrint(
        "VERIFY OTP RESPONSE => ${response.data}",
      );

      /// HANDLE MULTIPLE RESPONSE STRUCTURES
      final accessToken =
          response.data["accessToken"] ??
              response.data["data"]
                  ?["accessToken"];
      final refreshToken =
          response.data["refreshToken"] ??
              response.data["data"]
                  ?["refreshToken"];

      debugPrint(
        "EXTRACTED TOKEN => $accessToken",
      );

      /// VALIDATE TOKEN
      if (accessToken == null ||
          accessToken
              .toString()
              .trim()
              .isEmpty) {
        throw Exception(
          "Access token missing from response",
        );
      }

      /// SAVE TOKEN
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        "accessToken",
        accessToken.toString(),
      );

      if (refreshToken != null &&
          refreshToken
              .toString()
              .trim()
              .isNotEmpty) {
        await prefs.setString(
          "refreshToken",
          refreshToken.toString(),
        );
      }

      /// VERIFY SAVED TOKEN
      final saved =
          prefs.getString(
        "accessToken",
      );

      debugPrint(
        "SAVED TOKEN => $saved",
      );

      return Map<String, dynamic>.from(
        response.data,
      );
    } catch (e) {
      debugPrint(
        "VERIFY OTP ERROR => $e",
      );

      throw Exception(
        _formatError(e),
      );
    }
  }

  /// =========================
  /// GET TOKEN
  /// =========================
  static Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString(
      "accessToken",
    );

    debugPrint("GET TOKEN => $token");

    return token;
  }

  /// =========================
  /// GET CURRENT USER
  /// =========================
  static Future<Map<String, dynamic>>
      getMe() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();

      final token =
          prefs.getString(
        "accessToken",
      );

      debugPrint(
        "GET ME TOKEN => $token",
      );

      if (token == null ||
          token.trim().isEmpty) {
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

      debugPrint(
        "GET ME RESPONSE => ${response.data}",
      );

      return Map<String, dynamic>.from(
        response.data,
      );
    } catch (e) {
      debugPrint("GET ME ERROR => $e");

      throw Exception(
        _formatError(e),
      );
    }
  }

  static Future<Map<String, dynamic>>
      getCurrentUser() async {
    final response = await getMe();

    final user = _asMap(
      response["data"],
    );

    if (user == null) {
      throw Exception(
        "User data missing from profile response",
      );
    }

    return user;
  }

  static Future<String> getCurrentUserRole() async {
    final user =
        await getCurrentUser();

    final role = user["role"]
        ?.toString()
        .trim();

    if (role == null ||
        role.isEmpty) {
      throw Exception(
        "User role missing from profile response",
      );
    }

    return role;
  }

  /// =========================
  /// LOGOUT
  /// =========================
  static Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove(
      "accessToken",
    );
    await prefs.remove(
      "refreshToken",
    );

    debugPrint("TOKEN REMOVED");
  }

  
}
