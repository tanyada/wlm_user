import 'package:flutter/material.dart';

import 'confirm_screen.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(title: Text('ประวัติย้อนหลัง')),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      title: Text('หมายเลขทะเบียน'),
                      trailing: Text('6กฉ 1156 กทม'),
                    ),
                    ListTile(
                      title: Text('รายละเอียด'),
                      trailing: Text('Mazda 2'),
                    ),
                    ListTile(
                      title: Text('ข้อหาที่กระทำผิด'),
                      trailing: Text('จอดในที่ห้ามจอด'),
                    ),
                    ListTile(
                      title: Text('สถานที่'),
                      trailing: Text('มหาวิทยาลัยขอนแก่น'),
                    ),
                    ListTile(
                      title: Text('ค่าปรับ'),
                      trailing: Text('400'),
                    ),
                    ListTile(
                      title: Text('ค่ามัดจำอุปกรณ์'),
                      trailing: Text('1,000'),
                    ),
                    ListTile(
                      title: Text('รวมที่ต้องชำระ'),
                      trailing: Text('1,400'),
                    ),
                    ListTile(
                      title: Text('สถานะ'),
                      trailing: Text('ชำระเงินเรียบร้อย'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
