import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/data/service/auth_service.dart';

class HandleState extends StateNotifier<AsyncValue<bool>> {
  HandleState() : super(AsyncValue.loading()) {
    handle();
  }

  Future<void> handle() async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(milliseconds: 3000));
    state = await AsyncValue.guard(() => AuthService().handleStart());
  }
}

final handleProvider = StateNotifierProvider<HandleState, AsyncValue<bool>>(
  (ref) => HandleState(),
);
