import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger(
      printer: PrettyPrinter(
          methodCount: 0, printEmojis: true, colors: true, printTime: true));

  String fullPath(RequestOptions options) {
    return '${options.baseUrl}${options.path}';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['startTime'] = DateTime.now();

    logger.i('${options.method} ➡️ ${fullPath(options)}');

    options.headers.forEach((key, value) {
      final display =
          key.toLowerCase() == 'authorization' ? 'Bearer ***' : value;
      logger.d('🔊 Header : $key : $display');
    });

    if (options.queryParameters.isNotEmpty) {
      logger.d('🔊 QueryParmeters : ${options.queryParameters}');
    }

    if (options.data != null) {
      logger.d('🔊 Body : ${options.data}');
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['startTime'] as DateTime?;
    final showMs = start == null
        ? ''
        : '${DateTime.now().difference(start).inMilliseconds}ms';

    logger.i(
        '✔️ [${response.statusCode}]  <= ${fullPath(response.requestOptions)} (⏰ $showMs)');

    if (response.data != null) {
      logger.d('🔊 Response : ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errOptions = err.requestOptions;
    final start = errOptions.extra['startTime'] as DateTime?;
    final showMs = start == null
        ? ''
        : '${DateTime.now().difference(start).inMilliseconds}ms';

    logger.i(
        '❌ [${err.response!.statusCode}] ${fullPath(err.requestOptions)} (⏰ $showMs)');

    if (errOptions.data != null) {
      logger.d('🔊 Error Request : ${errOptions.data}');
    }

    if (err.response!.data != null) {
      logger.d('🔊 Error Response : ${err.response!.data}');
    }

    handler.next(err);
  }
}
