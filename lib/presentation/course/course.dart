import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:intl/intl.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/create_student.dart';

class Course extends ConsumerStatefulWidget {
  const Course({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CourseState();
}

class _CourseState extends ConsumerState<Course> {
  final key = GlobalKey<FormState>();

  final name = TextEditingController();
  final descp = TextEditingController();
  final limit = TextEditingController();
  final currentStuds = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  Future<DateTime?> showPicker(BuildContext context) async {
    final firstDate = DateTime.now();
    final lastDate = DateTime(firstDate.year + 20);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  String formated(DateTime date) =>
      DateFormat('yyyy-MM-dd h:mm a').format(date);

  List<String> statusList = ['Active', 'Inactive'];

  String? selected;

  bool? choice;

  void onChangedStatus(String? value) {
    setState(() {
      selected = value;
      bool isactive = selected?.toLowerCase() == 'active';
      choice = isactive ? true : false;
      print(choice);
    });
  }

  @override
  void dispose() {
    name.dispose();
    descp.dispose();
    limit.dispose();
    currentStuds.dispose();
    super.dispose();
  }

  void clear() {
    setState(() {
      name.clear();
      descp.clear();
      limit.clear();
      currentStuds.clear();
      startDate = null;
      endDate = null;
      selected = null;
      choice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createCourseProvider);

    String? validateLimit(String? value) {
      final limitvalue = int.tryParse((value ?? '').trim());
      final currentStud = int.tryParse(currentStuds.text.trim());

      if (limitvalue == null) return 'Limit is missing';
      if (limitvalue < 5) return 'Must be at least 5';
      if (currentStud != null && limitvalue < currentStud) {
        return 'Limit is less than $currentStud';
      }
      return null;
    }

    String? validateCurrentStuds(String? value) {
      final current = int.tryParse((value ?? '').trim());
      final limitStuds = int.tryParse(limit.text.trim());

      if (current == null) return 'Current Studends is missing';
      if (limitStuds != null && current > limitStuds) {
        return 'Over the limit';
      }
      return null;
    }

    ref.listen(createCourseProvider, (p, n) {
      n.when(
        data: (data) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Create new course done!')));
          clear();
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
      appBar: AppBar(backgroundColor: Colors.blueGrey),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 170),
                      statusDropdown(statusList, selected, onChangedStatus),
                    ],
                  ),
                  textField(name, 'Course-name', 'Course-name', 1),
                  textField(descp, 'Descritpion', 'Description', 3),
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: limitNumField(
                            limit,
                            'Student Limit',
                            'Student Limit',
                            validateLimit,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: studsNumField(
                            currentStuds,
                            'Current Students',
                            'Current Students',
                            validateCurrentStuds,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Start Date', style: 16.sp(color: Colors.white)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(220, 40),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final picked = await showPicker(context);
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                                print(startDate);
                              });
                            }
                          },
                          child: Text(
                            startDate == null
                                ? 'Tap to pick Start Date'
                                : formated(startDate!),
                            style: 14.sp(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('End Date', style: 16.sp(color: Colors.white)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(220, 40),
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            final picked = await showPicker(context);
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                                print(endDate);
                              });
                            }
                          },
                          child: Text(
                            endDate == null
                                ? 'Tap to pick End Date'
                                : formated(endDate!),
                            style: 14.sp(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  createState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            side: BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (!key.currentState!.validate()) return;
                            if (startDate == null || endDate == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Start or End Date and Time missing',
                                  ),
                                ),
                              );
                            }
                            if (startDate!.isAfter(endDate!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Start Date must be before End Date',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (endDate!.isBefore(startDate!)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'End Date must be after Start Date',
                                  ),
                                ),
                              );
                              return;
                            }
                            final course = InsertCourse(
                              name: name.text.trim(),
                              description: descp.text.trim(),
                              studentLimit: int.parse(limit.text.trim()),
                              currentStudents: int.parse(
                                currentStuds.text.trim(),
                              ),
                              startDate: startDate!,
                              endDate: endDate!,
                            );
                            await ref
                                .read(createCourseProvider.notifier)
                                .create(course);
                          },
                          child: Text(
                            'Confirm',
                            style: 14.sp(color: Colors.white),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget textField(
  TextEditingController c,
  String hint,
  String label,
  int maxline,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: TextFormField(
      controller: c,
      maxLines: maxline,
      style: 14.sp(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is Missing';
        return null;
      },
    ),
  );
}

Widget limitNumField(
  TextEditingController c,
  String hint,
  String label,
  FormFieldValidator<String>? validate,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: 14.sp(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: validate,
    ),
  );
}

Widget studsNumField(
  TextEditingController c,
  String hint,
  String label,
  FormFieldValidator<String>? validate,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: 14.sp(),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      validator: validate,
    ),
  );
}
