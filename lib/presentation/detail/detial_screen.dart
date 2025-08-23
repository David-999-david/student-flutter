import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';

class DetialScreen extends ConsumerStatefulWidget {
  const DetialScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetialScreenState();
}

class _DetialScreenState extends ConsumerState<DetialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff304352),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.grey,
            title: Text('Detail', style: 20.sp(color: Colors.white)),
            centerTitle: true,
          ),
        ],
      ),
    );
  }
}
