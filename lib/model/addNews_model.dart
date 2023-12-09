import 'dart:convert';

class addNews {
  int id;
  String judul;
  String kategori;
  String deskripsi;

  addNews(
      {required this.id,
      required this.judul,
      required this.kategori,
      required this.deskripsi});

  factory addNews.fromRawJson(String str) => addNews.fromRawJson(json.decode(str));
  factory addNews.fromJson(Map<String, dynamic> json) => addNews(
    id: json["id"], 
    judul: json["judul"], 
    kategori: json["kategori"],
    deskripsi: json["deskripsi"],
    );


  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id" : id,
    "judul" : judul,
    "kategori": kategori,
    "deskripsi" : deskripsi,
  };
}
