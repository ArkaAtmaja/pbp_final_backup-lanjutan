import 'dart:convert';

class Pembayaran{
  int id;
  String jumlah;
  String metode;
  String harga;

  Pembayaran(
      {required this.id,
      required this.jumlah,
      required this.metode,
      required this.harga});

  factory Pembayaran.fromRawJson(String str) => Pembayaran.fromRawJson(json.decode(str));
  factory Pembayaran.fromJson(Map<String, dynamic> json) => Pembayaran(
    id: json["id"], 
    jumlah: json["jumlah"], 
    metode: json["metode"],
    harga: json["harga"],
    );


  String toRawJson() => json.encode(toJson());
  Map<String, dynamic> toJson() => {
    "id" : id,
    "jumlah" :jumlah,
    "metode": metode,
    "harga" : harga,
  };
}
