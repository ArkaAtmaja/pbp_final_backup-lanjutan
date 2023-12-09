import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:uuid/uuid.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BarcodeScreen extends StatefulWidget {
  @override
  _BarcodeScreenState createState() => _BarcodeScreenState();
}

class _BarcodeScreenState extends State<BarcodeScreen> {
  late String generatedUUID;

  @override
  void initState() {
    super.initState();
    generateUUID(); // Panggil generateUUID saat tampilan dibuat
  }

  void generateUUID() {
    final uuid = Uuid();
    setState(() {
      generatedUUID = uuid.v1(); // Generate UUID dengan timestamp
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran QR'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'QRIS PBP NEWS PRO',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: barcodeKotak(generatedUUID),
          ),
        ],
      ),
    );
  }

  Widget barcodeKotak(String id) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
          child: BarcodeWidget(
            barcode: Barcode.qrCode(
              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
            ),
            data: id,
            width: 300,
            height: 300,
          ),
        ),
        SizedBox(height: 20),
        Text(
          '$generatedUUID',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
