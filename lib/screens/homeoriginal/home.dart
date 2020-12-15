import 'package:flutter/material.dart';
//import 'package:loginsss/screens/home/setting_form.dart';
import 'package:loginsss/services/auth.dart';
//import 'package:loginsss/screens/home/carlist.dart';
import 'package:loginsss/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:loginsss/models/car.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    
    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          //child: SettingsForm(),
        );
      });
    }

    return StreamProvider<List<Car>>.value(
      value: DatabaseService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Wheellock'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
         //body: Carlist(),
      ),
    );
  }
}