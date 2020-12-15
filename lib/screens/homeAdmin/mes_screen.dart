import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/constants.dart';

import 'home_screen.dart';

class MesScreen extends StatefulWidget {
  String lisen, place, detail, offense, image, password;
  int sum;
  Timestamp date;
  MesScreen(this.lisen, this.place, this.offense, this.sum, this.date,
      this.image, this.password);

  @override
  _MesScreen createState() =>
      _MesScreen(lisen, place, offense, sum, date, image, password);
}

class _MesScreen extends State<MesScreen> {
  String lisen, place, detail, offense, urlPicture, image, password;
  int sum;
  Timestamp date;

  _MesScreen(this.lisen, this.place, this.offense, this.sum, this.date,
      this.image, this.password);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text(this.lisen),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('หมายเลขทะเบียน'),
                      trailing: Text(this.lisen),
                    ),
                    ListTile(
                      title: Text('จำนวนเงินที่ชำระ'),
                      trailing: Text(this.sum.toString() + ' บาท'),
                    ),
                    ListTile(
                      title: Text('วันที่และเวลา'),
                      trailing: Text(DateTime.fromMicrosecondsSinceEpoch(
                              date.microsecondsSinceEpoch)
                          .toString()),
                    ),
                    ListTile(
                      title: Text('สถานที่'),
                      trailing: Text(this.place),
                    ),
                    ListTile(
                      title: Text('หลักฐานการชำระเงิน'),
                    ),
                    Image.network(
                      image,
                      height: 500,
                      width: 350,
                      fit: BoxFit.fitWidth,
                      scale: 0.8,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SaveButton(
                    text: "ส่งรหัสผ่าน",
                    press: () {
                      sendpassword(this.lisen, this.password, this.place);
                    },
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  CancleButton(
                    text: "แจ้งการชำระเงินผิด",
                    press: () {
                      sendwrongconfirm(this.lisen, this.password, this.place);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendpassword(licen, password, place) async {
    Firestore documentReference = Firestore.instance;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    DateTime time = new DateTime.now();

    Map<String, dynamic> message = {
      "Status": "รหัสผ่านของท่านคือ " + password,
      "Licenseplate": licen,
      "Token": token,
      "Date": time,
      "Place": place
    };

    await documentReference
        .collection('Message')
        .document()
        .setData(message)
        .whenComplete(() {
      showAlertDialog(context, licen);
    });
  }

  sendwrongconfirm(licen, password, place) async {
    Firestore documentReference = Firestore.instance;
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    DateTime time = new DateTime.now();

    Map<String, dynamic> message = {
      "Status": "การชำระของท่านผิดพลาดกรุณาลองใหม่อีกครั้ง",
      "Licenseplate": licen,
      "Token": token,
      "Date": time,
      "Place": place
    };

    await documentReference
        .collection('Message')
        .document()
        .setData(message)
        .whenComplete(() {
      showAlertDialog(context, licen);
    });
  }

  showAlertDialog(BuildContext context, licen) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('ส่งรหัสผ่าน ' + licen),
      content: Text('ส่งรหัสผ่านเรียบร้อย'),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class SaveButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const SaveButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.green,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class CancleButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const CancleButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.red,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
