import 'package:flutter/material.dart';
import 'package:student/presentation/test/pie.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<StatefulWidget> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(child: PieChartSample2()),
    );
  }
}
