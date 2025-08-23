import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/home.dart';
import 'package:student/presentation/home/home_state.dart';

class AddCourse extends ConsumerStatefulWidget {
  const AddCourse({super.key, required this.s});

  final Student s;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCourseState();
}

class _AddCourseState extends ConsumerState<AddCourse> {
  final query = TextEditingController();

  List<CourseModel> choiceCourse = [];
  List<int> choiceCourseIds = [];
  late List<int> joinedCourseId = <int>[];
  int count = 0;

  @override
  void initState() {
    super.initState();
    for (final c in widget.s.courses) {
      joinedCourseId.add(c.id);
    }
  }

  void onChoice(CourseModel c, bool limit) {
    setState(() {
      if (limit) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'This course limit full!',
                  style: 14.sp(color: Colors.white),
                ),
                Chip(
                  side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  backgroundColor: Colors.deepOrangeAccent,
                  label: Text('Warning', style: 14.sp(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
        return;
      } else if (choiceCourse.contains(c)) {
        choiceCourse.remove(c);
        choiceCourseIds.remove(c.id);
        print(choiceCourseIds);
        count--;
        print(count);
      } else if (choiceCourse.length == 5 && choiceCourseIds.length == 5) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'One Time only can add 5 course',
                  style: 14.sp(color: Colors.white),
                ),
                Chip(
                  side: BorderSide(color: Colors.black),
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  backgroundColor: Colors.deepOrangeAccent,
                  label: Text('Warning', style: 14.sp(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
        return;
      } else {
        choiceCourse.add(c);
        choiceCourseIds.add(c.id);
        print(choiceCourseIds);
        count++;
        print(count);
      }
    });
  }

  void removeChoice(CourseModel c) {
    setState(() {
      choiceCourse.remove(c);
      choiceCourseIds.remove(c.id);
      print(choiceCourseIds);
      count--;
      print(count);
    });
  }

  @override
  Widget build(BuildContext context) {
    final getState = ref.watch(getCourseProvider(query.text));

    void onChanged(String? value) {
      setState(() {
        ref.read(getCourseProvider(value));
      });
    }

    String formated(DateTime? date) =>
        date == null ? 'Not set' : DateFormat('yyyy-MM-dd h:mm a').format(date);

    ref.listen(joinStudCoursProvider, (p, n) {
      n.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$count Courses is join with Student',
                    style: 14.sp(color: Colors.white),
                  ),
                  Chip(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    backgroundColor: Colors.green,
                    label: Text('Join', style: 14.sp(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
          ref.invalidate(getCourseProvider);
          ref.invalidate(getIdStudentProvider(widget.s.id));
          ref.invalidate(getJoinStudentProvider);
          Navigator.pop(context);
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    return Scaffold(
      backgroundColor: Color(0xff304352),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 23, bottom: 5),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Chip(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      backgroundColor: Colors.green,
                      label: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '5 / ',
                              style: 16.sp(
                                color: count == 5 ? Colors.black : Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: '$count',
                              style: 14.sp(
                                color: count == 5 ? Colors.black : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          choiceCourse.isEmpty
              ? SliverToBoxAdapter(child: SizedBox.shrink())
              : SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 17),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 1,
                      children: List.generate(choiceCourseIds.length, (i) {
                        return choiceItem(choiceCourse[i], removeChoice);
                      }),
                    ),
                  ),
                ),
          SliverPadding(
            padding: EdgeInsets.only(right: 30, left: 30, bottom: 2),
            sliver: SliverToBoxAdapter(
              child: searchField(query, 'Search', onChanged),
            ),
          ),
          getState.when(
            error: (error, _) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    error.toString(),
                    style: 15.sp(color: Colors.white),
                  ),
                ),
              );
            },
            loading: () {
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            },
            data: (courses) {
              if (courses.isNotEmpty) {
                final unJoin = courses
                    .where((c) => !joinedCourseId.contains(c.id))
                    .toList();
                final activeCourse = unJoin.where((c) => c.status).toList();
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: activeCourse.length,
                    itemBuilder: (context, index) {
                      final course = activeCourse[index];
                      return courseItem(
                        course,
                        formated,
                        context,
                        onChoice,
                        choiceCourse,
                      );
                    },
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'There is no courses',
                      style: 14.sp(color: Colors.white),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () async {
          final String showMesg =
              choiceCourse.isEmpty && choiceCourseIds.isEmpty
              ? 'No course selected'
              : '$count Courses will be join';

          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              final joinState = ref.watch(joinStudCoursProvider);
              return AlertDialog(
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.1,
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(showMesg, style: 15.sp()),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel', style: 12.sp()),
                            ),
                            SizedBox(width: 15),
                            joinState.isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed:
                                        choiceCourse.isEmpty &&
                                            choiceCourseIds.isEmpty
                                        ? null
                                        : () async {
                                            await ref
                                                .read(
                                                  joinStudCoursProvider
                                                      .notifier,
                                                )
                                                .join(
                                                  widget.s.id,
                                                  choiceCourseIds,
                                                );
                                            Navigator.pop(dialogContext);
                                          },
                                    child: Text(
                                      'Confirm',
                                      style: 12.sp(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

Widget choiceItem(CourseModel course, void Function(CourseModel) remove) {
  return Chip(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    backgroundColor: Colors.white,
    deleteIcon: Icon(Icons.remove_circle_outline_sharp),
    onDeleted: () {
      remove(course);
    },
    label: Text(
      course.name,
      style: 14.sp(),
      softWrap: true,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget courseItem(
  CourseModel course,
  String Function(DateTime?) formatDate,
  BuildContext context,
  void Function(CourseModel, bool) onChoice,
  List<CourseModel> choicen,
) {
  final choiceBool = choicen.contains(course);
  return InkWell(
    onTap: () {
      final limit = course.studentLimit == course.currentStudents;
      onChoice(course, limit);
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 5),
        decoration: BoxDecoration(
          color: choiceBool ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    course.name.toUpperCase(),
                    style: 17.sp(),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${course.studentLimit.toString()}/',
                          style: 15.sp(),
                        ),
                        TextSpan(
                          text: course.currentStudents.toString(),
                          style: 13.sp(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Text(
              course.description,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
              style: 15.sp(),
            ),
            Divider(),
            SizedBox(height: 6),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'Start Date :    ', style: 13.sp()),
                  TextSpan(text: formatDate(course.startDate), style: 14.sp()),
                ],
              ),
            ),
            SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'End Date   :     ', style: 13.sp()),
                      TextSpan(
                        text: formatDate(course.endDate),
                        style: 14.sp(),
                      ),
                    ],
                  ),
                ),
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  backgroundColor: course.status ? Colors.green : Colors.red,
                  label: Text(
                    course.status ? 'Active' : 'Inactive',
                    style: 13.sp(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
