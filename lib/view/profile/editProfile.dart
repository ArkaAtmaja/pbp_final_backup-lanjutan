import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:news_c_kelompok4/client/auth.dart';
import 'package:news_c_kelompok4/model/user_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({Key? key});

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  bool _isPasswordVisible = false;
  late String username = 'NULL';
  String selectedImagePath = '';
  String selectedImagePath2 = '';
  String imgProfile = '';
  String imgSampul = '';
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
      userID = prefs.getInt('userID') ?? 0;
    });
  }

  Future<Map<String, dynamic>> _getUserData() async {
    return await UserClient.getUserByUsername(username);
  }

  Future<void> _updateUserData() async {
    try {
      String username = usernameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String date = tanggalLahirController.text;
      String noTelp = noTelpController.text;
      String gender = genderController.text;
      String imageProfile =
          selectedImagePath.isNotEmpty ? selectedImagePath : "";
      String imageSampul =
          selectedImagePath2.isNotEmpty ? selectedImagePath2 : "";
      print('USER ID: ${userID} ');

      User input = User(
        id: userID,
        username: username,
        email: email,
        password: password,
        noTelp: noTelp,
        tanggalLahir: date,
        gender: gender,
        imageProfile: imageProfile,
        imageSampul: imageSampul,
      );

      // Print the data being sent to the server for debugging
      print('Updating user data: ${input.toJson()}');

      // Update the user data
      await UserClient.update(input);

      // Save updated image paths in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('imageProfile', imageProfile);
      prefs.setString('imageSampul', imageSampul);

      Fluttertoast.showToast(
        msg: 'Data diri berhasil diperbarui!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Set state with updated image paths
      setState(() {
        imgProfile = imageProfile;
        imgSampul = imageSampul;
      });
    } catch (e) {
      // Print the error for debugging
      print('Error updating user data: $e');
      if (e is DioError) {
        print('DioError response: ${e.response}');
      } else {
        print('Unexpected error: $e');
      }
      return Future.error(e.toString());
    }
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
      _updateUserData();
    });
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
                imgProfile = userDataMap['imgProfile'] ?? '';
                imgSampul = userDataMap['imgSampul'] ?? '';
              } else {
                print('User data is null or status is false');
              }

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(),
                          child: selectedImagePath2.isNotEmpty
                              ? Image.file(
                                  File(selectedImagePath2),
                                  height: 20.h,
                                  width: 100.w,
                                  fit: BoxFit.fill,
                                )
                              : imgSampul.isNotEmpty
                                  ? Image.file(
                                      File(imgSampul),
                                      height: 20.h,
                                      width: 200.w,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.asset(
                                      'lib/images/cuaca.jpg',
                                      height: 20.h,
                                      width: 100.w,
                                      fit: BoxFit.fill,
                                    ),
                        ),
                        Positioned(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(150.sp),
                            child: selectedImagePath.isNotEmpty
                                ? Image.file(
                                    File(selectedImagePath),
                                    height: 15.h,
                                    width: 35.w,
                                    fit: BoxFit.fill,
                                  )
                                : imgProfile.isNotEmpty
                                    ? Image.file(
                                        File(imgProfile),
                                        height: 15.h,
                                        width: 35.w,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(150.sp),
                                        ),
                                        child: Image.asset(
                                          'lib/images/fotoProfil/user1.jpg',
                                          height: 15.h,
                                          width: 35.w,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                          ),
                        ),
                        Positioned(
                          top: 120,
                          right: 120.0,
                          child: InkWell(
                            onTap: () {
                              modalProfilImage(context);
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: Color.fromARGB(195, 109, 92, 92),
                              size: 40.0,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 5.0,
                          child: InkWell(
                            onTap: () {
                              modalCoverImage(context);
                            },
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.teal,
                              size: 35.0,
                            ),
                          ),
                        ),
                      ],
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
                                tanggalLahirController.text = pickedDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0];
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
                      style: ElevatedButton.styleFrom(
                        primary:
                            Colors.green, // Set the background color to green
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 1.h), // Adjust the padding for size
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 15.sp, // Adjust the font size
                          color: Colors.white, // Set the text color to white
                        ),
                      ),
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

void modalProfilImage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          height: 150.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
          child: Column(
            children: <Widget>[
              Text(
                "Pilih Foto Profil",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          selectImageProfilFromCamera();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Kamera"),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          selectImageProfilFromGallery();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Galeri"),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePhoto();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Hapus"),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

void modalCoverImage(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          height: 150.0,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
          child: Column(
            children: <Widget>[
              Text(
                "Pilih Sampul Profil",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {
                          selectImageSampulFromCamera();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Kamera"),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.image),
                        onPressed: () {
                          selectImageSampulFromGallery();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Galeri"),
                    ],
                  ),
                  SizedBox(width: 25),
                  Column(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletePhoto2();
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 10),
                      Text("Hapus"),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

selectImageProfilFromGallery() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 10);

  if (file != null) {
    return file.path;
  } else {
    return '';
  }
}

selectImageProfilFromCamera() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 10);

  if (file != null) {
    return file.path;
  } else {
    return '';
  }
}

selectImageSampulFromGallery() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 10);

  if (file != null) {
    return file.path;
  } else {
    return '';
  }
}

selectImageSampulFromCamera() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 10);

  if (file != null) {
    return file.path;
  } else {
    return '';
  }
}

void deletePhoto() async {
  final prefs = await SharedPreferences.getInstance();
  String _imagePath = 'lib/images/fotoProfil/user1.jpg';
}

void deletePhoto2() async {
  final prefs = await SharedPreferences.getInstance();

  String _imagePath = 'lib/images/cuaca.jpg';
}
