import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:student/api_url.dart';
import 'package:student/data/model/auth_model.dart';
import 'package:student/dio_client.dart';
import 'package:student/local_name.dart';

class AuthService {
  final Dio _dio = DioClient.dio;
  final _storage = FlutterSecureStorage();

  Future<void> login(LoginModel user) async {
    try {
      final response = await _dio.post(ApiUrl.login, data: user.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final access = response.data['access'];
        final refresh = response.data['refresh'];

        if (access == null || refresh == null) {
          throw Exception('After login access and refresh is missing');
        }
        await _storage.write(key: LocalName.access, value: access);
        await _storage.write(key: LocalName.refresh, value: refresh);
      }
    } on DioException catch (e) {
      throw Exception(
        'Error => ${e.response!.statusCode} Email or password incorrect',
      );
    }
  }

  Future<bool> handleStart() async {
    String? refresh = await _storage.read(key: LocalName.refresh);

    if (refresh == null || JwtDecoder.isExpired(refresh)) {
      await _storage.delete(key: LocalName.access);
      await _storage.delete(key: LocalName.refresh);
      print('Refresh Token is missing or expired');
      return false;
    }
    try {
      final response = await _dio.post(
        ApiUrl.refresh,
        options: Options(headers: {'Authorization': 'Bearer $refresh'}),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final newAccess = response.data['newAccess'];
        final newRefresh = response.data['newRefresh'];
        if (newAccess == null || newRefresh == null) {
          return false;
        }

        await _storage.write(key: LocalName.access, value: newAccess);
        await _storage.write(key: LocalName.refresh, value: newRefresh);
        return true;
      } else {
        return false;
      }
    } on DioException catch (_) {
      return false;
    }
  }
}
