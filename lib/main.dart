import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/dio_client.dart';
import 'package:student/presentation/auth/login_screen.dart';
import 'package:student/presentation/bottom_nav/bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioClient.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: BottomNav());
  }
}
