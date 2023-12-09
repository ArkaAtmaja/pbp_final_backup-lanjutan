import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/model/addNews_model.dart';
import 'package:news_c_kelompok4/database/sql_helper.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:news_c_kelompok4/client/addNews_Client.dart';
import 'package:news_c_kelompok4/addNews/home_screen.dart';
import 'dart:io';

class ShowNews extends StatefulWidget {
  
  const ShowNews(
      {super.key,
      required this.title,
      required this.id,
      required this.judul,
      required this.kategori,
      required this.deskripsi});

  final String? title, judul, kategori;
  final int? id;
  final String? deskripsi;

  @override
  State<ShowNews> createState() => _ShowNewsState();
}

class _ShowNewsState extends State<ShowNews> {
  TextEditingController controllerJudul = TextEditingController();
  TextEditingController controllerKategori = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  String selectedImagePath = '';

  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.h)),
            child: Container(
                height: 30.h,
                child: Padding(
                  padding: EdgeInsets.all(3.h),
                  child: Column(children: [
                    Text(
                      'Select Image From !',
                      style: TextStyle(
                          fontSize: 15.0.sp, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromGallery();
                            print(
                                'Image_path u: $selectedImagePath'); // Print the selected image path
                            //controllerLinkGambar.text =
                                selectedImagePath; // Update controllerLinkGambar
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: EdgeInsets.all(3.h),
                              child: const Icon(Icons.browse_gallery),
                            ),
                          ),
                        ),
                        GestureDetector(
                            onTap: () async {
                              selectedImagePath = await selectImageFromCamera();
                              print('Image_path: -');
                              //controllerLinkGambar.text = selectedImagePath;
                              print(selectedImagePath);
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: EdgeInsets.all(3.h),
                                child: Icon(Icons.camera_alt),
                              ),
                            )),
                      ],
                    )
                  ]),
                )),
          );
        });
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);

    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);

    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerJudul.text = widget.judul!;
      controllerKategori.text = widget.kategori!;
      controllerDeskripsi.text = widget.deskripsi!;
      if (selectedImagePath.isNotEmpty) {
        //controllerLinkGambar.text = selectedImagePath;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Show News"),
        ),
        body: ListView(
          padding: EdgeInsets.all(3.h),
          children: <Widget>[
            TextFormField(
              key: const ValueKey('judul'),
              controller: controllerJudul,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Judul News',
              ),
            ),
            SizedBox(height: 4.h),
            TextFormField(
              key: const ValueKey('Kategori'),
              controller: controllerKategori,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Kategori',
              ),
            ),
            SizedBox(height: 4.h),
            TextFormField(
              key: const ValueKey('Deskripsi'),
              controller: controllerDeskripsi,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Deskripsi',
              ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (widget.id == null) {
                  onSubmit();
                } else {
                  onSubmit();
                }
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(), // Replace MenuHome with the actual widget for your home page
                  ),
                );
              },
            )
          ],
        )
        );
  }

  void onSubmit() async {

    addNews input = addNews(
        id: widget.id ?? 0,
        judul: controllerJudul.text,
        kategori: controllerKategori.text,
        deskripsi: controllerDeskripsi.text);

    try {
      if (widget.id == null) {
        await addNewsClient.create(input);
      } else {
        await addNewsClient.update(input);
      }
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> addBerita() async {

    await SQLHelper.addBerita(
        controllerJudul.text,
        controllerKategori.text,
        controllerDeskripsi.text);
  }

  Future<void> editBerita(int id) async {

    await SQLHelper.editBerita(
        id,
        controllerJudul.text,
        controllerKategori.text,
        controllerDeskripsi.text);
  }
}
