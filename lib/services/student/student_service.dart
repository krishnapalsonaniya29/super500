import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

import '../auth/auth_service.dart';

class StudentService {

  static final Dio _dio =
      DioClient.instance;

  static const String baseUrl =
      "/v1/student";

  /// ====================================
  /// AUTH HEADERS
  /// ====================================

  static Future<Options>
      _getOptions() async {

    final token =
        await AuthService.getToken();

    return Options(
      headers: {
        "Authorization":
            "Bearer $token",
      },
    );
  }

  /// ====================================
  /// DASHBOARD
  /// ====================================

  static Future<Map<String, dynamic>>
      getDashboard() async {

    final response =
        await _dio.get(
      "$baseUrl/dashboard",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET SESSIONS
  /// ====================================

  static Future<Map<String, dynamic>>
      getStudentSessions() async {

    final response =
        await _dio.get(
      "$baseUrl/sessions",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET REPORTS
  /// ====================================

  static Future<Map<String, dynamic>>
      getReports() async {

    final response =
        await _dio.get(
      "$baseUrl/reports",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET ACHIEVEMENTS
  /// ====================================

  static Future<Map<String, dynamic>>
      getAchievements() async {

    final response =
        await _dio.get(
      "$baseUrl/achievements",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET EXPENSES
  /// ====================================

  static Future<Map<String, dynamic>>
      getExpenses() async {

    final response =
        await _dio.get(
      "$baseUrl/expenses",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET PROFILE
  /// ====================================

  static Future<Map<String, dynamic>>
      getProfile() async {

    final response =
        await _dio.get(
      "$baseUrl/profile",

      options:
          await _getOptions(),
    );

    return response.data;
  }
}