import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

class SuperAdminService {
  static final Dio _dio = DioClient.instance;

  static const String baseUrl = "/v1/super-admin";

  /// =====================================
  /// DASHBOARD STATS
  /// =====================================

  static Future<Map<String, dynamic>> getDashboardStats() async {
    final response = await _dio.get("$baseUrl/dashboard-stats");

    return response.data;
  }

  /// =====================================
  /// GET ALL STUDENTS
  /// =====================================

  static Future<Map<String, dynamic>> getStudents() async {
    final response = await _dio.get("$baseUrl/students");

    return response.data;
  }

  /// =====================================
  /// GET ALL ADMINS
  /// =====================================

  static Future<Map<String, dynamic>> getAdmins() async {
    final response = await _dio.get("$baseUrl/admins");

    return response.data;
  }

  /// =====================================
  /// GET ALL MENTORS
  /// =====================================

  static Future<Map<String, dynamic>> getMentors() async {
    final response = await _dio.get("$baseUrl/mentors");

    return response.data;
  }

  /// =====================================
  /// VERIFY STUDENT
  /// =====================================

  static Future verifyStudent(String id) async {
    return await _dio.put("$baseUrl/verify-student/$id");
  }

  /// =====================================
  /// REJECT STUDENT
  /// =====================================

  static Future rejectStudent(String id, String reason) async {
    return await _dio.put(
      "$baseUrl/reject-student/$id",

      data: {"rejectionReason": reason},
    );
  }

  /// =====================================
  /// SUSPEND USER
  /// =====================================

  static Future suspendUser(String id) async {
    return await _dio.put("$baseUrl/suspend-user/$id");
  }

  /// =====================================
  /// ACTIVATE USER
  /// =====================================

  static Future activateUser(String id) async {
    return await _dio.put("$baseUrl/activate-user/$id");
  }

  /// =====================================
  /// DELETE USER
  /// =====================================

  static Future deleteUser(String id) async {
    return await _dio.delete("$baseUrl/delete-user/$id");
  }

  /// =====================================
  /// CREATE ADMIN
  /// =====================================

  static Future createAdmin({
    required String fullName,
    required String phone,
    required String district,
  }) async {
    return await _dio.post(
      "$baseUrl/create-admin",

      data: {"fullName": fullName, "phone": phone, "district": district},
    );
  }

  /// =====================================
  /// DELETE ADMIN
  /// =====================================

  static Future deleteAdmin(String id) async {
    return await _dio.delete("$baseUrl/delete-admin/$id");
  }

  /// =====================================
  /// DELETE MENTOR
  /// =====================================

  static Future deleteMentor(String id) async {
    return await _dio.delete("$baseUrl/delete-mentor/$id");
  }

  /// =====================================
  /// Edit Alloted Amount
  /// ====================================
  static Future<Map<String, dynamic>> updateScholarshipAmount({
    required String studentId,
    required double amount,
  }) async {
    final response = await _dio.patch(
      "$baseUrl/students/$studentId/allotment",

      data: {"amount": amount},
    );

    return response.data;
  }

  /// ====================================
  /// GET STUDENT RANKINGS
  /// ====================================

  static Future<Map<String, dynamic>> getStudentRanking() async {
    final response = await _dio.get("$baseUrl/students/ranking");

    return response.data;
  }

  /// ===============================
  /// Recalculate student ranking
  /// ==============================
  static Future<void> recalculateRankings() async {
    await _dio.post("$baseUrl/students/ranking/recalculate");
  }
}
