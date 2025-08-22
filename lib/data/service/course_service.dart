import 'package:dio/dio.dart';
import 'package:student/api_url.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/dio_client.dart';

class CourseService {
  final Dio _dio = DioClient.dio;

  Future<void> create(InsertCourse course) async {
    try {
      final response = await _dio.post(ApiUrl.course, data: course.toJson());

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Create course success');
        return;
      } else {
        throw Exception(
          'Error => ${response.data['error']}, ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<List<CourseModel>> get(String? query) async {
    try {
      final response = await _dio.get(
        ApiUrl.course,
        queryParameters: {'q': query},
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'] as List<dynamic>;

        return data.map((c) => CourseModel.fromJson(c)).toList();
      } else {
        throw Exception(
          'Error => ${response.data['error']} ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        'Error => ${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<void> update(int id, InsertCourse course) async {
    try {
      final response = await _dio.put(
        '${ApiUrl.course}/$id',
        data: course.toJson(),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Update success');
      } else {
        throw Exception(
          'Error => ${response.data['error']} ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<void> delete(int id) async {
    try {
      final response = await _dio.delete('${ApiUrl.course}/$id');

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Delete success');
      } else {
        throw Exception(
          'Error => ${response.data['error']} ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<CourseStuds> getbyId(int id) async {
    try {
      final response = await _dio.get('${ApiUrl.course}/$id');

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        final data = response.data['data'];
        return CourseStuds.fromJson(data);
      } else {
        throw Exception(
          'Error => ${response.data['error']} ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<void> joinCourStuds(InsertJoin join) async {
    try {
      final response = await _dio.post(
        '${ApiUrl.course}/join',
        data: join.toJson(),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Join students in to course with id=${join.courseId} success');
        return;
      } else {
        throw Exception(
          'Error => ${response.statusCode} , message : ${response.data['error']}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }

  Future<void> cancelJoin(CancelJoin ids) async {
    try {
      final response = await _dio.delete(
        '${ApiUrl.course}/join',
        data: ids.toJson(),
      );

      final status = response.statusCode!;

      if (status >= 200 && status < 300) {
        print('Success for cancal the join with course and student');
        return;
      } else {
        throw Exception(
          'Error => ${response.statusCode} , message : ${response.data['error']}',
        );
      }
    } on DioException catch (e) {
      throw Exception(
        '${e.response!.data['error']} ${e.response!.data['detail']}',
      );
    }
  }
}
