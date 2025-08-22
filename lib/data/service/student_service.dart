import 'package:dio/dio.dart';
import 'package:student/api_url.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/dio_client.dart';

class GenderService {
  final Dio _dio = DioClient.dio;

  Future<List<Gender>> getAll() async {
    try {
      final response = await _dio.get(ApiUrl.gender);

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List<dynamic>;

        return data.map((g) => Gender.fromJson(g)).toList();
      } else {
        throw Exception('Error => ${response.data.runtimeType}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}

class StudentService {
  final Dio _dio = DioClient.dio;

  Future<void> insert(InsertStudent student) async {
    try {
      final response = await _dio.post(ApiUrl.student, data: student.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Successful create a new student');
        return;
      } else {
        throw Exception('Error => ${response.data.runtimeType}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<List<StudentModel>> get(String? query) async {
    try {
      final response = await _dio.get(
        ApiUrl.student,
        queryParameters: {"q": query},
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List<dynamic>;

        return data.map((s) => StudentModel.fromJson(s)).toList();
      } else {
        throw Exception('Error => ${response.data.runtimeType}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> update(int id, StudentUpdate student) async {
    try {
      final response = await _dio.put(
        '${ApiUrl.editStudend}/$id',
        data: student.toJson(),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Update student with id=$id success!');
      } else {
        throw Exception('Error => ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete('${ApiUrl.student}/$id');

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Delete student with id=$id success');
        return;
      } else {
        throw Exception('Error => ${response.data['error']}');
      }
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<Student> getById(int id) async {
    try {
      final response = await _dio.get('${ApiUrl.student}/$id');

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'];
        return Student.fromJson(data);
      } else {
        throw Exception(
          'Error => ${response.data['error']}, ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['detail']}, ${e.response!.data['error']}',
      );
    }
  }
}
