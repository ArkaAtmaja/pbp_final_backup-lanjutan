import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_c_kelompok4/view/profile/editprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; // Import responsive_sizer
import 'package:news_c_kelompok4/client/auth.dart';
import 'package:news_c_kelompok4/model/user_model.dart';
import 'package:news_c_kelompok4/view/about/about.dart';
import 'dart:io';

class ProfilView extends StatefulWidget {
  const ProfilView({Key? key}) : super(key: key);

  @override
  _ProfilViewState createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  bool _isEditing = false;
  bool _isPasswordVisible = false;
  late String username = 'NULL';
  String selectedImagePath = '';
  String selectedImagePath2 = '';
  String imageProfile = '';
  String imageSampul = '';
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

  Future<void> editProfile(BuildContext context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditProfileView()));
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
      imageProfile: imageProfile,
      imageSampul: imageSampul,
    );
    await UserClient.update(input);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data diri berhasil diperbarui!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _saveUserData() async {
    _updateUserData();

    setState(() {
      _isEditing = false;
    });
  }

  Future selectImage() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.h),
          ),
          child: Container(
            height: 30.h,
            child: Padding(
              padding: EdgeInsets.all(3.h),
              child: Column(
                children: [
                  Text(
                    'Select Image From !',
                    style: TextStyle(
                      fontSize: 15.0.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          print('Image_path: -');
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(3.h),
                            child: Icon(Icons.browse_gallery),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          print('Image_path: -');
                          Navigator.pop(context);
                          setState(() {});
                        },
                        child: Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(3.h),
                            child: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.sp),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
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
                imageProfile = userDataMap['imgProfile'] ?? '';
                imageSampul = userDataMap['imgSampul'] ?? '';
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
                              : imageSampul.isNotEmpty
                                  ? Image.file(
                                      File(imageSampul),
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
                                : imageProfile.isNotEmpty
                                    ? Image.file(
                                        File(imageProfile),
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
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 45.sp), // Adjusted for manual shifting
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          username,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 40.sp), // Adjusted for manual shifting
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          emailController.text,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text('Posts',
                        style: Theme.of(context).textTheme.headlineSmall),
                    Text('100+', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(height: 20.sp),
                    SizedBox(height: 3.h),
                    SizedBox(
                      width: 50.w, // Adjusted for responsive sizing
                      child: ElevatedButton(
                        onPressed: () {
                          editProfile(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 144, 141, 149),
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined,
                                color: Color.fromARGB(255, 250, 249, 249)),
                            SizedBox(width: 6.w),
                            Text('Edit Profile',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            SizedBox(width: 7.w),
                            Icon(LineAwesomeIcons.angle_right),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 144, 141, 149),
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.announcement,
                                color: Color.fromARGB(255, 250, 249, 249)),
                            SizedBox(width: 6.w),
                            Text('About',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            SizedBox(width: 15.w),
                            Icon(LineAwesomeIcons.angle_right),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 144, 141, 149),
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.settings,
                                color: Color.fromARGB(255, 250, 249, 249)),
                            SizedBox(width: 6.w),
                            Text('Settings',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            SizedBox(width: 11.w),
                            Icon(LineAwesomeIcons.angle_right),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
                        onPressed: () {
                          // pushShowPayment(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 168, 28, 133),
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on_rounded,
                                color: Color.fromARGB(255, 250, 249, 249)),
                            SizedBox(width: 6.w),
                            Text('PRO',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            SizedBox(width: 17.w),
                            Icon(LineAwesomeIcons.angle_right),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: ElevatedButton(
                        onPressed: () {
                          logout(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 144, 141, 149),
                          shape: StadiumBorder(),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.logout,
                                color: Color.fromARGB(255, 250, 249, 249)),
                            SizedBox(width: 6.w),
                            Text('Logout',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 250, 249, 249))),
                            SizedBox(width: 13.w),
                            Icon(LineAwesomeIcons.angle_right),
                          ],
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
