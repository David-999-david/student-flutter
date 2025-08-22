class InsertCourse {
  final String name;
  final String description;
  final int studentLimit;
  final DateTime startDate;
  final DateTime endDate;
  final bool status;

  InsertCourse({
    required this.name,
    required this.description,
    required this.studentLimit,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "student_limit": studentLimit,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
      "status": status,
    };
  }
}

class CourseModel {
  final int id;
  final String name;
  final String description;
  final bool status;
  final int studentLimit;
  final int currentStudents;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;

  CourseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.studentLimit,
    required this.currentStudents,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      studentLimit: json['student_limit'],
      currentStudents: json['current_students'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class CourseStuds {
  final int id;
  final String name;
  final String description;
  final bool status;
  final int studentLimit;
  final int currentStudents;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final List<StudInCourse> students;

  CourseStuds({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.studentLimit,
    required this.currentStudents,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.students,
  });

  factory CourseStuds.fromJson(Map<String, dynamic> json) {
    final students = (json['students'] as List<dynamic>)
        .map((s) => StudInCourse.fromJson(s))
        .toList();

    return CourseStuds(
      id: json['courseId'],
      name: json['course_name'],
      description: json['description'],
      status: json['courseStatus'],
      studentLimit: json['student_limit'],
      currentStudents: json['current_students'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      createdAt: DateTime.parse(json['course_created_at']),
      students: students,
    );
  }
}

class StudInCourse {
  final int id;
  final String name;
  final bool status;

  StudInCourse({required this.id, required this.name, required this.status});

  factory StudInCourse.fromJson(Map<String, dynamic> json) {
    return StudInCourse(
      id: json['studentId'],
      name: json['studentName'],
      status: json['studentStatus'],
    );
  }
}

class InsertJoin {
  final int courseId;
  final List<int> studentIds;

  InsertJoin({required this.courseId, required this.studentIds});

  Map<String, dynamic> toJson() {
    return {"courseId": courseId, "studentIds": studentIds};
  }
}

class CancelJoin {
  final int courseId;
  final int studentId;

  CancelJoin({required this.courseId, required this.studentId});

  Map<String, dynamic> toJson() {
    return {"courseId": courseId, "studentId": studentId};
  }
}
