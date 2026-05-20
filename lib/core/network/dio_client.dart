import 'package:dio/dio.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl: "http://YOUR_IP:5000/api",
      connectTimeout: const Duration(
        seconds: 30,
      ),
      receiveTimeout: const Duration(
        seconds: 30,
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
    ),
  );
}