import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/network/dio_client.dart';

class AuthService {

  /// SEND OTP
  static Future<Response> sendOtp({
    required String phone,
  }) async {

    return await DioClient.dio.post(
      ApiConstants.sendOtp,
      data: {
        'phone': phone,
      },
    );
  }

  /// VERIFY OTP
  static Future<Response> verifyOtp({
    required String phone,
    required String otp,
  }) async {

    return await DioClient.dio.post(
      ApiConstants.verifyOtp,
      data: {
        'phone': phone,
        'otp': otp,
      },
    );
  }

  /// COMPLETE PROFILE
  static Future<Response> completeProfile({
    required Map<String, dynamic> data,
    required String token,
  }) async {

    return await DioClient.dio.post(
      ApiConstants.completeProfile,
      data: data,

      options: Options(
        headers: {
          'Authorization':
              'Bearer $token',
        },
      ),
    );
  }
}