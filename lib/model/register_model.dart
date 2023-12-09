import 'dart:convert';

class RegisterModel {
  final int status;
  final String message;
  final User data;

  const RegisterModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RegisterModel.formRawJson(String str) =>
      RegisterModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        status: json["status"],
        message: json["message"],
        data: User.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final DateTime tanggalLahir;
  final String gender;

User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.tanggalLahir,
    required this.gender,
  });

  factory User.formRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

   factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        tanggalLahir: DateTime.parse(json["tanggalLahir"]), // Parse string to DateTime
        gender: json["gender"],
      );
     


  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "tanggalLahir": tanggalLahir.toIso8601String(), // Convert DateTime to string if needed
        "gender": gender,

      };
}