import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
//import 'package:loginsss/screens/home/home2.dart';
import 'package:promptpay/promptpay.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Addlock extends StatefulWidget {
  @override
  _AddlockState createState() => _AddlockState();
}

class _AddlockState extends State<Addlock> {
//field
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  String licenseplate, brand, gen, offense, place, date,sum, fine, deposit, urlPicture, location;
  double lat, lng, lat2, lng2;
  //LatLng location;
  CameraPosition position;
  BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
    //findLatLng();
    markers = Set.from([]);
  }

//method

  Widget showProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocationData();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('Lat = $lat Lng = $lng');
    showMap();
  }

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  Set<Marker> markers;

  creatMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    //location = latLng as String;
    markers.add(Marker(markerId: MarkerId('nowLocation'), position: latLng));
    position = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    //creatMarker(context);
    return Container(
      height: 300.0,
      child: GoogleMap(
        myLocationEnabled: true,
        markers: markers,
        onTap: (pos) {
          print(pos);
          Marker m = Marker(
            markerId: MarkerId('nowLocation'),
            icon: customIcon,
            position: pos,
          );
          setState(() {
            markers.add(m);
            lat = pos.latitude;
            lng = pos.longitude;
          });
          print('latitude = $lat longtitude = $lng');
        },
        initialCameraPosition: position,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
      ),
    );
  }

  Widget locationButton() {
    return Column(children: <Widget>[
      Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: FlatButton(
            color: Colors.deepOrange,
            onPressed: () {
              findLatLng();
            },
            child: Text(
              "Google Map",
              style: TextStyle(color: Colors.white),
            ),
          ))
    ]);
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          child: RaisedButton.icon(
            color: Colors.deepOrange,
            onPressed: () {
              if (_imageFile == null) {
                showAlert('ไม่พบรูป', 'กรุณาถ่ายภาพ หรือ เลือกรูปภาพ ');
              } else if (licenseplate == null ||
                  licenseplate.isEmpty ||
                  brand == null ||
                  brand.isEmpty ||
                  gen == null ||
                  gen.isEmpty ||
                  offense == null ||
                  offense.isEmpty ||
                  date == null ||
                  date.isEmpty ||
                  fine == null ||
                  deposit == null ||
                  sum == null ) {
                showAlert('คุณกรอกข้อมูลไม่ครบถ้วน',
                    'กรุณากรอกข้อมูลการล็อคให้ครบทุกช่อง');
              } else {
                uploadPictureToStorage();
              }
            },
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            label: Text(
              'บันทึก',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> uploadPictureToStorage() async {
    Random random = Random();
    int i = random.nextInt(10000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    StorageReference storageReference =
        firebaseStorage.ref().child('Car/car$i.jpg');
    StorageUploadTask storageUploadTask =
        storageReference.putFile(File(_imageFile.path));

    urlPicture =
        await (await storageUploadTask.onComplete).ref.getDownloadURL();
    print('$urlPicture');
    insertValueToFireStore();
  }

  Future<void> insertValueToFireStore() async {
    Firestore firestore = Firestore.instance;
    Map<String, dynamic> map = Map();
    map['Licenseplate'] = licenseplate;
    map['Brand'] = brand;
    map['Gen'] = gen;
    map['Offense'] = offense;
    map['Place'] = place;
    map['Date'] = licenseplate;
    map['Fine'] = licenseplate;
    map['Deposit'] = deposit;
    map['Sum'] = sum;
    map['PathImage'] = urlPicture;
    map['Lat'] = lat;
    map['Lng'] = lng;

    await firestore
        .collection('LockData')
        .document()
        .setData(map)
        .then((value) {
      print('Success');
      //MaterialPageRoute route = MaterialPageRoute(
      //  builder: (value) => Home2(),
      //);
      //Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    });
  }

  Future<void> showAlert(String title, String message) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
  }

  Widget lisencePlateForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          licenseplate = value.trim();
        },
        decoration: InputDecoration(
          helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'หมายเลขทะเบียนรถ',
        ),
      ),
    );
  }

  Widget brandForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          brand = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'ยี่ห้อรถยนต์',
        ),
      ),
    );
  }

  Widget genForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          gen = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'รุ่นรถยนต์',
        ),
      ),
    );
  }

  Widget offenseForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          offense = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'ข้อหาที่กระทำผิด',
        ),
      ),
    );
  }

  Widget placeForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          place = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'สถานที่',
        ),
      ),
    );
  }

  Widget dateForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          date = value.trim();
        },
        decoration: InputDecoration(
          helperText: '*ตัวอย่าง ว/ด/ป เวลา',
          labelText: 'เวลา - วันที่',
        ),
      ),
    );
  }

  Widget fineForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          fine = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'ค่าปรับ',
        ),
      ),
    );
  }

  Widget depositForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          deposit = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'ค่ามัดจำอุปกรณ์',
        ),
      ),
    );
  }

  Widget sumForm() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        onChanged: (value) {
          sum = value.trim();
        },
        decoration: InputDecoration(
          //helperText: '*ตัวอย่าง กข 1234 ขอนแก่น',
          labelText: 'รวมทั้งหมด',
        ),
      ),
    );
  }

  Widget cameraButton() {
    return IconButton(
      icon: Icon(
        Icons.add_a_photo,
        size: 36.0,
        color: Colors.blue,
      ),
      onPressed: () {
        chooseImage(ImageSource.camera);
      },
    );
  }

  Future<void> chooseImage(ImageSource imageSource) async {
    try {
      PickedFile object = await _picker.getImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );

      setState(() {
        _imageFile = object;
      });
    } catch (e) {}
  }

  Widget galleryButton() {
    return IconButton(
      icon: Icon(
        Icons.add_photo_alternate,
        size: 36.0,
        color: Colors.green,
      ),
      onPressed: () {
        chooseImage(ImageSource.gallery);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        cameraButton(),
        galleryButton(),
      ],
    );
  }

  Widget showImage() {
    return Container(
      padding: EdgeInsets.all(20.0),
      //color: Colors.blue[300],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: _imageFile == null
          ? Image.asset('lib/images/photo.png')
          : Image.file(File(_imageFile.path)),
    );
  }

  Widget showContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          showImage(),
          showButton(),
          lisencePlateForm(),
          brandForm(),
          genForm(),
          offenseForm(),
          placeForm(),
          dateForm(),
          fineForm(),
          depositForm(),
          sumForm(),
          lat == null ? Text('กรุณามาร์คจุดบนแผนที่') : showMap(),
          locationButton(),
          uploadButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          showContent(),
        ],
      ),
    );
  }
}
