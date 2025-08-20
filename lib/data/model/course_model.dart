class InsertCourse {
  final String name;
  final String description;
  final int studentLimit;
  final int currentStudents;
  final DateTime startDate;
  final DateTime endDate;

  InsertCourse({
    required this.name,
    required this.description,
    required this.studentLimit,
    required this.currentStudents,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "description": description,
      "student_limit": studentLimit,
      "current_students": currentStudents,
      "start_date": startDate.toIso8601String(),
      "end_date": endDate.toIso8601String(),
    };
  }
}
