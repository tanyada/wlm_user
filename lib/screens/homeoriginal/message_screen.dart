import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  List<Widget> containers = [
    Container(
      color: Colors.blueGrey[100],
      child: Center(
        child: Text('คุณสามารถตรวจสอบการแจ้งเตือนได้ที่หน้านี้'),
      ),
    ),
    Container(
      color: Colors.blueGrey[100],
      child: Center(
        child: Text('คุณสามารถรับรหัสผ่านเพื่อปลดล็อคได้ที่หน้านี้'),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('ข้อความ'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              text: 'การแจ้งเตือน',
            ),
            Tab(
              text: 'กล่องข้อความ',
            )
          ]),
        ),
        body: TabBarView(
          children: containers,
        ),
      ),
    );
  }
}
