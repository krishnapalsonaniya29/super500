import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

class AdminService {
  static final Dio _dio =
      DioClient.instance;

  static const String baseUrl =
      "/v1/admin";

  /// =====================================
  /// DASHBOARD STATS
  /// =====================================

  static Future<Map<String, dynamic>>
      getDashboardStats() async {
    final response =
        await _dio.get(
      "$baseUrl/dashboard-stats",
    );

    return response.data;
  }

  /// =====================================
  /// GET DISTRICT STUDENTS
  /// =====================================

  static Future<Map<String, dynamic>>
      getStudents() async {
    final response =
        await _dio.get(
      "$baseUrl/students",
    );

    return response.data;
  }

  /// =====================================
  /// GET DISTRICT MENTORS
  /// =====================================

  static Future<Map<String, dynamic>>
      getMentors() async {
    final response =
        await _dio.get(
      "$baseUrl/mentors",
    );

    return response.data;
  }

  /// =====================================
  /// VERIFY STUDENT
  /// =====================================

  static Future verifyStudent(
    String id,
  ) async {
    return await _dio.put(
      "$baseUrl/verify-student/$id",
    );
  }

  /// =====================================
  /// REJECT STUDENT
  /// =====================================

  static Future rejectStudent({
    required String id,
    required String reason,
  }) async {
    return await _dio.put(
      "$baseUrl/reject-student/$id",

      data: {
        "rejectionReason":
            reason,
      },
    );
  }

  /// =====================================
  /// VERIFY MENTOR
  /// =====================================

  static Future verifyMentor(
    String id,
  ) async {
    return await _dio.put(
      "$baseUrl/verify-mentor/$id",
    );
  }

  /// =====================================
  /// APPROVE DOCUMENT
  /// =====================================

  static Future approveDocument(
    String id,
  ) async {
    return await _dio.put(
      "$baseUrl/approve-document/$id",
    );
  }

  /// =====================================
  /// REJECT DOCUMENT
  /// =====================================

  static Future rejectDocument({
    required String id,
    required String remarks,
  }) async {
    return await _dio.put(
      "$baseUrl/reject-document/$id",

      data: {
        "remarks": remarks,
      },
    );
  }

  /// =====================================
  /// APPROVE EXPENSE
  /// =====================================

  static Future approveExpense(
    String id,
  ) async {
    return await _dio.put(
      "$baseUrl/approve-expense/$id",
    );
  }

  /// =====================================
  /// REJECT EXPENSE
  /// =====================================

  static Future rejectExpense(
    String id,
  ) async {
    return await _dio.put(
      "$baseUrl/reject-expense/$id",
    );
  }

  /// =====================================
  /// ASSIGN MENTOR
  /// =====================================

  static Future assignMentor({
    required String studentId,
    required String mentorId,
  }) async {
    return await _dio.put(
      "$baseUrl/assign-mentor",

      data: {
        "studentId":
            studentId,

        "mentorId":
            mentorId,
      },
    );
  }
}