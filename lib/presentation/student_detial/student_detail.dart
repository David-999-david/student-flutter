import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/edit_student.dart';
import 'package:student/presentation/home/home_state.dart';
import 'package:student/presentation/student_detial/add_course.dart';

class StudentDetail extends ConsumerStatefulWidget {
  const StudentDetail({super.key, required this.s});

  final Student s;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StudentDetailState();
}

class _StudentDetailState extends ConsumerState<StudentDetail> {
  String formated(DateTime? date) =>
      date == null ? 'Not set' : DateFormat('yyyy-MM-dd h:mm a').format(date);
  @override
  Widget build(BuildContext context) {
    final getDetailState = ref.watch(getIdStudentProvider(widget.s.id));
    final detail = getDetailState.valueOrNull;

    ref.listen(studCancelProvider, (p, n) {
      n.when(
        data: (ids) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Cancel Join success',
                    style: 14.sp(color: Colors.white),
                  ),
                  Chip(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    backgroundColor: Colors.redAccent,
                    label: Text('Delete', style: 14.sp(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
          if (ids != null) {
            ref.invalidate(getIdStudentProvider(widget.s.id));
            ref.invalidate(getCourseProvider(''));
            ref.invalidate(getIdCourseProvider(ids.courseId));
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
      backgroundColor: Color(0xff304352),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.grey,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20, bottom: 5),
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
                                          'This student is Inactive',
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
                                                  return EditStudent(
                                                    currentStud: detail,
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
                                      return AddCourse(s: detail);
                                    },
                                  ),
                                );
                        },
                  child: Text('ADD Course', style: 12.sp()),
                ),
              ),
            ],
          ),
          getDetailState.when(
            error: (error, _) {
              return SliverFillRemaining(
                child: Center(child: Text(error.toString())),
              );
            },
            loading: () {
              return SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.yellow),
                ),
              );
            },
            data: (detail) {
              final students = detail.courses;
              if (students.isEmpty) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      studentDetail(detail, formated),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'No course current, Let join a course!',
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
                      return studentDetail(detail, formated);
                    }
                    final s = students[index - 1];
                    return courseForStudent(s, context, index, widget.s.id);
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

Widget studentDetail(Student s, String Function(DateTime?) formatDate) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
    child: InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14, bottom: 10, top: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(s.name, style: 16.sp()),
                Chip(
                  padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  backgroundColor: s.status ? Colors.green : Colors.red,
                  label: Text(
                    s.status ? 'Active' : 'Inactive',
                    style: 13.sp(color: Colors.white),
                  ),
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 5),
            Text(s.email, style: 13.sp()),
            SizedBox(height: 5),
            Text(s.address, style: 13.sp()),
            SizedBox(height: 5),
            Text(s.phone, style: 13.sp()),
            SizedBox(height: 5),
            Text(s.gender, style: 13.sp()),
          ],
        ),
      ),
    ),
  );
}

Widget courseForStudent(
  CourseForStud c,
  BuildContext context,
  int index,
  int studId,
) {
  return Consumer(
    builder: (context, ref, child) {
      final cancelState = ref.watch(cancelJoinProvider);
      final ondeleteSId = cancelState.valueOrNull;
      final ondelete = ondeleteSId?.courseId == c.id;
      return cancelState.isLoading && ondelete
          ? Center(child: CircularProgressIndicator(color: Colors.yellow))
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
                                                      studCancelProvider
                                                          .notifier,
                                                    )
                                                    .cancel(
                                                      CancelJoin(
                                                        courseId: c.id,
                                                        studentId: studId,
                                                      ),
                                                    );
                                                Navigator.pop(diaContext);
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    'Delete',
                                                    style: 12.sp(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
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
                      Expanded(
                        child: Text(
                          c.name.toUpperCase(),
                          style: 15.sp(color: Colors.black),
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: Chip(
                          padding: EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 1,
                          ),
                          backgroundColor: c.status ? Colors.green : Colors.red,
                          label: Text(
                            c.status ? 'Active' : 'Inactive',
                            style: 12.sp(color: Colors.white),
                          ),
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
