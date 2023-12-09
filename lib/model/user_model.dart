import 'dart:convert';

class User {
  int id;
  String username;
  String email;
  String password;
  String tanggalLahir;
  String noTelp;
  String gender;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.password,
      required this.tanggalLahir,
      required this.noTelp,
      required this.gender,
      });

  factory User.fromRawJson(String str) => User.fromRawJson(json.decode(str));
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        tanggalLahir: json["tanggalLahir"],
        noTelp: json["noTelp"],
        gender: json["gender"],
      );

  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "tanggalLahir": tanggalLahir,
        "noTelp": noTelp,
        "gender": gender
      };
}
