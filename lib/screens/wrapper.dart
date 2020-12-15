import 'package:loginsss/screens/authenticate/login_screen.dart';
import 'package:loginsss/screens/home/home_screen.dart';
import 'package:loginsss/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loginsss/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Wrapper extends StatelessWidget {
  final AuthService _auth = AuthService();

  Stream<QuerySnapshot> getUsersStreamSnapshot(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return LoginScreen();
    } else {
      return HomeScreen();
    }
  }
}
