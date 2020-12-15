import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/Screens/Login/login_screen.dart';
import 'package:loginsss/models/user.dart';
import 'package:loginsss/services/database.dart';
import 'package:loginsss/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:loginsss/services/auth.dart';

class SettingScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  Stream<QuerySnapshot> getUsersStreamSnapshot(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(title: Text('ตั้งค่า')),
        body: StreamBuilder(
          stream: DatabaseService(uid: user.uid).usernamedata,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            return Container(
              color: Colors.blueGrey[100],
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            title: Text(snapshot.data.name),
                            trailing: Icon(Icons.edit),
                            onTap: () {},
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            title: Text('เปลี่ยนรหัสผ่าน'),
                            trailing: Icon(Icons.edit),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.help_outline,
                              color: Colors.grey,
                            ),
                            title: Text('คู่มือการใช้งาน'),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {},
                          ),
                          _buildDivider(),
                          ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: Colors.grey,
                            ),
                            title: Text('เวอร์ชั่นของแอปพลิเคชัน'),
                            trailing: Text('1.0.0'),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.power_settings_new,
                              color: Colors.grey,
                            ),
                            title: Text('ออกจากระบบ'),
                            onTap: () async {
                              await _auth.signOut();
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }

  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}
