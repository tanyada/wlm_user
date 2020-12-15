import 'package:flutter/material.dart';

import 'detail_screen.dart';
//import 'package:flutter_list_view_builder/history_screen.datr';

class HistoryScreen extends StatelessWidget {
  final List<String> listof = ["test", "test2 "];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(title: Text('ประวัติย้อนหลัง')),
      body: Container(
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
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return DetailScreen();
                        },
                      ),
                    );
                  },
                  title: Text('6กฉ 1156 กทม'),
                  subtitle: Text('มหาวิทยาลัยขอนแก่น'),
                  leading: Icon(
                    Icons.directions_car,
                    color: Colors.grey,
                  ),
                  //leading: CircleAvatar(
                  //backgroundColor: Colors.green,
                  //),
                  trailing: Icon(Icons.keyboard_arrow_right),
                ),
              ),
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
