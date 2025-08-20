import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:intl/intl.dart';
import 'package:student/presentation/home/create_student.dart';

class CreateCourse extends ConsumerStatefulWidget {
  const CreateCourse({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCourseState();
}

class _CreateCourseState extends ConsumerState<CreateCourse> {
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
  Widget build(BuildContext context) {
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
                  textField(name, 'Course-name', 'Course-name'),
                  textField(descp, 'Descritpion', 'Description'),
                  SizedBox(
                    height: 80,
                    child: Row(
                      children: [
                        Expanded(
                          child: numField(
                            limit,
                            'Student Limit',
                            'Student Limit',
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: numField(
                            currentStuds,
                            'Current Students',
                            'Current Students',
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
                  ElevatedButton(
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
                    onPressed: () {},
                    child: Text('Confirm', style: 14.sp(color: Colors.white)),
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

Widget textField(TextEditingController c, String hint, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
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
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is Missing';
        return null;
      },
    ),
  );
}

Widget numField(TextEditingController c, String hint, String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: TextInputType.number,
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
      validator: (value) {
        if (value == null || value.isEmpty) return '$label is Missing';
        return null;
      },
    ),
  );
}
