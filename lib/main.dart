import 'package:flutter/material.dart';
import 'package:loginsss/screens/homeAdmin/home_screen.dart';
import 'constants.dart';
import 'Screens/home/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wheel Lock Management System',
      theme: ThemeData(
          primaryColor: kPrimaryColor, scaffoldBackgroundColor: Colors.white),
      home: HomeScreenAdmin(),
    );
  }
}
