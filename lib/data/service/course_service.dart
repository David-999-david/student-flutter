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
}
