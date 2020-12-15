import 'package:flutter/material.dart';
//import 'package:loginsss/screens/home/search.dart';
//import 'package:loginsss/screens/home/showlock.dart';
//import 'package:loginsss/screens/home/addlock.dart';
//import 'package:loginsss/screens/home/search3.dart';
//import 'package:loginsss/screens/home/setting_form.dart';
import 'package:loginsss/screens/home/message_screen.dart';
import 'package:loginsss/screens/home/unlock_screen.dart';
import 'package:loginsss/screens/home/setting_screen.dart';
import 'package:loginsss/services/auth.dart';
//import 'package:loginsss/screens/home/carlist.dart';
import 'package:loginsss/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:loginsss/models/car.dart';
//import 'package:loginsss/screens/home/qrcode.dart';


class Home2 extends StatefulWidget {
  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  
  final AuthService _auth = AuthService();
  int _selectedTabIndex = 0;
  List _pages = [
    MessageScreen(),
    //PayScreen(),
    //Qrcode(),
  ];
  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  //    appBar: AppBar(
  //      title: Text("Puriinz"), 
  //     backgroundColor: Colors.lightBlue[900],
  //      actions: <Widget>[
  //          FlatButton.icon(
  //            icon: Icon(Icons.person),
  //            label: Text('logout'),
  //            onPressed: () async {
  //              await _auth.signOut();
  //            },
  //          ),
  //        ],
  //      ),
      body: Center(child: _pages[_selectedTabIndex]),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedTabIndex,
      onTap: _changeIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.mail), title: Text("ข้อความ"),),
        BottomNavigationBarItem(
          icon: Icon(Icons.lock_open), title: Text("ปลดล็อค")),
          BottomNavigationBarItem(
          icon: Icon(Icons.settings), title: Text("ตั้งค่า")),
        ],
      ),
    );
  }
}