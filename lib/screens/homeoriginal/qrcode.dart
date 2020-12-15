import 'package:flutter/material.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Qrcode extends StatefulWidget {
  @override
  _QrcodeState createState() => _QrcodeState();
}

var promptpayDataWithAmount =
    PromptPay.generateQRData("0910620202", amount: 1400.00);
String qrData = promptpayDataWithAmount;

class _QrcodeState extends State<Qrcode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            QrImage(data: qrData),
          ],
        ),
      ),
    );
  }
}
