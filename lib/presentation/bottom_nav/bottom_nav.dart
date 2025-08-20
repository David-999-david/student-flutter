import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/presentation/bottom_nav/bottom_nav_state.dart';
import 'package:student/presentation/home/home.dart';
import 'package:student/presentation/course/course.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key, this.index = 0});

  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  final List<Widget> pageList = [HomeScreen(), Course()];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(bottomProvider(widget.index));
    return Scaffold(
      body: pageList[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (value) {
          ref.read(bottomProvider(widget.index).notifier).onget(value);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Student'),
        ],
      ),
    );
  }
}
