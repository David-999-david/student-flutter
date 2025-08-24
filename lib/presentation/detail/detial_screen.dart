import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/presentation/detail/course_chart.dart';
import 'package:student/presentation/detail/student_chart.dart';

class DetialScreen extends ConsumerStatefulWidget {
  const DetialScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetialScreenState();
}

class _DetialScreenState extends ConsumerState<DetialScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.grey,
              pinned: true,
              automaticallyImplyLeading: false,
              toolbarHeight: 0,
              bottom: TabBar(
                isScrollable: false,
                labelStyle: 16.sp(color: Colors.white),
                unselectedLabelStyle: 16.sp(),

                tabs: [
                  Tab(text: 'Student'),
                  Tab(text: 'Course'),
                ],
              ),
            ),
          ],
          body: TabBarView(children: [StudentChart(), CourseChart()]),
        ),
      ),
    );
  }
}
