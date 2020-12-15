import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/Screens/homeAdmin/message_screen.dart';
import 'package:loginsss/Screens/homeAdmin/lock_screen.dart';
import 'package:loginsss/Screens/homeAdmin/setting_screen.dart';

class HomeScreenAdmin extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<HomeScreenAdmin> {
  int _selectedTabIndex = 0;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    initFirebaseMessaging();
    super.initState();
  }

  List _pages = [
    MessageScreen(),
    LockScreen(),
    SettingScreen(),
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
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
              icon: Icon(Icons.lock), title: Text("รายการ")),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), title: Text("ตั้งค่า")),
        ],
      ),
    );
  }

  void initFirebaseMessaging() {
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );

    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("TokenHome : $token");
    });
  }
}
