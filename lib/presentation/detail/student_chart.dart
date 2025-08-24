import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/presentation/detail/pie_state.dart';

class StudentChart extends ConsumerStatefulWidget {
  const StudentChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentChartState();
}

class _StudentChartState extends ConsumerState<StudentChart> {
  @override
  Widget build(BuildContext context) {
    final ssState = ref.watch(ssProvider);
    final detailState = ref.watch(detailProvider);
    final sgState = ref.watch(sgProvider);

    return Scaffold(
      backgroundColor: Color(0xff304352),
      body: detailState.when(
        error: (error, _) {
          return Center(child: Text(error.toString()));
        },
        loading: () {
          return Center(child: CircularProgressIndicator(color: Colors.yellow));
        },
        data: (data) {
          List<PieChartSectionData> showStatus() {
            return List.generate(2, (i) {
              final isTouched = i == ssState;
              final fontsize = isTouched ? 25 : 16;
              final radius = isTouched ? 50.0 : 40.0;
              switch (i) {
                case 0:
                  return PieChartSectionData(
                    color: Colors.green,
                    value: data.sst.toDouble(),
                    title: '${data.sst}',
                    radius: radius,
                    titleStyle: fontsize.sp(color: Colors.white),
                  );
                case 1:
                  return PieChartSectionData(
                    color: Colors.redAccent,
                    value: data.ssf.toDouble(),
                    title: '${data.ssf}',
                    radius: radius,
                    titleStyle: fontsize.sp(color: Colors.white),
                  );
                default:
                  throw Error();
              }
            });
          }

          List<PieChartSectionData> showGender() {
            return List.generate(3, (i) {
              final isTouched = i == sgState;
              final fontsize = isTouched ? 25 : 16;
              final radius = isTouched ? 50.0 : 40.0;
              switch (i) {
                case 0:
                  return PieChartSectionData(
                    color: Colors.green,
                    value: data.sgo.toDouble(),
                    title: '${data.sgo}',
                    radius: radius,
                    titleStyle: fontsize.sp(color: Colors.white),
                  );
                case 1:
                  return PieChartSectionData(
                    color: Colors.red,
                    value: data.sgm.toDouble(),
                    title: '${data.sgm}',
                    radius: radius,
                    titleStyle: fontsize.sp(color: Colors.white),
                  );
                case 2:
                  return PieChartSectionData(
                    color: Colors.blue,
                    value: data.sgf.toDouble(),
                    title: '${data.sgf}',
                    radius: radius,
                    titleStyle: fontsize.sp(color: Colors.white),
                  );
                default:
                  throw Error();
              }
            });
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text('Status', style: 16.sp()),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Ind(Colors.green, 'Active'),
                                SizedBox(height: 10),
                                Ind(Colors.red, 'Inactive'),
                              ],
                            ),
                          ],
                        ),
                        AspectRatio(
                          aspectRatio: 1.6,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (p0, p1) {
                                  setState(() {
                                    if (!p0.isInterestedForInteractions ||
                                        p1 == null ||
                                        p1.touchedSection == null) {
                                      ref.read(ssProvider.notifier).state = -1;
                                      return;
                                    }
                                    ref.read(ssProvider.notifier).state =
                                        p1.touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 5,
                              centerSpaceRadius: 45,
                              sections: showStatus(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Text('Gender', style: 16.sp()),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Ind(Colors.blue, 'Female'),
                                SizedBox(height: 10),
                                Ind(Colors.red, 'Male'),
                                SizedBox(height: 10),
                                Ind(Colors.green, 'Others'),
                              ],
                            ),
                          ],
                        ),
                        AspectRatio(
                          aspectRatio: 1.6,
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (p0, p1) {
                                  setState(() {
                                    if (!p0.isInterestedForInteractions ||
                                        p1 == null ||
                                        p1.touchedSection == null) {
                                      ref.read(sgProvider.notifier).state = -1;
                                      return;
                                    }
                                    ref.read(sgProvider.notifier).state =
                                        p1.touchedSection!.touchedSectionIndex;
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 7,
                              centerSpaceRadius: 50,
                              sections: showGender(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget Ind(Color color, String title) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(radius: 10, backgroundColor: color),
      SizedBox(width: 5),
      Text(title, style: 12.sp()),
    ],
  );
}
