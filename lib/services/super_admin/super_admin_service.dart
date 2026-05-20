import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

class SuperAdminService {
  static final Dio _dio =
      DioClient.instance;

  /// DASHBOARD STATS
  static Future<Map<String, dynamic>>
      getDashboardStats() async {
    final response =
        await _dio.get(
      "/super-admin/dashboard-stats",
    );

    return response.data;
  }

  /// GET ALL STUDENTS
  static Future<Map<String, dynamic>>
      getStudents() async {
    final response =
        await _dio.get(
      "/super-admin/students",
    );

    return response.data;
  }

  /// GET ALL ADMINS
  static Future<Map<String, dynamic>>
      getAdmins() async {
    final response =
        await _dio.get(
      "/super-admin/admins",
    );

    return response.data;
  }

  /// GET ALL MENTORS
  static Future<Map<String, dynamic>>
      getMentors() async {
    final response =
        await _dio.get(
      "/super-admin/mentors",
    );

    return response.data;
  }

  /// VERIFY STUDENT
  static Future verifyStudent(
    String id,
  ) async {
    return await _dio.put(
      "/super-admin/verify-student/$id",
    );
  }

  /// REJECT STUDENT
  static Future rejectStudent(
    String id,
    String reason,
  ) async {
    return await _dio.put(
      "/super-admin/reject-student/$id",

      data: {
        "rejectionReason":
            reason,
      },
    );
  }

  /// SUSPEND USER
  static Future suspendUser(
    String id,
  ) async {
    return await _dio.put(
      "/super-admin/suspend-user/$id",
    );
  }

  /// ACTIVATE USER
  static Future activateUser(
    String id,
  ) async {
    return await _dio.put(
      "/super-admin/activate-user/$id",
    );
  }

  /// DELETE USER
  static Future deleteUser(
    String id,
  ) async {
    return await _dio.delete(
      "/super-admin/delete-user/$id",
    );
  }

  /// CREATE ADMIN
  static Future createAdmin({
    required String fullName,
    required String phone,
    required String district,
  }) async {
    return await _dio.post(
      "/super-admin/create-admin",

      data: {
        "fullName": fullName,

        "phone": phone,

        "district": district,
      },
    );
  }

  /// DELETE ADMIN
  static Future deleteAdmin(
    String id,
  ) async {
    return await _dio.delete(
      "/super-admin/delete-admin/$id",
    );
  }

  /// DELETE MENTOR
  static Future deleteMentor(
    String id,
  ) async {
    return await _dio.delete(
      "/super-admin/delete-mentor/$id",
    );
  }
}