import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:intl/intl.dart';
import 'package:student/data/model/course_model.dart';
import 'package:student/presentation/course/course_state.dart';
import 'package:student/presentation/home/create_student.dart';

class EditCourse extends ConsumerStatefulWidget {
  const EditCourse({super.key, required this.currentCour});

  final CourseModel currentCour;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCourseState();
}

class _EditCourseState extends ConsumerState<EditCourse> {
  final key = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController descp;
  late final TextEditingController limit;
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
  void initState() {
    name = TextEditingController(text: widget.currentCour.name);
    descp = TextEditingController(text: widget.currentCour.description);
    limit = TextEditingController(
      text: widget.currentCour.studentLimit.toString(),
    );
    startDate = widget.currentCour.startDate;
    endDate = widget.currentCour.endDate;
    selected = widget.currentCour.status ? 'Active' : 'Inactive';
    choice = widget.currentCour.status;
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    descp.dispose();
    limit.dispose();
    super.dispose();
  }

  void clear() {
    setState(() {
      name.clear();
      descp.clear();
      limit.clear();
      startDate = null;
      endDate = null;
      selected = null;
      choice = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateState = ref.watch(editCourseProvider);

    String? validateLimit(String? value) {
      final limitvalue = int.tryParse((value ?? '').trim());
      if (limitvalue == null) return 'Limit is missing';
      if (limitvalue < 5) return 'Must be at least 5';
      return null;
    }

    ref.listen(editCourseProvider, (p, n) {
      n.when(
        data: (_) {
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update course done!',
                    style: 14.sp(color: Colors.white),
                  ),
                  Chip(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    backgroundColor: Colors.green,
                    label: Text('Updated', style: 14.sp(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
          clear();
          ref.invalidate(getCourseProvider);
          ref.invalidate(getIdCourseProvider(widget.currentCour.id));
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
      backgroundColor: Color(0xff304352),
      appBar: AppBar(
        title: Text('Edit Course', style: 20.sp(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Course-name', style: 16.sp(color: Colors.white)),
                  textField(name, 'Course-name', 'Course-name', 1),
                  Text('Description', style: 16.sp(color: Colors.white)),
                  textField(descp, 'Descritpion', 'Description', 3),
                  SizedBox(
                    height: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Student-limit',
                          style: 16.sp(color: Colors.white),
                        ),
                        SizedBox(width: 70),
                        Text('Status', style: 16.sp(color: Colors.white)),
                      ],
                    ),
                  ),
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
                        statusDropdown(statusList, selected, onChangedStatus),
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
                  updateState.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.yellow,
                          ),
                        )
                      : Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 2,
                              ),
                              side: BorderSide(color: Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Colors.green,
                            ),
                            onPressed: () async {
                              if (!key.currentState!.validate()) return;
                              if (startDate == null || endDate == null) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start or End Date and Time missing',
                                          style: 14.sp(color: Colors.white),
                                        ),
                                        Chip(
                                          side: BorderSide(color: Colors.black),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          label: Text(
                                            'Warning',
                                            style: 14.sp(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (startDate!.isAfter(endDate!)) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start Date must be before End Date',
                                          style: 14.sp(color: Colors.white),
                                        ),
                                        Chip(
                                          side: BorderSide(color: Colors.black),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          label: Text(
                                            'Warning',
                                            style: 14.sp(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (startDate == endDate) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start and End Date are the same!',
                                          style: 14.sp(color: Colors.white),
                                        ),
                                        Chip(
                                          side: BorderSide(color: Colors.black),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          label: Text(
                                            'Warning',
                                            style: 14.sp(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (endDate!.isBefore(startDate!)) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'End Date must be after Start Date',
                                          style: 14.sp(color: Colors.white),
                                        ),
                                        Chip(
                                          side: BorderSide(color: Colors.black),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          backgroundColor:
                                              Colors.deepOrangeAccent,
                                          label: Text(
                                            'Warning',
                                            style: 14.sp(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                return;
                              }
                              final course = InsertCourse(
                                name: name.text.trim(),
                                description: descp.text.trim(),
                                studentLimit: int.parse(limit.text.trim()),
                                startDate: startDate!,
                                endDate: endDate!,
                                status: choice!,
                              );
                              await ref
                                  .read(editCourseProvider.notifier)
                                  .update(widget.currentCour.id, course);
                            },
                            child: Text(
                              'Confirm',
                              style: 14.sp(color: Colors.white),
                            ),
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
    padding: const EdgeInsets.symmetric(vertical: 10),
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
