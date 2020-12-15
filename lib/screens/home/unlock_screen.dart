import 'package:flutter/material.dart';
import 'package:loginsss/screens/home/CloudFirestoreSearch.dart';
import '../../constants.dart';
import 'history_screen.dart';

class UnlockScreen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<UnlockScreen> {
  @override
  String id;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text('ปลดล็อคอุปกรณ์'),
          actions: <Widget>[historyButton(context)]),
      body: CloudFirestoreSearch(id),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          suffixIcon: Icon(
            Icons.crop_free,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

Widget historyButton(BuildContext context) {
  return IconButton(
      icon: Icon(Icons.history),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HistoryScreen();
            },
          ),
        );
      });
}
