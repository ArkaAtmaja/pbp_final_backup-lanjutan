import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/view/payments/body.dart';

class payment extends StatelessWidget {
  static String routeName = "/login_success";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
      ),
      body: Body(),
    );
  }
}