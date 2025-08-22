import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/course/edit_course.dart';
import 'package:student/presentation/course_detail/add_student.dart';
import 'package:student/presentation/home/home_state.dart';

class CourseDetail extends ConsumerStatefulWidget {
  const CourseDetail({super.key, required this.c});

  final CourseModel c;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseDetailState();
}

class _CourseDetailState extends ConsumerState<CourseDetail> {
  String formated(DateTime? date) =>
      date == null ? 'Not set' : DateFormat('yyyy-MM-dd h:mm a').format(date);

  @override
  Widget build(BuildContext context) {
    final getDetialState = ref.watch(getIdCourseProvider(widget.c.id));
    final detail = getDetialState.valueOrNull;

    ref.listen(cancelJoinProvider, (p, n) {
      n.when(
        data: (ids) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Cancel Join success',
                style: 14.sp(color: Colors.white),
              ),
            ),
          );
          if (ids != null) {
            ref.invalidate(getIdCourseProvider(widget.c.id));
            ref.invalidate(getCourseProvider(''));
            ref.invalidate(getIdStudentProvider(ids.studentId));
            ref.invalidate(getJoinStudentProvider(''));
          }
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).clearSnackBars();
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
          SliverAppBar(
            backgroundColor: Colors.grey,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10, bottom: 5),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: detail == null
                      ? null
                      : () {
                          !detail.status
                              ? ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'This course is Inactive',
                                          style: 14.sp(color: Colors.white),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 5,
                                              vertical: 2,
                                            ),
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) {
                                                  return EditCourse(
                                                    currentCour: CourseModel(
                                                      id: detail.id,
                                                      name: detail.name,
                                                      description:
                                                          detail.description,
                                                      status: detail.status,
                                                      studentLimit:
                                                          detail.studentLimit,
                                                      currentStudents: detail
                                                          .currentStudents,
                                                      startDate:
                                                          detail.startDate,
                                                      endDate: detail.endDate,
                                                      createdAt:
                                                          detail.createdAt,
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Text(
                                            'Edit',
                                            style: 14.sp(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return AddStudent(course: detail);
                                    },
                                  ),
                                );
                        },
                  child: Text('ADD Student', style: 12.sp()),
                ),
              ),
            ],
          ),
          getDetialState.when(
            error: (error, _) {
              return SliverFillRemaining(
                child: Center(child: Text(error.toString())),
              );
            },
            loading: () {
              return SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            },
            data: (detail) {
              final students = detail.students;
              if (students.isEmpty) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      courseDetail(detail, formated),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No student join yet!',
                            style: 15.sp(color: Colors.white),
                          ),
                        ),
                      ),
                    ]),
                  ),
                );
              }
              return SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                sliver: SliverList.builder(
                  itemCount: 1 + students.length,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return courseDetail(detail, formated);
                    }
                    final s = students[index - 1];
                    return studentsInCourse(s, index, context, widget.c.id);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget courseDetail(CourseStuds course, String Function(DateTime?) formatDate) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    child: Container(
      padding: EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 5),
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
            maxLines: 4,
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
                    TextSpan(text: formatDate(course.endDate), style: 14.sp()),
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
  );
}

Widget studentsInCourse(
  StudInCourse s,
  int index,
  BuildContext context,
  int courseId,
) {
  return Consumer(
    builder: (context, ref, child) {
      final cancelState = ref.watch(cancelJoinProvider);
      return cancelState.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Slidable(
                endActionPane: ActionPane(
                  motion: DrawerMotion(),
                  extentRatio: 0.2,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        showDialog(
                          context: context,
                          builder: (BuildContext diaContext) {
                            return AlertDialog(
                              content: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.1,
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Are you sure want to remove?',
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
                                                final need = CancelJoin(
                                                  courseId: courseId,
                                                  studentId: s.id,
                                                );
                                                await ref
                                                    .read(
                                                      cancelJoinProvider
                                                          .notifier,
                                                    )
                                                    .cancel(need);
                                                Navigator.pop(diaContext);
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
                              ),
                            );
                          },
                        );
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 10,
                        child: Text(
                          index.toString(),
                          style: 14.sp(color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 15),
                      Text(s.name, style: 15.sp(color: Colors.black)),
                      Spacer(),
                      Chip(
                        padding: EdgeInsets.symmetric(
                          horizontal: 1,
                          vertical: 1,
                        ),
                        backgroundColor: s.status ? Colors.green : Colors.red,
                        label: Text(
                          s.status ? 'Active' : 'Inactive',
                          style: 13.sp(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
    },
  );
}
