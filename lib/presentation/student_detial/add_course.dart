import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/home.dart';

class AddCourse extends ConsumerStatefulWidget {
  const AddCourse({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCourseState();
}

class _AddCourseState extends ConsumerState<AddCourse> {
  final query = TextEditingController();

  List<CourseModel> choiceCourse = [];

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

    ref.listen(deleteCourseProvider, (p, n) {
      n.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Delete course done', style: 14.sp())),
          );
          ref.invalidate(getCourseProvider);
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    void addChoice(CourseModel course) {
      setState(() {
        if (choiceCourse.contains(course)) {
          choiceCourse.remove(course);
        } else {
          choiceCourse.add(course);
          print(choiceCourse);
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(backgroundColor: Colors.grey),
          SliverPadding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 17),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final choosen = choiceCourse[index];
                return choiceItem(choosen);
              }, childCount: choiceCourse.length),

              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 1,
                crossAxisSpacing: 5,
                mainAxisExtent: 40,
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
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return courseItem(
                        course,
                        formated,
                        context,
                        addChoice,
                        choiceCourse,
                      );
                    },
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(child: Text('There is no courses')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

Widget choiceItem(CourseModel course) {
  return Chip(
    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    backgroundColor: Colors.white,
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
  void Function(CourseModel) onChoice,
  List<CourseModel> choicen,
) {
  final choiceBool = choicen.contains(course);
  return InkWell(
    onTap: () {
      onChoice(course);
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
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: 'End Date   :     ', style: 13.sp()),
                  TextSpan(text: formatDate(course.endDate), style: 14.sp()),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
