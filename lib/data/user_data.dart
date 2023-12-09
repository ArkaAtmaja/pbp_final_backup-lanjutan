class UserData {
  final String username;
  final String email;
  final String password;
  final String phone;
  final String gender;

  UserData({
    required this.username,
    required this.email,
    required this.password,
    required this.phone,
    required this.gender,
  });

  factory UserData.fromJson(Map<String, dynamic> json, List<UserData> existingUsers) {
    final String email = json['email'];
    // ngecek email udh ada apa belum
    if (existingUsers.any((user) => user.email == email)) {
      throw FormatException('Email is not unique.');
    }

    return UserData(
      username: json['username'],
      email: email,
      password: json['password'],
      phone: json['phone'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'phone': phone,
      'gender': gender,
    };
  }
}