import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/home_state.dart';

class AddStudent extends ConsumerStatefulWidget {
  const AddStudent({super.key, required this.course});

  final CourseStuds course;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddStudentState();
}

class _AddStudentState extends ConsumerState<AddStudent> {
  final query = TextEditingController();

  final List<Student> selected = [];
  final List<int> selectedId = [];
  late int curretStuds;
  int count = 0;
  late List<int> studentIds;

  @override
  void initState() {
    curretStuds = widget.course.currentStudents;
    studentIds = widget.course.students.map((s) => s.id).toList();
    super.initState();
  }

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

    void onSelect(Student st, BuildContext context) {
      setState(() {
        if (selected.contains(st)) {
          selected.remove(st);
          selectedId.remove(st.id);
          count--;
          curretStuds--;
        } else if (curretStuds >= widget.course.studentLimit) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Student Limit reach',
                style: 14.sp(color: Colors.white),
              ),
            ),
          );
          return;
        } else {
          selected.add(st);
          selectedId.add(st.id);
          curretStuds++;
          count++;
        }
      });
    }

    void onDeleted(Student st) {
      setState(() {
        selected.remove(st);
        selectedId.remove(st.id);
        curretStuds--;
        count--;
      });
    }

    void clear() {
      setState(() {
        selected.clear();
        selectedId.clear();
        count = 0;
      });
    }

    ref.listen(joinProvider, (p, n) {
      n.when(
        data: (_) async {
          final joinIds = List<int>.from(selectedId);
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$count Students successfully Join this course',
                style: 14.sp(color: Colors.white),
              ),
            ),
          );
          clear();
          ref.invalidate(getIdCourseProvider(widget.course.id));
          ref.invalidate(getCourseProvider);
          for (final id in joinIds) {
            ref.invalidate(getIdStudentProvider(id));
          }
          ref.invalidate(getJoinStudentProvider(''));
          Navigator.pop(context);
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
          appBar(widget.course, curretStuds, context),
          selected.isEmpty
              ? SliverToBoxAdapter(child: SizedBox.shrink())
              : SliverPadding(
                  padding: EdgeInsets.only(left: 5, right: 5, top: 20),
                  sliver: SliverToBoxAdapter(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 1,
                      children: List.generate(selected.length, (i) {
                        return selectedStudent(selected[i], onDeleted);
                      }),
                    ),
                  ),
                ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            sliver: SliverToBoxAdapter(
              child: searchField(query, 'Search...', onChange),
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
              if (students.isNotEmpty) {
                final activeStudent = students.where((s) => s.status).toList();
                final newStudent = activeStudent
                    .where((s) => !studentIds.contains(s.id))
                    .toList();
                return SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  sliver: SliverList.builder(
                    itemCount: newStudent.length,
                    itemBuilder: (context, index) {
                      return student(
                        newStudent[index],
                        index + 1,
                        context,
                        onSelect,
                        selectedId,
                      );
                    },
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('Not found', style: 14.sp(color: Colors.white)),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final String showMesg = selected.isEmpty && selectedId.isEmpty
              ? 'No student selected'
              : '$count Students will be added';

          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              final joinState = ref.watch(joinProvider);
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
                                        selected.isEmpty && selectedId.isEmpty
                                        ? null
                                        : () async {
                                            await ref
                                                .read(joinProvider.notifier)
                                                .join(
                                                  InsertJoin(
                                                    courseId: widget.course.id,
                                                    studentIds: selectedId,
                                                  ),
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
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Icon(Icons.add),
      ),
    );
  }
}

Widget selectedStudent(Student s, void Function(Student) onDeleted) {
  return Chip(
    label: Text(s.name),
    labelStyle: 14.sp(),
    padding: EdgeInsets.symmetric(horizontal: 1),
    deleteIcon: Icon(Icons.remove_circle_outline_sharp, size: 20),
    onDeleted: () {
      onDeleted(s);
    },
  );
}

Widget student(
  Student s,
  int index,
  BuildContext context,
  void Function(Student, BuildContext context) onSelect,
  List<int> selectedIds,
) {
  final isSelected = selectedIds.contains(s.id);
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: InkWell(
      onTap: () {
        onSelect(s, context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 10,
              child: Text(index.toString(), style: 14.sp(color: Colors.white)),
            ),
            SizedBox(width: 15),
            Text(s.name, style: 15.sp(color: Colors.black)),
          ],
        ),
      ),
    ),
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

Widget appBar(CourseStuds c, int currentStuds, BuildContext context) {
  return SliverAppBar(
    automaticallyImplyLeading: false,
    pinned: true,
    leading: IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back),
    ),
    flexibleSpace: FlexibleSpaceBar(
      background: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  c.name.toUpperCase(),
                  style: 18.sp(),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Chip(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  backgroundColor: Colors.green,
                  label: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${c.studentLimit.toString()}/',
                          style: 16.sp(
                            color: currentStuds == c.studentLimit
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                        TextSpan(
                          text: currentStuds.toString(),
                          style: 14.sp(
                            color: currentStuds == c.studentLimit
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
