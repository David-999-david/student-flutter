import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
}
