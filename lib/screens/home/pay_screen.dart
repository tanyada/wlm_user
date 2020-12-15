import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsss/screens/authenticate/constants.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'confirm_screen.dart';

PickedFile imageFile;
final ImagePicker picker = ImagePicker();

class PayScreen extends StatelessWidget {
  String licenplace, detail, offense, place, password;
  int fine, deposit, sum;

  PayScreen(this.licenplace, this.deposit, this.detail, this.offense,
      this.place, this.fine, this.sum, this.password);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(title: Text('รายละเอียดการชำระเงิน')),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: const EdgeInsets.all(15.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('หมายเลขทะเบียน'),
                      trailing: Text(this.licenplace),
                    ),
                    ListTile(
                      title: Text('รายละเอียด'),
                      trailing: Text(this.detail),
                    ),
                    ListTile(
                      title: Text('ข้อหาที่กระทำผิด'),
                      trailing: Text(this.offense),
                    ),
                    ListTile(
                      title: Text('สถานที่'),
                      trailing: Text(this.place),
                    ),
                    ListTile(
                      title: Text('ค่าปรับ'),
                      trailing: Text(this.fine.toString() + '   บาท'),
                    ),
                    ListTile(
                      title: Text('ค่ามัดจำอุปกรณ์'),
                      trailing: Text(this.deposit.toString() + '   บาท'),
                    ),
                    ListTile(
                      title: Text('รวมที่ต้องชำระ'),
                      trailing: Text(this.sum.toString() + '   บาท'),
                    ),
                    SizedBox(height: size.height * 0.03),
                    Image(
                      width: 250,
                      image: AssetImage('assets/images/PromptPay-logo.png'),
                    ),
                    QrImage(
                      data: PromptPay.generateQRData("0910620202",
                          amount: this.sum.toDouble()),
                      size: 200,
                      version: QrVersions.auto,
                      gapless: false,
                      embeddedImage: AssetImage('assets/images/unnamed.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(120, 120),
                      ),
                    ),
                    Text(
                      'สแกน QR เพื่อโอนเข้าบัญชี',
                      style: TextStyle(fontSize: 17, color: Colors.blue[900]),
                    ),
                    Text(
                      'ชื่อ: น.ส. ธัญดา ลี้พงษ์กุล',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      'บัญชี: xxx-x-x2725-x',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    ButtonBar(
                      children: <Widget>[
                        FlatButton(
                          child: const Text(
                            ('ยืนยันหลักฐานการชำระเงิน'),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ConfirmScreen(
                                    this.licenplace,
                                    this.detail,
                                    this.offense,
                                    this.place,
                                    this.sum,
                                    this.password)));
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _editbuttomform(context, String lisence, String detail, String offense,
    String place, int sum) {
  PickedFile imageFile;
  final ImagePicker picker = ImagePicker();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  //color: Colors.blue[300],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: imageFile == null
                      ? Image.asset('lib/images/photo.png')
                      : Image.file(File(imageFile.path)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'หมายเลขทะเบียนรถ : $lisence',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('รายละเอียด : $detail',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('ข้อหาที่กระทำผิด : $offense',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('สถานที่ : $place',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('รวมที่ต่องจ่าย : $sum',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    size: 36.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    chooseImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> chooseImage(ImageSource imageSource) async {
  try {
    PickedFile object = await picker.getImage(
      source: imageSource,
      maxWidth: 800.0,
      maxHeight: 800.0,
    );
    imageFile = object;
  } catch (e) {}
}
