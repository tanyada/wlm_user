import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/authenticate/constants.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenStage createState() => _MessageScreenStage();
}

class _MessageScreenStage extends State<MessageScreen> {
  String token;

  Future<Null> gettoken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String tokenn = await firebaseMessaging.getToken();
    print(tokenn);
    token = tokenn;
  }

  @override
  void initState() {
    super.initState();
    gettoken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: kPrimaryLightColor,
        appBar: AppBar(
          title: Text('ข้อความ'),
        ),
        body: Center(
            child: Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection("Message")
                .where('Token', isEqualTo: token)
                .orderBy('Date', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              return (snapshot.connectionState == ConnectionState.waiting)
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.documents[index];
                        return Card(
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          child: Container(
                            child: InkWell(
                              onTap: () {},
                              child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading:
                                        Image.asset('lib/images/unlock.png'),
                                    title: Text(
                                        'ทะเบียน : ' + data["Licenseplate"]),
                                    subtitle:
                                        Text('สถานที่ : ' + data["Place"]),
                                    onTap: () {
                                      showAlertDialog(context,
                                          data["Licenseplate"], data['Status']);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        )));
  }

  showAlertDialog(BuildContext context, licennn, message) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('รหัสผ่านทะเบียน :' + licennn),
      content: Text('' + message),
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

class RegisterButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RegisterButton({
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
