import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_c_kelompok4/addNews/home_screen.dart';
import 'package:news_c_kelompok4/view/payments/pdf/pdf_view.dart';
import 'package:news_c_kelompok4/view/payments/pdf/invoice/model/product.dart';
import 'package:news_c_kelompok4/view/home.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:news_c_kelompok4/view/home.dart';

class PaymentDetailsModal extends StatefulWidget {
  const PaymentDetailsModal({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: PaymentDetailsContent(
            id: const Uuid().v1(),
            image: File('lib/images/logo.png'),
            products: [
              Product("Membership", 10000),
            ],
          ),
        );
      },
    );
  }

  @override
  _PaymentDetailsModalState createState() => _PaymentDetailsModalState();
}

class _PaymentDetailsModalState extends State<PaymentDetailsModal> {
  final formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";

  @override
  void initState() {
    super.initState();
    // Panggil metode loadUserData() jika perlu
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // Tambahkan elemen UI Anda di sini
        );
  }
}

class PaymentDetailsContent extends StatelessWidget {
  final String id;
  final File image;
  final List<Product> products;

  PaymentDetailsContent({
    required this.id,
    required this.image,
    required this.products,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      padding: EdgeInsets.symmetric(horizontal: 2.h, vertical: 1.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Detail Pembayaran',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText('Total', TextAlign.left),
              buildText('10k', TextAlign.right),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText('Pembayaran', TextAlign.left),
              buildText('Gopay', TextAlign.right),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText('Kode Bayar', TextAlign.left),
              buildText('12345', TextAlign.right),
            ],
          ),
          SizedBox(height: 8.0),
          GestureDetector(
            onTap: () {
              createPdf(id, context, products);
            },
            child: buildText('Detail', TextAlign.left, color: Colors.blue),
          ),
          SizedBox(height: 20.0),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFA95C8D),
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Oke'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildText(String text, TextAlign align, {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: color,
            fontSize: 16.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
