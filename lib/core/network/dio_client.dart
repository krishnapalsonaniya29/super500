import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioClient {
  static final Dio instance = Dio(
    BaseOptions(
      baseUrl:
          "http://localhost:5000/api/",

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
        "Accept":
            "application/json",
        "ngrok-skip-browser-warning":
            "true",
      },
    ),
  )
    // ..interceptors.add(
    //   InterceptorsWrapper(
    //     onRequest:
    //         (
    //           options,
    //           handler,
    //         ) async {
    //       final prefs =
    //           await SharedPreferences.getInstance();

    //       final token =
    //           prefs.getString(
    //         "accessToken",
    //       );
    //       print("INTERCEPTOR TOKEN => $token",);
    //       if (token != null &&
    //         token.isNotEmpty &&
    //         token != "null") {
    //         options.headers[
    //                 "Authorization"] =
    //             "Bearer $token";
    //       }

    //       return handler.next(
    //         options,
    //       );
    //     },
    //   ),
    // )
    ..interceptors.add(
  InterceptorsWrapper(
    onRequest: (
      options,
      handler,
    ) async {
      final prefs =
          await SharedPreferences.getInstance();

      final token =
          prefs.getString(
        "accessToken",
      );

      print(
        "INTERCEPTOR TOKEN => $token",
      );

      if (token != null &&
          token.isNotEmpty &&
          token != "null") {
        options.headers[
                "Authorization"] =
            "Bearer $token";
      }

      options.headers.putIfAbsent(
        "ngrok-skip-browser-warning",
        () => "true",
      );

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
