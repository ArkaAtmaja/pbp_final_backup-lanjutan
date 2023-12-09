import 'dart:async';

import 'package:news_c_kelompok4/addNews/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/view/view_list.dart';
import 'package:news_c_kelompok4/view/profile/profile.dart';
import 'package:sensors/sensors.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  runApp(MaterialApp(
    home: HomeView(),
  ));
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;
  int _clicked = -1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _clicked = -1; // Reset clicked when switching tabs
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'lib/images/logo.png',
          width: screenSize.width * 0.1, // 10% of screen width
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
      ),
      body: _selectedIndex == 0
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                    child: Text(
                      'Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Post News button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(screenSize.width * 0.4,
                                    screenSize.height * 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 10,
                                primary: Colors
                                    .white, // Menggunakan primary untuk warna latar belakang
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .newspaper_rounded, // Menggunakan ikon Icons.newspaper
                                    size: 40, // Sesuaikan ukuran ikon
                                    color: Color.fromARGB(
                                        255, 162, 61, 36), // Warna ikon
                                  ),
                                  Text(
                                    'News',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print('Post News button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(screenSize.width * 0.4,
                                    screenSize.height * 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 10,
                                primary: Colors
                                    .white, // Menggunakan primary untuk warna latar belakang
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .newspaper, // Menggunakan ikon Icons.newspaper
                                    size: 40, // Sesuaikan ukuran ikon
                                    color: Colors.black, // Warna ikon
                                  ),
                                  Text(
                                    'Post News',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.04),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                print('Post News button pressed');
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(screenSize.width * 0.4,
                                    screenSize.height * 0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 10,
                                primary: Colors
                                    .white, // Menggunakan primary untuk warna latar belakang
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons
                                        .people_alt_outlined, // Menggunakan ikon Icons.newspaper
                                    size: 40, // Sesuaikan ukuran ikon
                                    color: Colors.black, // Warna ikon
                                  ),
                                  Text(
                                    'About',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _widgetOptions.elementAt(_selectedIndex),
                ],
              ),
            )
          : _widgetOptions.elementAt(_selectedIndex),
    );
  }

  static const List<Widget> _widgetOptions = <Widget>[
    Center(),
    MyHomePage(),
    ProfilView(),
  ];
}
