import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/course/create_course.dart';
import 'package:student/presentation/detail/detial_screen.dart';
import 'package:student/presentation/home/create_student.dart';
import 'package:student/presentation/home/edit_student.dart';
import 'package:student/presentation/home/home_state.dart';
import 'package:student/presentation/student_detial/student_detail.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final query = TextEditingController();

  @override
  void dispose() {
    query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getStuState = ref.watch(getJoinStudentProvider(query.text));

    void onChange(String? query) {
      setState(() {
        ref.read(getStudentProvider(query));
      });
    }

    ref.listen(deleteStudProvider, (p, n) {
      n.when(
        data: (_) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Remove success', style: 14.sp(color: Colors.white)),
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
          ref.invalidate(getStudentProvider(query.text));
          ref.invalidate(getCourseProvider);
          ref.invalidate(getJoinStudentProvider(query.text));
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

    final filterState = ref.watch(filterProvider);

    return Scaffold(
      backgroundColor: Color(0xff304352),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 5),
            sliver: SliverGrid(
              delegate: SliverChildListDelegate([
                studentSetting(Icons.add, 'Student', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateStudent();
                      },
                    ),
                  );
                }),
                studentSetting(Icons.add, 'Course', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CreateCourse();
                      },
                    ),
                  );
                }),
                studentSetting(Icons.add_chart_outlined, 'View Detail', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DetialScreen();
                      },
                    ),
                  );
                }),
              ]),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
                crossAxisSpacing: 8,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(child: searchField(query, 'Search...', onChange)),
                  PopupMenuButton<studentFilter>(
                    icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                    initialValue: filterState,
                    onSelected: (value) {
                      ref.read(filterProvider.notifier).state = value;
                    },
                    borderRadius: BorderRadius.circular(8),
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('All', style: 13.sp()),
                          value: studentFilter.all,
                        ),
                        PopupMenuItem(
                          child: Text('Active', style: 13.sp()),
                          value: studentFilter.active,
                        ),
                        PopupMenuItem(
                          child: Text('Inactive', style: 13.sp()),
                          value: studentFilter.inactive,
                        ),
                      ];
                    },
                  ),
                ],
              ),
            ),
          ),
          getStuState.when(
            error: (error, _) {
              return SliverFillRemaining(
                child: Center(child: Text(error.toString())),
              );
            },
            loading: () {
              return SliverFillRemaining(
                child: Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
            data: (students) {
              final filter = switch (filterState) {
                studentFilter.all => students,
                studentFilter.active =>
                  students.where((s) => s.status).toList(),
                studentFilter.inactive =>
                  students.where((s) => !s.status).toList(),
              };
              if (students.isNotEmpty) {
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: filter.length,
                    itemBuilder: (context, index) {
                      return student(filter[index], index + 1, context);
                    },
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'No student for show',
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

Widget studentSetting(IconData icon, String title, VoidCallback ontap) {
  return InkWell(
    onTap: () {
      ontap();
    },
    child: Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(icon, size: 26),
          Text(title, style: 13.sp()),
        ],
      ),
    ),
  );
}

Widget student(Student s, int index, BuildContext context) {
  return Consumer(
    builder: (context, ref, child) {
      // final deleteState = ref.watch(deleteStudProvider);
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return StudentDetail(s: s);
              },
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
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
                          return EditStudent(currentStud: s);
                        },
                      ),
                    );
                  },
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  borderRadius: BorderRadius.circular(8),
                ),
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
                              maxWidth: MediaQuery.of(context).size.width * 0.7,
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
                                          child: Text('Cancel', style: 12.sp()),
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
                                            final courseIds = s.courses
                                                .map((c) => c.id)
                                                .toList();
                                            await ref
                                                .read(
                                                  deleteStudProvider.notifier,
                                                )
                                                .delete(s.id, courseIds);
                                            Navigator.pop(diaContext);
                                          },
                                          child: Text(
                                            'Delete',
                                            style: 12.sp(color: Colors.white),
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
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget searchField(
  TextEditingController c,
  String hint,
  ValueChanged<String> onChanged,
) {
  return TextField(
    controller: c,
    style: 14.sp(color: Colors.white),
    onChanged: (value) {
      onChanged(value);
    },
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: 14.sp(color: Colors.white),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.blue),
      ),
    ),
  );
}
