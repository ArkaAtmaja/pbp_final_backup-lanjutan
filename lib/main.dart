import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/View/login.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        Device.orientation == Orientation.portrait
        ? Container(
          width: 100.w,
          height: 20.5.h,
        )
        : Container(
          width: 100.w,
          height: 12.5.h,
        );
        Device.screenType == ScreenType.tablet
        ? Container(
          width: 100.w,
          height: 20.5.h,
        )
        : Container(
          width: 100.w,
          height: 12.5.h,
        );
        return const MainApp();
      },
    ),
  ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NEWS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'LoginView': (context) => LoginView(),
      },
      initialRoute: 'LoginView',
    );
  }
}
