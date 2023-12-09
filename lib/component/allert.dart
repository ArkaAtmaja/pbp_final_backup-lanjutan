import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/view/login.dart';

Future<void> dialogAlertByCharlie(BuildContext context, Map<String, dynamic> formData) async{

    return showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Allert!'),
          content: const Text('Apakah Data Anda Sudah Benar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LoginView(
                      data: formData,
                      ),
                    ),
                  );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
} 