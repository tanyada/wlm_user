import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/authenticate/constants.dart';
import 'package:loginsss/screens/home/pay_screen.dart';
import 'package:loginsss/screens/homeAdmin/pay_screen.dart';
import 'package:loginsss/screens/homeoriginal/addlock.dart';

import 'add_screen.dart';
import 'detail_screen.dart';

class LockScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<LockScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(
          title: Text('รายการรถที่ล็อค'),
          actions: <Widget>[historyButton(context)]),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('LockData').snapshots(),
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
                                leading: Image.network(data["PathImage"]),
                                title:
                                    Text('ทะเบียน : ' + data["Licenseplate"]),
                                subtitle: Text('สถานที่ : ' + data["Place"]),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => PayScreenADMIN(
                                            data["Licenseplate"],
                                            data["Deposit"],
                                            data["Detail"],
                                            data["Offense"],
                                            data["Place"],
                                            data["Fine"],
                                            data['sum'],
                                            data['Password'],
                                            data['Lat'],
                                            data['Lng'],
                                          )));
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

Widget historyButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return AddScreen();
            },
          ),
        );
      });
}
