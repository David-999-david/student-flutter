import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/data/model/auth_model.dart';
import 'package:student/data/service/auth_service.dart';

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  LoginNotifier() : super(AsyncValue.data(null));

  Future<void> login(LoginModel user) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => AuthService().login(user));
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>(
  (ref) => LoginNotifier(),
);

final passwordProvider = StateProvider<bool>((ref) => true);