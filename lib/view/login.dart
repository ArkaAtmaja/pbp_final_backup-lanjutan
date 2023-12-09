import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/View/home.dart';
import 'package:news_c_kelompok4/View/register.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:news_c_kelompok4/model/user_model.dart';
import 'package:news_c_kelompok4/client/auth.dart';

class LoginView extends StatefulWidget {
  final Map? data;

  const LoginView({Key? key, this.data}) : super(key: key);

  @override
  State<LoginView> createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> saveLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
  }

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);
    prefs.remove('username');
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      await logout();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up', style: Theme.of(context).textTheme.headlineMedium),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  key: const ValueKey('username'),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "username tidak boleh kosong";
                    }
                    return null;
                  },
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Username",
                    labelText: "Username",
                    helperText: "Inputkan User yang telah didaftar",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(2.0.h),
                child: TextFormField(
                  key: const ValueKey('password'),
                  validator: (p0) {
                    if (p0 == null || p0.isEmpty) {
                      return "password kosong";
                    }
                    return null;
                  },
                  obscureText: _isObscured,
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: "Password",
                    labelText: "Password",
                    helperText: "Inputkan Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    User? user;
                    try {
                      user = await UserClient.login(
                          usernameController.text, passwordController.text);
                      Fluttertoast.showToast(
                        msg: "Login Sukses",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.blue,
                        textColor: Colors.white,
                      );
                      await saveLoginStatus();
                      await saveUsername(usernameController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeView()),
                      );
                    } catch (e) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title:
                              const Text('Password Salah atau Username Salah'),
                          content: TextButton(
                            onPressed: () => pushRegister(context),
                            child: const Text('Daftar Disini !!'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'cancel'),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 40), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), 
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('New User?',
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(width: 10), 
                  TextButton(
                    onPressed: () {
                      pushRegister(context);
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pushRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterView()),
    );
  }
}
