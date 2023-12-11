import 'package:flutter/material.dart';
import 'package:news_c_kelompok4/view/payments/default_button.dart';
import 'package:news_c_kelompok4/view/payments/size_config.dart';
import 'package:news_c_kelompok4/view/payments/body.dart';
import 'package:news_c_kelompok4/view/payments/modals_payement.dart';
import 'package:news_c_kelompok4/view/payments/method/QR_view.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Panggil SizeConfig().init(context) di awal metode build
    SizeConfig().init(context);

    return Container(
      color: Color(0xFFEBEBEB),
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.04),
          Image.asset(
            "lib/images/logo.png",
            height: SizeConfig.screenHeight * 0.33,
          ),
          SizedBox(height: 16.0),
          Text(
            "Pro - Account" "\n",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(24),
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check,
                color: Colors.purple,
                size: getProportionateScreenWidth(18),
              ),
              SizedBox(width: 8),
              Text(
                "\tPost News",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(18),
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          Spacer(),
          Spacer(),
          Spacer(),
          Spacer(),
          Text(
            "10k / mo",
            style: TextStyle(
              fontSize: getProportionateScreenWidth(21),
              fontWeight: FontWeight.bold,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          Spacer(),
          SizedBox(
            width: SizeConfig.screenWidth * 0.6,
            child: DefaultButton(
              text: "Order Now",
              press: () {
                _displayBottomSheet(context);
              },
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  Future<void> _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => BottomSheetContent(),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 390,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildButton('Transfer Bank', Colors.blue, Icons.atm),
          SizedBox(height: 5.0),
          ElevatedButton(
            onPressed: () {
              pushShowQRIS(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 50, 47, 49),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.qr_code, color: Colors.white),
                Text(
                  'Pembayaran QRIS',
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(width: 24.0),
              ],
            ),
          ),
          _buildButton('Shopee Pay', Colors.orange, Icons.shop),
          _buildButton('Gopay', Colors.green, Icons.motorcycle),
          SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal:',
                style: TextStyle(fontSize: 16.0),
              ),
              Text(
                '10K',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _confirmSave(context);
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFA95C8D),
              onPrimary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
            ),
            child: Text('Pay Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, Color color, IconData iconData) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: () {
          print('Button pressed: $label');
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.h),
        ),
        child: Row(
          children: [
            Icon(iconData),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmSave(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Konfirmasi'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Apakah Anda yakin ingin membayar?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
              _showToast("Pembayaran gagal", false);
            },
          ),
          TextButton(
            child: Text('Ya'),
            onPressed: () {
              Navigator.of(context).pop();
              _pushShowModalSPayNow(context);
              _showToast("Pembayaran berhasil", true);
            },
          ),
        ],
      );
    },
  );
}

void _pushShowModalSPayNow(BuildContext context) {
  PaymentDetailsModal.show(context);
}

void pushShowQRIS(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => BarcodeScreen(),
    ),
  );
}

void _showToast(String message, bool isSuccess) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: isSuccess ? Colors.green : Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
