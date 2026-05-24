import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

import '../auth/auth_service.dart';

class MentorService {
  static final Dio _dio =
      DioClient.instance;

  static const String baseUrl =
      "/v1/mentor";

  /// ====================================
  /// AUTH OPTIONS
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
  /// GET STUDENTS
  /// ====================================

  static Future<Map<String, dynamic>>
      getStudents() async {
    final response =
        await _dio.get(
      "$baseUrl/students",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET STUDENT DETAILS
  /// ====================================

  static Future<Map<String, dynamic>>
      getStudentDetails(
    String studentId,
  ) async {
    final response =
        await _dio.get(
      "$baseUrl/students/$studentId",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET SESSIONS
  /// ====================================

  static Future<Map<String, dynamic>>
      getSessions() async {
    final response =
        await _dio.get(
      "$baseUrl/sessions",

      options:
          await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// CREATE SESSION
  /// ====================================

  static Future<Map<String, dynamic>>
      createSession({
    required String title,

    required String studentId,

    required String scheduledAt,

    String? description,

    String? meetingLink,
  }) async {
    final response =
        await _dio.post(
      "$baseUrl/sessions",

      options:
          await _getOptions(),

      data: {
        "title": title,

        "studentId": studentId,

        "scheduledAt":
            scheduledAt,

        "description":
            description,

        "meetingLink":
            meetingLink,
      },
    );

    return response.data;
  }

  /// ====================================
  /// UPDATE SESSION
  /// ====================================

  static Future<Map<String, dynamic>>
      updateSession({
    required String sessionId,

    required String status,

    String? notes,
  }) async {
    final response =
        await _dio.put(
      "$baseUrl/sessions/$sessionId",

      options:
          await _getOptions(),

      data: {
        "status": status,

        "notes": notes,
      },
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
  /// CREATE REPORT
  /// ====================================

  static Future<Map<String, dynamic>>
      createReport({
    required String studentId,

    required String content,

    required String reportType,
  }) async {
    final response =
        await _dio.post(
      "$baseUrl/reports",

      options:
          await _getOptions(),

      data: {
        "studentId":
            studentId,

        "content":
            content,

        "reportType":
            reportType,
      },
    );

    return response.data;
  }
}