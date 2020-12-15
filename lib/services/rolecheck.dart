import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsss/models/user.dart';
import 'package:loginsss/screens/home/home_screen.dart';
import 'package:loginsss/screens/homeAdmin/home_screen.dart';
import 'package:provider/provider.dart';

class Rolecheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        // ignore: deprecated_member_use
        stream: Firestore.instance
            .collection('wheellock')
            .document(user.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data['role'] == 'admin') {
            return HomeScreen();
          } else if (snapshot.data['role'] == 'user') {
            return HomeScreenAdmin();
          }
          return LinearProgressIndicator();
        },
      ),
    );
  }
}
