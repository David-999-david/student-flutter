import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/data/service/student_service.dart';

final genderProvider =
    StateNotifierProvider<GenderNotifier, AsyncValue<List<Gender>>>(
      (ref) => GenderNotifier(),
    );

class GenderNotifier extends StateNotifier<AsyncValue<List<Gender>>> {
  GenderNotifier() : super(AsyncValue.loading()) {
    getAllGender();
  }

  Future<void> getAllGender() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => GenderService().getAll());
  }
}

final createStudentProvider =
    StateNotifierProvider<CreateStudentNotifier, AsyncValue<void>>(
      (ref) => CreateStudentNotifier(),
    );

class CreateStudentNotifier extends StateNotifier<AsyncValue<void>> {
  CreateStudentNotifier() : super(AsyncValue.data(null));

  Future<void> insert(InsertStudent student) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => StudentService().insert(student));
  }
}

final getStudentProvider =
    StateNotifierProvider.family<
      GetStudentNotifier,
      AsyncValue<List<StudentModel>>,
      String?
    >((ref, query) => GetStudentNotifier(ref, query));

class GetStudentNotifier extends StateNotifier<AsyncValue<List<StudentModel>>> {
  GetStudentNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    get(query);
  }

  final Ref ref;
  final String? query;

  Future<void> get(String? query) async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(milliseconds: 350));
    state = await AsyncValue.guard(() => StudentService().get(query));
  }
}

final editStudentProvider =
    StateNotifierProvider<EditSutdentNotifier, AsyncValue<void>>(
      (ref) => EditSutdentNotifier(),
    );

class EditSutdentNotifier extends StateNotifier<AsyncValue<void>> {
  EditSutdentNotifier() : super(AsyncValue.data(null));

  Future<void> edit(int id, StudentUpdate s) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => StudentService().update(id, s));
  }
}

final deleteStudProvider =
    StateNotifierProvider<DeleteStudNotifier, AsyncValue<void>>(
      (ref) => DeleteStudNotifier(),
    );

class DeleteStudNotifier extends StateNotifier<AsyncValue<void>> {
  DeleteStudNotifier() : super(AsyncValue.data(null));

  Future<void> delete(int id, List<int?> courseIds) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => StudentService().delete(id, courseIds),
    );
  }
}

final onDeleteProvider = StateProvider.family<bool, int>((ref, id) => false);

final getIdStudentProvider = StateNotifierProvider.autoDispose
    .family<GetIdStudentNotifier, AsyncValue<Student>, int>(
      (ref, id) => GetIdStudentNotifier(ref, id),
    );

class GetIdStudentNotifier extends StateNotifier<AsyncValue<Student>> {
  GetIdStudentNotifier(this.ref, this.id) : super(AsyncValue.loading()) {
    get(id);
  }

  final Ref ref;
  final int id;

  Future<void> get(int id) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => StudentService().getById(id));
  }
}

final getJoinStudentProvider =
    StateNotifierProvider.family<
      GetJoinStudentNotifier,
      AsyncValue<List<Student>>,
      String?
    >((ref, query) => GetJoinStudentNotifier(ref, query));

class GetJoinStudentNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  GetJoinStudentNotifier(this.ref, this.query) : super(AsyncValue.loading()) {
    get(query);
  }

  final Ref ref;
  final String? query;

  Future<void> get(String? query) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => StudentService().getByQuery(query));
  }
}

enum studentFilter { all, active, inactive }

final filterProvider = StateProvider<studentFilter>((ref) => studentFilter.all);

final joinStudCoursProvider =
    StateNotifierProvider<JoinStudCoursNotifier, AsyncValue<void>>(
      (ref) => JoinStudCoursNotifier(),
    );

class JoinStudCoursNotifier extends StateNotifier<AsyncValue<void>> {
  JoinStudCoursNotifier() : super(AsyncValue.data(null));

  Future<void> join(int studentId, List<int> courseIds) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(
      () => StudentService().join(studentId, courseIds),
    );
  }
}

final studCancelProvider =
    StateNotifierProvider<StudCancelNotifier, AsyncValue<CancelJoin?>>(
      (ref) => StudCancelNotifier(),
    );

class StudCancelNotifier extends StateNotifier<AsyncValue<CancelJoin?>> {
  StudCancelNotifier() : super(AsyncValue.data(null));

  Future<void> cancel(CancelJoin ids) async {
    state = AsyncValue.loading();
    await AsyncValue.guard(() => StudentService().cancel(ids));
    state = AsyncData(ids);
  }
}
