import 'package:dio/dio.dart';
import 'package:student/api_url.dart';

class DioClient {
  static late Dio _dio;

  static void init() {
    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiUrl.baseUrl,
        headers: {'Content-Type': "application/json"},
        responseType: ResponseType.json,
        connectTimeout: Duration(seconds: 60),
        receiveTimeout: Duration(seconds: 60),
        sendTimeout: Duration(seconds: 60),
      ),
    );

    dio.interceptors.add(LogInterceptor());

    _dio = dio;
  }

  static Dio get dio => _dio;
}
