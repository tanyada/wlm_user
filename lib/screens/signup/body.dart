import 'package:flutter/material.dart';
import 'package:loginsss/screens/authenticate/body.dart';
import 'package:loginsss/screens/authenticate/login_screen.dart';
import 'package:loginsss/screens/signup/background.dart';
import 'package:loginsss/services/auth.dart';

import 'package:loginsss/screens/authenticate/constants.dart';

class Body extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Body> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Column(
        key: _formKey,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "SIGNUP",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
                color: kPrimaryColor),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
          RoundedInputField(
            hintText: "Your Email",
            onChanged: (val) => email = val.trim(),
          ),
          RoundedPasswordField(
            onChanged: (val) => password = val.trim(),
          ),
          RoundedButton(
            text: "SIGNUP",
            press: () async {
              dynamic result =
                  await _auth.registerWithEmailAndPassword(email, password);
              if (result == null) {
                error = 'อีเมลล์ หรือ พาสเวิร์ด ผิด กรุณาลองใหม่อีกครั้ง';
              }
            },
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text(
            error,
            style: TextStyle(color: Colors.red, fontSize: 14.0),
          ),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
