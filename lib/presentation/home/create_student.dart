import 'package:dropdown_search/dropdown_search.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student/app_text_style.dart';
import 'package:student/data/model/student_model.dart';
import 'package:student/presentation/home/home_state.dart';

class CreateStudent extends ConsumerStatefulWidget {
  const CreateStudent({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateStudendState();
}

class _CreateStudendState extends ConsumerState<CreateStudent> {
  final key = GlobalKey<FormState>();
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
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
        print(choice);
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

    final genderGetState = ref.watch(genderProvider);

    final insertstuState = ref.watch(createStudentProvider);

    ref.listen(createStudentProvider, (p, n) {
      n.when(
        data: (data) {
          clear();
          ScaffoldMessenger.of(context).clearSnackBars();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create success', style: 14.sp(color: Colors.white)),
                  Chip(
                    side: BorderSide(color: Colors.black),
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    backgroundColor: Colors.green,
                    label: Text('Success', style: 14.sp(color: Colors.white)),
                  ),
                ],
              ),
            ),
          );
          ref.read(getJoinStudentProvider('').notifier).get('');
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
        title: Text('Create Student', style: 20.sp(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Form(
            key: key,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Name', style: 15.sp(color: Colors.white)),
                  fillfield(name, 'Name', 'Name', TextInputType.text, 1),
                  Text('Email', style: 15.sp(color: Colors.white)),
                  emailFillfield(
                    email,
                    'example@gmail.com',
                    'Email',
                    TextInputType.emailAddress,
                    1,
                  ),
                  Text('Phone', style: 15.sp(color: Colors.white)),
                  phoneFillfield(
                    phone,
                    '9889****',
                    'Phone number',
                    TextInputType.number,
                    1,
                  ),
                  Text('Address', style: 15.sp(color: Colors.white)),
                  fillfield(
                    address,
                    'Fill you address...',
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
                              child: CircularProgressIndicator(
                                color: Colors.yellow,
                              ),
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
                  insertstuState.isLoading
                      ? Center(
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              color: Colors.yellow,
                            ),
                          ),
                      )
                      : Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              side: BorderSide(color: Colors.white),
                            ),
                            onPressed: () {
                              if (!key.currentState!.validate()) return;
                              final student = InsertStudent(
                                name: name.text.trim(),
                                email: email.text.trim(),
                                phone: phone.text.trim(),
                                address: address.text.trim(),
                                genderId: selectedGender!.id,
                                status: choice!,
                              );
                              ref
                                  .read(createStudentProvider.notifier)
                                  .insert(student);
                            },
                            child: Text(
                              'Confirm',
                              style: 13.sp(color: Colors.white),
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

Widget fillfield(
  TextEditingController c,
  String hint,
  String label,
  TextInputType? type,
  int? maxline,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      maxLines: maxline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        border: OutlineInputBorder(
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

Widget emailFillfield(
  TextEditingController c,
  String hint,
  String label,
  TextInputType? type,
  int? maxline,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      maxLines: maxline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        border: OutlineInputBorder(
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
        if (!EmailValidator.validate(value)) return 'Invalid email';
        return null;
      },
    ),
  );
}

Widget phoneFillfield(
  TextEditingController c,
  String hint,
  String label,
  TextInputType? type,
  int? maxline,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      maxLines: maxline,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        hintStyle: 14.sp(color: Colors.grey),
        border: OutlineInputBorder(
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
        if (value.length < 8) return '$label must be at least 8';
        return null;
      },
    ),
  );
}

Widget genderDropdown(
  List<Gender> genders,
  Gender? selected,
  ValueChanged<Gender?> onChanged,
) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownSearch<Gender>(
        items: (filter, loadProps) {
          if (filter.isEmpty) {
            return genders;
          }
          return genders
              .where((g) => g.name.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        },
        validator: (value) => value == null ? 'Gender is required' : null,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        selectedItem: selected,
        onChanged: (value) {
          onChanged(value);
        },
        dropdownBuilder: (context, selectedItem) {
          return selectedItem == null
              ? SizedBox.shrink()
              : Text(selectedItem.name, style: 14.sp());
        },
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'Gender',
            hintStyle: 14.sp(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: 180),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return ListTile(
              selected: isSelected,
              title: Text(item.name, style: 14.sp()),
            );
          },
          loadingBuilder: (context, searchEntry) {
            return Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(),
              ),
            );
          },
          emptyBuilder: (context, searchEntry) {
            return Text('There is no gender now');
          },
        ),
        compareFn: (item1, item2) => item1.id == item2.id,
      ),
    ),
  );
}

Widget statusDropdown(
  List<String> statusList,
  String? selected,
  ValueChanged<String?> onChangedStatus,
) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: DropdownSearch<String>(
        items: (filter, loadProps) {
          if (filter.isEmpty) {
            return statusList;
          }
          return statusList
              .where((s) => s.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        },
        selectedItem: selected,
        validator: (value) => value == null ? 'Status is required' : null,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          onChangedStatus(value);
        },
        dropdownBuilder: (context, selectedItem) {
          return selectedItem == null
              ? SizedBox.shrink()
              : Text(selectedItem, style: 14.sp());
        },
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintText: 'Status',
            hintStyle: 14.sp(),
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          constraints: BoxConstraints(maxHeight: 120),
          itemBuilder: (context, item, isDisabled, isSelected) {
            return ListTile(
              selected: isSelected,
              title: Text(item, style: 14.sp()),
            );
          },
          loadingBuilder: (context, searchEntry) {
            return CircularProgressIndicator();
          },
          emptyBuilder: (context, searchEntry) {
            return Text('There is no status now');
          },
        ),
        compareFn: (item1, item2) => item1 == item2,
      ),
    ),
  );
}
