import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../core/network/dio_client.dart';

import '../auth/auth_service.dart';

class StudentService {
  static final Dio _dio = DioClient.instance;

  static const String baseUrl = "/v1/student";

  /// ====================================
  /// AUTH HEADERS
  /// ====================================

  static Future<Options> _getOptions() async {
    final token = await AuthService.getToken();

    return Options(headers: {"Authorization": "Bearer $token"});
  }

  /// ====================================
  /// DASHBOARD
  /// ====================================

  static Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get(
      "$baseUrl/dashboard",

      options: await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET SESSIONS
  /// ====================================

  static Future<List<dynamic>> getStudentSessions() async {
    final response = await DioClient.instance.get("/v1/auth/me");

    return response.data["data"]["studentProfile"]["sessions"] ?? [];
  }

  /// ====================================
  /// GET REPORTS
  /// ====================================

  static Future<Map<String, dynamic>> getReports() async {
    final response = await _dio.get(
      "$baseUrl/reports",

      options: await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET ACHIEVEMENTS
  /// ====================================

  static Future<Map<String, dynamic>> getAchievements() async {
    final response = await _dio.get(
      "$baseUrl/achievements",

      options: await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// GET EXPENSES
  /// ====================================

  static Future<Map<String, dynamic>> getExpenses() async {
    final response = await _dio.get(
      "$baseUrl/expenses",

      options: await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// CREATE EXPENSE
  /// ====================================

  static Future<Map<String, dynamic>> createExpense({
    required String title,
    required double amount,
    required String category,
    required String description,
    MultipartFile? receipt,
  }) async {
    final formData = FormData.fromMap({
      "title": title,
      "amount": amount,
      "description": description,
      "expenseCategory": category,
      "receipt": ?receipt,
    });

    final response = await _dio.post(
      "$baseUrl/expenses",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer ${await AuthService.getToken()}",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }

  /// ====================================
  /// GET PROFILE
  /// ====================================

  static Future<Map<String, dynamic>> getProfile() async {
    final options = await _getOptions();

    try {
      final response = await _dio.get("$baseUrl/profile", options: options);

      return Map<String, dynamic>.from(response.data);
    } on DioException catch (error) {
      if (error.type != DioExceptionType.connectionError) {
        rethrow;
      }

      final fallbackResponse = await _dio.get("/v1/auth/me", options: options);

      return Map<String, dynamic>.from(fallbackResponse.data);
    }
  }

  /// ====================================
  /// FETCH SAMAGRA DETAILS
  /// ====================================

  static Future<Map<String, dynamic>> fetchSamagra(String samagraId) async {
    final response = await _dio.post(
      "$baseUrl/fetch-samagra",
      data: {"samagraId": samagraId},
      options: await _getOptions(),
    );

    return Map<String, dynamic>.from(response.data);
  }

  /// ====================================
  /// COMPLETE PROFILE
  /// ====================================

  static Future<Map<String, dynamic>> completeProfile({
    required Map<String, dynamic> payload,
  }) async {
    final response = await _dio.post(
      "$baseUrl/complete-profile",
      data: payload,
      options: await _getOptions(),
    );

    return Map<String, dynamic>.from(response.data);
  }

  static Future<List<dynamic>> getMyDocuments() async {
    final response = await _dio.get(
      "/v1/documents/my-documents",
      options: await _getOptions(),
    );

    return (response.data["data"] as List?) ?? const [];
  }

  static Future<Map<String, dynamic>> uploadDocuments({
    required Map<String, MultipartFile> files,
  }) async {
    final response = await _dio.post(
      "/v1/documents/upload",
      data: FormData.fromMap(files),
      options: Options(
        headers: {
          "Authorization": "Bearer ${await AuthService.getToken()}",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }

  static MultipartFile buildMultipartFile({
    required List<int> bytes,
    required String filename,
    required String contentType,
  }) {
    return MultipartFile.fromBytes(
      bytes,
      filename: filename,
      contentType: MediaType.parse(contentType),
    );
  }

  /// ====================================
  /// FINANCIAL SUMMARY
  /// ====================================
  static Future<Map<String, dynamic>> getFinancialSummary() async {
    final response = await _dio.get(
      "$baseUrl/financial-summary",
      options: await _getOptions(),
    );

    return response.data;
  }

  /// ====================================
  /// CREATE ACHIEVEMENT
  /// ====================================
  static Future<Map<String, dynamic>> createAchievement({
    required String title,
    required String description,
    MultipartFile? proof,
  }) async {
    final formData = FormData.fromMap({
      "title": title,
      "description": description,
      "proof": proof,
    });

    final response = await _dio.post(
      "$baseUrl/achievements",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer ${await AuthService.getToken()}",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    return Map<String, dynamic>.from(response.data);
  }

  /// ====================================
  /// MY RANK
  /// ====================================

  static Future<int> getMyRank() async {
    final response = await _dio.get(
      "/v1/student/my-rank",
      options: await _getOptions(),
    );

    return response.data["rank"];
  }
}
