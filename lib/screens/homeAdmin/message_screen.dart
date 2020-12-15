import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/authenticate/constants.dart';
import 'package:loginsss/screens/homeAdmin/mes_screen.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenStage createState() => _MessageScreenStage();
}

class _MessageScreenStage extends State<MessageScreen> {
  Future<Null> gettoken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    print('Token : $token');
  }

  @override
  void initState() {
    super.initState();
    gettoken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
        title: Text('ข้อความ'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection("Evidence")
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
                      margin: const EdgeInsets.all(8.0),
                      child: Container(
                        child: InkWell(
                          onTap: () {},
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Image.network(
                                  data["PathImage"],
                                  fit: BoxFit.contain,
                                ),
                                title:
                                    Text('ทะเบียน : ' + data["Licenseplate"]),
                                subtitle: Text('สถานที่ : ' + data["Place"]),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return MesScreen(
                                            data["Licenseplate"],
                                            data["Place"],
                                            data["Offense"],
                                            data["Sum"],
                                            data["Date"],
                                            data["PathImage"],
                                            data["Password"]);
                                      },
                                    ),
                                  );
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
    );
  }
}
