import 'package:flutter/material.dart';
import 'package:loginsss/Screens/Login/login_screen.dart';
import 'package:loginsss/screens/authenticate/constants.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      appBar: AppBar(title: Text('ตั้งค่า')),
      body: Container(
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
                      title: Text('Tanyada Leepongkul'),
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
                      title: Text('เข้าสู่ระบบ'),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return LoginScreen();
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
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
