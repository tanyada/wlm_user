import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsss/screens/authenticate/constants.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'confirm_screen.dart';

PickedFile imageFile;
final ImagePicker picker = ImagePicker();

class PayScreenADMIN extends StatelessWidget {
  String licenplace, detail, offense, place, password;
  int fine, deposit, sum;
  double lat, lng;
  CameraPosition position;
  BitmapDescriptor customIcon;

  PayScreenADMIN(this.licenplace, this.deposit, this.detail, this.offense,
      this.place, this.fine, this.sum, this.password, this.lat, this.lng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(title: Text('ปลดล็อคอุปกรณ์')),
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
                      trailing: Text(this.licenplace),
                    ),
                    ListTile(
                      title: Text('รายละเอียด'),
                      trailing: Text(this.detail),
                    ),
                    ListTile(
                      title: Text('ข้อหาที่กระทำผิด'),
                      trailing: Text(this.offense),
                    ),
                    ListTile(
                      title: Text('สถานที่'),
                      trailing: Text(this.place),
                    ),
                    ListTile(
                      title: Text('ค่าปรับ'),
                      trailing: Text(this.fine.toString() + '   บาท'),
                    ),
                    ListTile(
                      title: Text('ค่ามัดจำอุปกรณ์'),
                      trailing: Text(this.deposit.toString() + '   บาท'),
                    ),
                    ListTile(
                      title: Text('รวมที่ต้องชำระ'),
                      trailing: Text(this.sum.toString() + '   บาท'),
                    ),
                  ],
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: ListTile(
                        title: Text(
                          'แผนที่การล็อครถ',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    showMap(),
                    ButtonBar(
                      children: <Widget>[],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> myMarker() {
    return <Marker>[car()].toSet();
  }

  Marker car() {
    LatLng latLng = LatLng(lat, lng);
    return Marker(
        markerId: MarkerId('Car'),
        position: latLng,
        infoWindow: InfoWindow(
          title: this.licenplace,
          snippet: this.offense,
        ));
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    //location = latLng as String;
    position = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    //creatMarker(context);
    return Container(
      height: 300.0,
      child: GoogleMap(
        myLocationEnabled: true,
        markers: myMarker(),
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }
}

void _editbuttomform(context, String lisence, String detail, String offense,
    String place, int sum) {
  PickedFile imageFile;
  final ImagePicker picker = ImagePicker();
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  //color: Colors.blue[300],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: imageFile == null
                      ? Image.asset('lib/images/photo.png')
                      : Image.file(File(imageFile.path)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'หมายเลขทะเบียนรถ : $lisence',
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('รายละเอียด : $detail',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('ข้อหาที่กระทำผิด : $offense',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('สถานที่ : $place',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('รวมที่ต่องจ่าย : $sum',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_photo_alternate,
                    size: 36.0,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    chooseImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> chooseImage(ImageSource imageSource) async {
  try {
    PickedFile object = await picker.getImage(
      source: imageSource,
      maxWidth: 800.0,
      maxHeight: 800.0,
    );
    imageFile = object;
  } catch (e) {}
}
