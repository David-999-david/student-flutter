import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/home/create_student.dart';
import 'package:student/presentation/home/home_state.dart';

class EditStudent extends ConsumerStatefulWidget {
  const EditStudent({super.key, required this.currentStud});

  final StudentModel currentStud;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditStudentState();
}

class _EditStudentState extends ConsumerState<EditStudent> {
  final key = GlobalKey<FormState>();

  late final TextEditingController name;
  late final TextEditingController email;
  late final TextEditingController phone;
  late final TextEditingController address;

  Gender? selectedGender;

  final List<String> statusList = ['Active', 'Inactive'];

  String? selectedStatus;

  bool? choice;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    address.dispose();
    super.dispose();
  }

  void onChanged(Gender? gender) {
    setState(() {
      selectedGender = gender;
    });
  }

  void onChangedStatus(String? status) {
    setState(() {
      selectedStatus = status;
      bool isactive = status?.toLowerCase() == 'active';
      choice = isactive ? true : false;
    });
  }

  void clear() {
    setState(() {
      name.clear();
      email.clear();
      phone.clear();
      address.clear();
      selectedGender = null;
      selectedStatus = null;
      choice = null;
    });
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.currentStud.name);
    email = TextEditingController(text: widget.currentStud.email);
    phone = TextEditingController(text: widget.currentStud.phone);
    address = TextEditingController(text: widget.currentStud.address);
    selectedStatus = widget.currentStud.status ? 'Active' : 'Inactive';
    choice = widget.currentStud.status;
  }

  @override
  Widget build(BuildContext context) {
    final genderGetState = ref.watch(genderProvider);

    final editState = ref.watch(editStudentProvider);

    ref.listen(editStudentProvider, (p, n) {
      n.when(
        data: (data) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Updated success')));
          ref.read(getStudentProvider('').notifier).get('');
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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(backgroundColor: Colors.blueGrey),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  fillfield(name, 'Name', 'Name', TextInputType.text, 1),
                  emailFillfield(
                    email,
                    'Email',
                    'Email',
                    TextInputType.emailAddress,
                    1,
                  ),
                  phoneFillfield(
                    phone,
                    'Phone number',
                    'Phone number',
                    TextInputType.number,
                    1,
                  ),
                  fillfield(
                    address,
                    'Address',
                    'Address',
                    TextInputType.text,
                    3,
                  ),
                  Row(
                    children: [
                      genderGetState.when(
                        error: (error, _) => Text('Failed to load gender'),
                        loading: () {
                          return Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        data: (data) {
                          return genderDropdown(
                            data,
                            selectedGender,
                            onChanged,
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      statusDropdown(
                        statusList,
                        selectedStatus,
                        onChangedStatus,
                      ),
                    ],
                  ),
                  editState.isLoading
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: BorderSide(color: Colors.black),
                          ),
                          onPressed: () {
                            // if (!key.currentState!.validate()) return;
                            final student = StudentUpdate(
                              name: name.text.trim(),
                              email: email.text.trim(),
                              phone: phone.text.trim(),
                              address: address.text.trim(),
                              genderId: selectedGender!.id,
                              status: choice!,
                            );
                            ref
                                .read(editStudentProvider.notifier)
                                .edit(widget.currentStud.id, student);
                          },
                          child: Text(
                            'Confirm',
                            style: 13.sp(color: Colors.white),
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
