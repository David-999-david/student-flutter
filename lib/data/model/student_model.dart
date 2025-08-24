class Gender {
  final int id;
  final String name;

  Gender({required this.id, required this.name});

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(id: json['id'], name: json['name']);
  }
}

class InsertStudent {
  final String name;
  final String email;
  final String phone;
  final String address;
  final int genderId;
  final bool status;

  InsertStudent({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.genderId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "gender_id": genderId,
      "status": status,
    };
  }
}

class StudentModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final bool status;
  final DateTime createdAt;

  StudentModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.status,
    required this.createdAt,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class StudentUpdate {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final int? genderId;
  final bool? status;

  StudentUpdate({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.genderId,
    this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "gender_id": genderId,
      "status": status,
    };
  }
}

class Student {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final bool status;
  final DateTime createdAt;
  final List<CourseForStud> courses;

  Student({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.status,
    required this.createdAt,
    required this.courses,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    final courses = (json['courses'] as List<dynamic>)
        .map((c) => CourseForStud.fromJson(c))
        .toList();
    return Student(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      gender: json['gender'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      courses: courses,
    );
  }
}

class CourseForStud {
  final int id;
  final String name;
  final String description;
  final int studentLimit;
  final int currentStudents;
  final bool status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  CourseForStud({
    required this.id,
    required this.name,
    required this.description,
    required this.studentLimit,
    required this.currentStudents,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory CourseForStud.fromJson(Map<String, dynamic> json) {
    return CourseForStud(
      id: json['courseId'],
      name: json['courseName'],
      description: json['description'],
      studentLimit: json['studentLimit'],
      currentStudents: json['currentStudents'],
      status: json['courseStatus'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Detail {
  final int sst;
  final int ssf;
  final int sgm;
  final int sgf;
  final int sgo;
  final int cst;
  final int csf;

  Detail({
    required this.sst,
    required this.ssf,
    required this.sgm,
    required this.sgf,
    required this.sgo,
    required this.cst,
    required this.csf,
  });

  factory Detail.fromJson(Map<String, dynamic> json) {
    return Detail(
      sst: json['s_s_t'],
      ssf: json['s_s_f'],
      sgm: json['s_g_m'],
      sgf: json['s_g_f'],
      sgo: json['s_g_o'],
      cst: json['c_s_t'],
      csf: json['c_s_f'],
    );
  }
}
