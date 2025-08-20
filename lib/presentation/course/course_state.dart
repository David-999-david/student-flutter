import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/data/service/course_service.dart';

final createCourseProvider =
    StateNotifierProvider<CreateCourseNotifier, AsyncValue<void>>(
      (ref) => CreateCourseNotifier(),
    );

class CreateCourseNotifier extends StateNotifier<AsyncValue<void>> {
  CreateCourseNotifier() : super(AsyncValue.data(null));

  Future<void> create(InsertCourse course) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().create(course));
  }
}
