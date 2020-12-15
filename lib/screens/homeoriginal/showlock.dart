import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/src/widgets/text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loginsss/screens/homeoriginal/addlock.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Showlock extends StatefulWidget {
  @override
  _ShowlockState createState() => _ShowlockState();
}

class _ShowlockState extends State<Showlock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('การล็อค'),
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("LockData").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Column(
                children: <Widget>[
                  CircularProgressIndicator(),
                  Text("Loading . . . "),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 3.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: const EdgeInsets.all(8.0),
                    child: Container(
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: Image.network(snapshot
                                  .data.documents[index].data["PathImage"]),
                              title: Text(snapshot
                                  .data.documents[index].data["Licenseplate"]),
                              subtitle: Text(
                                  snapshot.data.documents[index].data["Place"]),
                              onTap: () {
                                _editbuttomform(
                                  context,
                                  snapshot.data.documents[index]
                                      .data["Licenseplate"],
                                  snapshot.data.documents[index].data["Brand"],
                                  snapshot
                                      .data.documents[index].data["Deposit"],
                                  snapshot.data.documents[index].data["Fine"],
                                  snapshot.data.documents[index].data["Gen"],
                                  snapshot
                                      .data.documents[index].data["Offense"],
                                  snapshot.data.documents[index].data["Lat"],
                                  snapshot.data.documents[index].data["Lng"],
                                  snapshot.data.documents[index].data["Place"],
                                  snapshot.data.documents[index].data["Sum"],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

void _editbuttomform(
    context,
    String lisence,
    String brand,
    String deposit,
    String fine,
    String gen,
    String offense,
    double lat,
    double lng,
    String place,
    String sum) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('หมายเลขทะเบียนรถ : $lisence'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('รุ่นรถ : $brand'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('ค่ามัดจำอุปกรณ์ : $deposit'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('ค่าปรับ : $fine'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('ยี่ห้อรถ : $gen'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('ข้อหาที่กระทำผิด : $offense'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('สถานที่ : $place'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('รวมที่ต่องจ่าย : $sum'),
                  ],
                ),
                QrImage(
                  data: PromptPay.generateQRData("0910620202", amount: 400.00),
                  size: 200,
                  version: QrVersions.auto,
                  gapless: false,
                  embeddedImage: AssetImage('assets/images/sss.png'),
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(50, 50),
                  ),
                ),
              ],
            ),
          ),
        );
      });
}
