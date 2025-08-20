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
