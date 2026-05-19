import 'package:dio/dio.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://unspeedy-nickie-oratorically.ngrok-free.dev/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {  
        "Content-Type": "application/json",
      },
    ),
  );
}