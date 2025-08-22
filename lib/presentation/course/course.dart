import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/course/edit_course.dart';
import 'package:student/presentation/course_detail/course_detail.dart';
import 'package:student/presentation/home/home.dart';

class Course extends ConsumerStatefulWidget {
  const Course({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseState();
}

class _CourseState extends ConsumerState<Course> {
  final query = TextEditingController();

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
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Delete course done')));
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

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(right: 30, left: 30, top: 30, bottom: 10),
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
                      return courseItem(course, formated, context);
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
    );
  }
}

Widget courseItem(
  CourseModel course,
  String Function(DateTime?) formatDate,
  BuildContext context,
) {
  return Consumer(
    builder: (context, ref, child) {
      final deleteState = ref.watch(deleteCourseProvider);
      return deleteState.isLoading
          ? Center(child: CircularProgressIndicator())
          : InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return CourseDetail(c: course);
                    },
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: DrawerMotion(),
                    extentRatio: 0.23,
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return EditCourse(currentCour: course);
                              },
                            ),
                          );
                        },
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        foregroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      SlidableAction(
                        onPressed: (_) {
                          showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                        0.1,
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Are you sure want to delete?',
                                          style: 15.sp(),
                                        ),
                                        SizedBox(height: 15),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: 12.sp(),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 5,
                                                  vertical: 2,
                                                ),
                                                backgroundColor: Colors.red,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () async {
                                                await ref
                                                    .read(
                                                      deleteCourseProvider
                                                          .notifier,
                                                    )
                                                    .delete(course.id);
                                                Navigator.pop(dialogContext);
                                              },
                                              child: Text(
                                                'Delete',
                                                style: 12.sp(
                                                  color: Colors.white,
                                                ),
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
                        padding: EdgeInsets.symmetric(horizontal: 10),

                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 14,
                      right: 14,
                      bottom: 10,
                      top: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                                      text:
                                          '${course.studentLimit.toString()}/',
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
                              TextSpan(
                                text: 'Start Date :    ',
                                style: 13.sp(),
                              ),
                              TextSpan(
                                text: formatDate(course.startDate),
                                style: 14.sp(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'End Date   :     ',
                                style: 13.sp(),
                              ),
                              TextSpan(
                                text: formatDate(course.endDate),
                                style: 14.sp(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
    },
  );
}
