import 'package:dio/dio.dart';
import 'package:jcdriver/utilities/constants/constants.dart';

class HttpService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: MAIN_URL,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      validateStatus: (status) {
        return status != null && status < 500; // Allows handling of 404 errors
      },
    ),
  );

  HttpService() {
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  /// 🔹 Login Request
  Future<Response?> loginRider({required String username, required String password}) async {
    try {
      Response response = await dio.post(
        "/api/rider/login-rider",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(headers: {"Content-Type": "application/json"}),
      );
      return response;
    } on DioException catch (e) {
      return _handleDioError(e, "/api/rider/login-rider");
    }
  }

  /// 🔹 Handle Dio exceptions properly
  Response _handleDioError(DioException e, String path) {
    String errorMessage = "Unknown error occurred.";
    if (e.response != null) {
      errorMessage = "Error: ${e.response!.statusCode} - ${e.response!.statusMessage}";
    } else if (e.type == DioExceptionType.connectionTimeout) {
      errorMessage = "Connection timeout. Please check your internet.";
    } else if (e.type == DioExceptionType.receiveTimeout) {
      errorMessage = "Receive timeout. Server is taking too long.";
    } else if (e.type == DioExceptionType.badResponse) {
      errorMessage = "Bad response from server.";
    } else if (e.type == DioExceptionType.cancel) {
      errorMessage = "Request was cancelled.";
    } else {
      errorMessage = "Unexpected error: ${e.message}";
    }

    print("Dio Error: $errorMessage");
    return Response(
      requestOptions: RequestOptions(path: path),
      statusCode: e.response?.statusCode ?? 500,
      data: {'error': errorMessage},
    );
  }
}
