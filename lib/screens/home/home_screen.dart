import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/home/message_screen.dart';
import 'package:loginsss/screens/home/unlock_screen.dart';
import 'package:loginsss/screens/home/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreen> {
  int _selectedTabIndex = 0;

  List _pages = [
    MessageScreen(),
    UnlockScreen(),
    SettingScreen(),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  Future<Null> gettoken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    print(token);
  }

  @override
  void initState() {
    super.initState();
    gettoken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.mail), title: Text("ข้อความ")),
          BottomNavigationBarItem(
              icon: Icon(Icons.lock_open), title: Text("ปลดล็อค")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("ตั้งค่า")),
        ],
      ),
    );
  }
}
