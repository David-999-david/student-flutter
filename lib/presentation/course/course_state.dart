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

final getCourseProvider =
    StateNotifierProvider.family<
      GetCourseNotifier,
      AsyncValue<List<CourseModel>>,
      String?
    >((ref, query) => GetCourseNotifier(ref, query));

class GetCourseNotifier extends StateNotifier<AsyncValue<List<CourseModel>>> {
  GetCourseNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    get(query);
  }

  final Ref ref;
  final String? query;

  Future<void> get(String? query) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().get(query));
  }
}

final editCourseProvider =
    StateNotifierProvider<EditCourseNotifier, AsyncValue<void>>(
      (ref) => EditCourseNotifier(),
    );

class EditCourseNotifier extends StateNotifier<AsyncValue<void>> {
  EditCourseNotifier() : super(AsyncValue.data(null));

  Future<void> update(int id, InsertCourse course) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().update(id, course));
  }
}

final deleteCourseProvider =
    StateNotifierProvider<DeleteCourseNotifier, AsyncValue<void>>(
      (ref) => DeleteCourseNotifier(),
    );

class DeleteCourseNotifier extends StateNotifier<AsyncValue<void>> {
  DeleteCourseNotifier() : super(AsyncValue.data(null));

  Future<void> delete(int id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().delete(id));
  }
}

final getIdCourseProvider =
    StateNotifierProvider.family<
      GetIdCourseNotifier,
      AsyncValue<CourseStuds>,
      int?
    >((ref, id) => GetIdCourseNotifier(ref, id));

class GetIdCourseNotifier extends StateNotifier<AsyncValue<CourseStuds>> {
  GetIdCourseNotifier(this.ref, this.id) : super(AsyncValue.loading()) {
    getId(id);
  }

  final Ref ref;
  final int? id;

  Future<void> getId(int? id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().getbyId(id!));
  }
}

final joinProvider = StateNotifierProvider<JoinNotifier, AsyncValue<void>>(
  (ref) => JoinNotifier(),
);

class JoinNotifier extends StateNotifier<AsyncValue<void>> {
  JoinNotifier() : super(AsyncValue.data(null));

  Future<void> join(InsertJoin join) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => CourseService().joinCourStuds(join));
  }
}

final cancelJoinProvider =
    StateNotifierProvider<CancelJoinNotifier, AsyncValue<CancelJoin?>>(
      (ref) => CancelJoinNotifier(),
    );

class CancelJoinNotifier extends StateNotifier<AsyncValue<CancelJoin?>> {
  CancelJoinNotifier() : super(AsyncValue.data(null));

  Future<void> cancel(CancelJoin ids) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() => CourseService().cancelJoin(ids));
    state = AsyncData(ids);
  }
}
