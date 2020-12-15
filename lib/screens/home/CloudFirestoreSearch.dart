import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loginsss/screens/home/pay_screen.dart';
import 'package:loginsss/constants.dart';

class CloudFirestoreSearch extends StatefulWidget {
  String id;

  CloudFirestoreSearch(this.id);
  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState(id);
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = '';
  String id;

  _CloudFirestoreSearchState(this.id);

  @override
  void initState() {
    super.initState();
    name = id;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kPrimaryLightColor,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height * 0.07,
            ),
            Text(
              "ป้อนรหัสอุปกรณ์",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: kPrimaryColor),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              child: RoundedInputField(
                hintText: "กรุณาป้อนรหัสอุปกรณ์",
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            Container(
              height: 250,
              width: 340,
              child: StreamBuilder<QuerySnapshot>(
                stream: (name != "" && name != null)
                    ? Firestore.instance
                        .collection('LockData')
                        .where("searchKeywords", arrayContains: name)
                        .where('status', isEqualTo: 'not paid')
                        .snapshots()
                    : Firestore.instance.collection("Lockdata").snapshots(),
                builder: (context, snapshot) {
                  return (snapshot.connectionState == ConnectionState.waiting)
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                                snapshot.data.documents[index];
                            return Card(
                              elevation: 2.0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              child: Container(
                                child: InkWell(
                                  onTap: () {},
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading:
                                            Image.network(data["PathImage"]),
                                        title: Text('ทะเบียน : ' +
                                            data["Licenseplate"]),
                                        subtitle:
                                            Text('สถานที่ : ' + data["Place"]),
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PayScreen(
                                                          data["Licenseplate"],
                                                          data["Deposit"],
                                                          data["Detail"],
                                                          data["Offense"],
                                                          data["Place"],
                                                          data["Fine"],
                                                          data['sum'],
                                                          data['Password'])));
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                },
              ),
            ),
          ],
        ),
      ),
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
          prefixIcon: Icon(Icons.search),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({
    Key key,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}
