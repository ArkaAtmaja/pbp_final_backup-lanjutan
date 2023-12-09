import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:news_c_kelompok4/client/auth.dart';
import 'package:news_c_kelompok4/model/user_model.dart';
import 'dart:io';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _isPasswordVisible = false;
  late String username = 'NULL';
  String selectedImagePath = '';
  String profileImg = '';
  int userID = 0;

  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController noTelpController;
  late TextEditingController tanggalLahirController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();
    loadUserData();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    tanggalLahirController = TextEditingController();
    noTelpController = TextEditingController();
    genderController = TextEditingController();
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('username');

    Navigator.pushReplacementNamed(context, 'LoginView');
  }

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<Map<String, dynamic>> _getUserData() async {
    return await UserClient.getUserByUsername(username);
  }

  Future<void> _updateUserData() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String date = tanggalLahirController.text;
    String noTelp = noTelpController.text;
    String gender = genderController.text;

    User input = User(
      id: userID,
      username: username,
      email: email,
      password: password,
      noTelp: noTelp,
      tanggalLahir: date,
      gender: gender,
    );
    await UserClient.update(input);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data diri berhasil diperbarui!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmSave() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Anda yakin ingin menyimpan data?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Ya'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveUserData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveUserData() async {
    _updateUserData();

    setState(() {
      // Bersihkan state atau lakukan aksi lain jika diperlukan
    });
  }

  void _cancelEdit() {
    // Bersihkan state atau lakukan aksi lain jika diperlukan
    setState(() {});
  }

  Future<void> selectImage() async {
    // Implementasi fungsi selectImage sesuai kebutuhan Anda
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userData = snapshot.data;

              if (userData != null && userData['status'] == true) {
                final userDataMap = userData['data'];

                // Set controller values
                usernameController.text = userDataMap['username'] ?? '';
                emailController.text = userDataMap['email'] ?? '';
                passwordController.text = userDataMap['password'] ?? '';
                tanggalLahirController.text = userDataMap['tanggalLahir'] ?? '';
                noTelpController.text = userDataMap['noTelp'] ?? '';
                genderController.text = userDataMap['gender'] ?? '';
                profileImg = userDataMap['img'] ?? '';
              } else {
                print('User data is null or status is false');
              }

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        selectImage();
                        setState(() {});
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(150.h),
                        child: selectedImagePath.isNotEmpty
                            ? Image.file(
                                File(selectedImagePath),
                                height: 30.h,
                                width: 70.w,
                                fit: BoxFit.fill,
                              )
                            : profileImg.isNotEmpty
                                ? Image.file(
                                    File(profileImg),
                                    height: 30.h,
                                    width: 70.w,
                                    fit: BoxFit.fill,
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(150.h),
                                    ),
                                    child: Image.asset(
                                      './images/def_image.jpg',
                                      height: 30.h,
                                      width: 70.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    TextFormField(
                      controller: usernameController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'You cannot change your username',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0.h),
                    TextFormField(
                      controller: emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'You cannot change your email',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0.h),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0.h),
                     TextFormField(
                  key: const ValueKey('tanggalLahir'),
                  controller: tanggalLahirController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        tanggalLahirController.text =
                            pickedDate.toLocal().toString().split(' ')[0];
                      });
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: 'Tanggal',
                     border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            tanggalLahirController.text =
                                pickedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) =>
                      value == '' ? 'Masukkan tanggal lahir!' : null,
                ),
                    SizedBox(height: 3.0.h),
                    TextFormField(
                      controller: noTelpController,
                      decoration: InputDecoration(
                          labelText: 'Nomor Telepon',
                          prefixIcon: Icon(Icons.phone_android),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                    ),
                    SizedBox(height: 3.0.h),
                    TextFormField(
                      controller: genderController,     
                      decoration: InputDecoration(
                        labelText: 'Gender',
                         prefixIcon: Icon(Icons.transgender_sharp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 3.0.h),
                    ElevatedButton(
                      onPressed: _confirmSave,
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
