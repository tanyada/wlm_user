import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';
import 'home_screen.dart';

class ConfirmScreen extends StatefulWidget {
  String lisen, place, detail, offense, password;
  int sum;
  ConfirmScreen(this.lisen, this.detail, this.offense, this.place, this.sum,
      this.password);

  @override
  _ConfirmScreen createState() =>
      _ConfirmScreen(lisen, detail, offense, place, sum, password);
}

class _ConfirmScreen extends State<ConfirmScreen> {
  String lisen, place, detail, offense, urlPicture, password;
  int sum;
  PickedFile imageFile;
  final ImagePicker picker = ImagePicker();
  DateTime time = new DateTime.now();

  _ConfirmScreen(this.lisen, this.detail, this.offense, this.place, this.sum,
      this.password);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(title: Text('ยืนยันการชำระเงิน')),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              //color: Colors.blue[300],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.27,
              child: imageFile == null
                  ? Image.asset('lib/images/photo.png')
                  : Image.file(File(imageFile.path)),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              margin: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text('หมายเลขทะเบียนรถ'),
                    trailing: Text(this.lisen),
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
                    title: Text('ยอดชำระรวม'),
                    trailing: Text(this.sum.toString() + '  บาท'),
                  ),
                  ListTile(
                    title: Text('แนบหลักฐานการโอนเงิน'),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.add_photo_alternate,
                        size: 30.0,
                        color: kPrimaryColor,
                      ),
                      onPressed: () {
                        chooseImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SaveButton(
                  text: "บันทึก",
                  press: () {
                    if (imageFile == null) {
                      showAlert('ไม่พบรูป', 'กรุณาถ่ายภาพ หรือ เลือกรูปภาพ ');
                    } else {
                      uploadPictureToStorage();
                    }
                  },
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                CancleButton(
                  text: "ยกเลิก",
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreen();
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      PickedFile object = await picker.getImage(
        source: imageSource,
        maxWidth: 1500.0,
        maxHeight: 1500.0,
      );

      setState(() {
        imageFile = object;
      });
    } catch (e) {}
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: RaisedButton.icon(
            color: Colors.deepOrange,
            onPressed: () {
              if (imageFile == null) {
                showAlert('ไม่พบรูป', 'กรุณาถ่ายภาพ หรือ เลือกรูปภาพ ');
              } else {
                uploadPictureToStorage();
              }
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(
              'บันทึก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(10000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Car/car$i.jpg');
    StorageUploadTask storageUploadTask =
        storageReference.putFile(File(imageFile.path));

    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('$urlPicture');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    Firestore firestore = Firestore.instance;
    Map<String, dynamic> map = Map();
    map['Licenseplate'] = lisen;
    map['Offense'] = offense;
    map['Place'] = place;
    map['Sum'] = sum;
    map['PathImage'] = urlPicture;
    map['Date'] = time;
    map['Token'] = token;
    map['Password'] = password;

    await firestore
        .collection('Evidence')
        .document()
        .setData(map)
        .then((value) {
      print('Success');

      showAlertDialog(context);
      //MaterialPageRoute route = MaterialPageRoute(
      //  builder: (value) => Home2(),
      //);
      //Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    });
  }
}

class RoundedInputField extends StatelessWidget {
  final String initialValue;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.initialValue,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
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

class SlipInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const SlipInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.add_photo_alternate,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("ยืนยันการชำระเงินเสร็จสิ้น"),
    content: Text("กรุณารอสักครู่ ท่านจะได้รับรหัสเพื่อปลดล็อคในช่องข้อความ"),
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
