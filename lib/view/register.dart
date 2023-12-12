import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/View/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:news_c_kelompok4/model/user_model.dart';
import 'package:news_c_kelompok4/client/auth.dart';

class RegisterView extends StatefulWidget {
  final String? currentAddress;

  const RegisterView({Key? key, this.currentAddress}) : super(key: key);

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController noTelpController = TextEditingController();
  TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isEmailUniqueValidator = true;

  bool _isObscure = true;

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future<void> checkEmailUniqueness(String email) async {
    try {
      bool isUnique = await UserClient.checkEmail(email);
      setState(() {
        isEmailUniqueValidator = isUnique;
      });
    } catch (err) {}
  }

  void showSuccessSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Selamat, Anda berhasil registrasi!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(2.0.h),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 3.0.h),
                SizedBox(height: 3.0.h),
                Text('Register',
                    style: Theme.of(context).textTheme.headlineMedium),
                SizedBox(height: 3.0.h),
                TextFormField(
                  key: const ValueKey('username'),
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Ucup',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Username Tidak Boleh Kosong';
                    }
                    List<String> forbiddenWords = [
                      'anjing',
                      'memek',
                      'kontol',
                      'jancok',
                      'tolol',
                      'babi',
                      'yatim',
                      'jembut',
                      'bodoh',
                      'goblok',
                      'pantek',
                      'pukimak',
                      'kampang'
                    ];
                    // Mengecek apakah username mengandung kata-kata kasar
                    for (String word in forbiddenWords) {
                      if (p0.toLowerCase().contains(word)) {
                        return 'Username mengandung kata kasar';
                      }
                    }
                    // Mengecek apakah username mengandung karakter khusus
                    String forbiddenChars = r'!@#$%^&*()_+{}[]|\:;"<>,.?/~`';
                    for (int i = 0; i < p0.length; i++) {
                      if (forbiddenChars.contains(p0[i])) {
                        return 'Username tidak boleh berisi karakter khusus';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.0.h),
                TextFormField(
                  key: const ValueKey('email'),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'ucup@gmail.com',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!p0.contains('@')) {
                      return 'Email harus menggunakan @';
                    }
                    if (!isEmailUniqueValidator) {
                      return 'Email sudah terdaftar, gunakan email lain';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 3.0.h),
                TextFormField(
                  key: const ValueKey('password'),
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'xxxxxxx',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: _isObscure
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: _toggleObscure,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  obscureText: _isObscure,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal 8 karakter!';
                    }
                    RegExp uppercaseRegex = RegExp(r'[A-Z]');
                    RegExp digitRegex = RegExp(r'\d');
                    RegExp specialCharRegex = RegExp(r'[!@#\$%^&*()]');

                    String errorMessage = '';

                    if (!uppercaseRegex.hasMatch(value)) {
                      errorMessage += 'Password harus ada satu huruf besar!\n';
                    }

                    if (!digitRegex.hasMatch(value)) {
                      errorMessage += 'Password harus ada satu angka! \n';
                    }

                    if (!specialCharRegex.hasMatch(value)) {
                      errorMessage +=
                          'Password harus ada satu karakter unik!\n';
                    }

                    if (errorMessage.isNotEmpty) {
                      return errorMessage.trim();
                    }
                    return null;
                  },
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (value) =>
                      value == '' ? 'Masukkan tanggal lahir!' : null,
                ),
                SizedBox(height: 3.0.h),
                TextFormField(
                  key: const ValueKey('noTelp'),
                  controller: noTelpController,
                  decoration: InputDecoration(
                    labelText: 'No Telp',
                    hintText: '081234454363',
                    prefixIcon: Icon(Icons.phone_android),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Nomor Telepon tidak boleh kosong!';
                    }
                    if (!RegExp(r'^\d{11,13}$').hasMatch(p0)) {
                      return 'Nomor Telepon harus terdiri dari 11 hingga 13 angka';
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 3.0.h),
                TextFormField(
                  key: const ValueKey('gender'),
                  controller: genderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    hintText: 'Pria/Wanita',
                    prefixIcon: Icon(Icons.transgender_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return 'Gender Tidak Boleh Kosong';
                    }
                    if (p0.toLowerCase() != 'pria' &&
                        p0.toLowerCase() != 'wanita') {
                      return 'Hanya boleh memasukkan "Pria" atau "Wanita"';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: SizedBox(
                    width: double.infinity.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        await checkEmailUniqueness(emailController.text);

                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Apakah yakin data anda sudah benar?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);

                                    String formattedDate =
                                        DateFormat('yyyy-MM-dd').format(
                                            DateTime.parse(
                                                tanggalLahirController.text));
                                    User input = User(
                                      id: 0,
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      tanggalLahir: tanggalLahirController.text,
                                      noTelp: noTelpController.text,
                                      gender: genderController.text,
                                    );

                                    await addUser(input);

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const LoginView()));
                                    showSuccessSnackBar();
                                  },
                                  child: const Text('Ya'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Tidak'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(5.w, 5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<int> addUser(User input) async {
    await UserClient.create(input);
    return 1;
  }
}
