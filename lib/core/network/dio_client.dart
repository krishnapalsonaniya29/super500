import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl:
          "http://localhost:5000/api",

      connectTimeout:
          const Duration(
        seconds: 30,
      ),

      receiveTimeout:
          const Duration(
        seconds: 30,
      ),

      headers: {
        "Content-Type":
            "application/json",
      },
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest:
            (
              options,
              handler,
            ) async {
          final prefs =
              await SharedPreferences.getInstance();

          final token =
              prefs.getString(
            "accessToken",
          );

          if (token != null) {
            options.headers[
                    "Authorization"] =
                "Bearer $token";
          }

          return handler.next(
            options,
          );
        },
      ),
    )
    ..interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
      ),
    );
}