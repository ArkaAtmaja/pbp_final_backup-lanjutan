import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DetailNews extends StatefulWidget {
  const DetailNews(
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
  State<DetailNews> createState() => _DetailNewsState();
}

class _DetailNewsState extends State<DetailNews> {
  TextEditingController controllerJudul = TextEditingController();
  TextEditingController controllerKategori = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      controllerJudul.text = widget.judul!;
      controllerKategori.text = widget.kategori!;
      controllerDeskripsi.text = widget.deskripsi!;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: ListView(
        key: const Key("scroll"),
        padding: EdgeInsets.all(3.h),
        children: <Widget>[
          //Image.file(
            //File(controllerLinkGambar.text),
            //height: 50.h,
            //width: 100.w,
            //fit: BoxFit.fill,
          //),
          SizedBox(height: 4.h),
          TextField(
            controller: controllerJudul,
            enabled: false,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Judul',
            ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controllerKategori,
            enabled: false,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Kategori',
            ),
          ),
          SizedBox(height: 4.h),
          TextField(
            controller: controllerDeskripsi,
            enabled: false,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Deskripsi',
            ),
          ),
        ],
      ),
    );
  }
}
