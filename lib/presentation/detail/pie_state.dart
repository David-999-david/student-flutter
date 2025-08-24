import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/data/service/student_service.dart';

final ssProvider = StateProvider<int>((ref) => -1);

final sgProvider = StateProvider<int>((ref) => -1);

final csProvider = StateProvider<int>((ref) => -1);

class DetailNotifier extends StateNotifier<AsyncValue<Detail>> {
  DetailNotifier() : super(AsyncValue.loading()) {
    getDetail();
  }

  Future<void> getDetail() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => StudentService().getDetail());
  }
}

final detailProvider =
    StateNotifierProvider.autoDispose<DetailNotifier, AsyncValue<Detail>>(
      (ref) => DetailNotifier(),
    );
