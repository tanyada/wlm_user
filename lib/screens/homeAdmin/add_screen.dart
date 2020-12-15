import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../../constants.dart';
import 'home_screen.dart';

class AddScreen extends StatefulWidget {
  @override
  _AddScreen createState() => _AddScreen();
}

class _AddScreen extends State<AddScreen> {
  String lockernumber, licen, detail, offense, place, password, urlPicture;
  PickedFile _imageFile;
  final ImagePicker _picker = ImagePicker();
  double lat, lng, lat2, lng2;
  int fine, deposit, sum;
  CameraPosition position;
  BitmapDescriptor customIcon;
  DateTime time = new DateTime.now();

  @override
  void initState() {
    super.initState();
    findLatLng();
    markers = Set.from([]);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('เพิ่มรายการรถ')),
      body: Container(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: size.height * 0.10,
            ),
            showImage(),
            showButton(),
            SizedBox(
              height: size.height * 0.02,
            ),
            RoundedInputField(
              hintText: "หมายเลขแม่กุญแจ",
              onChanged: (value) {
                lockernumber = value.trim();
              },
            ),
            RoundedInputField(
              hintText: "หมายเลขทะเบียน",
              onChanged: (value) {
                licen = value.trim();
              },
            ),
            RoundedInputField(
              hintText: "รายละเอียด (ยี่ห้อ,รุ่น)",
              onChanged: (value) {
                detail = value.trim();
              },
            ),
            RoundedInputField(
              hintText: "ข้อหาที่กระทำผิด",
              onChanged: (value) {
                offense = value.trim();
              },
            ),
            SlipInputField(
              hintText: "สถานที่",
              onChanged: (value) {
                place = value.trim();
              },
            ),
            RoundedInputField(
              hintText: "ค่าปรับ",
              onChanged: (value) {
                fine = int.parse(value);
              },
            ),
            RoundedInputField(
              hintText: "ค่ามัดจำอุปกรณ์",
              onChanged: (value) {
                deposit = int.parse(value);
                sum = fine + deposit;
                print(sum);
              },
            ),
            RoundedInputField(
              hintText: "รหัสผ่าน 4 หลัก",
              onChanged: (value) {
                password = value.trim();
              },
            ),
            showMap(),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SaveButton(
                  text: 'บันทึก',
                  press: () {
                    if (_imageFile == null) {
                      showAlert('ไม่พบรูป', 'กรุณาถ่ายภาพ หรือ เลือกรูปภาพ ');
                    } else if (lockernumber == null ||
                        lockernumber.isEmpty ||
                        licen == null ||
                        licen.isEmpty ||
                        detail == null ||
                        detail.isEmpty ||
                        offense == null ||
                        offense.isEmpty ||
                        place == null ||
                        place.isEmpty ||
                        fine == null ||
                        deposit == null ||
                        password == null ||
                        password.isEmpty ||
                        time == null) {
                      showAlert('คุณกรอกข้อมูลไม่ครบถ้วน',
                          'กรุณากรอกข้อมูลการล็อคให้ครบทุกช่อง');
                    } else {
                      uploadPictureToStorage();
                    }
                  },
                ),
                SizedBox(
                  width: size.width * 0.05,
                ),
                CancleButton(
                  text: "ยกเลิก",
                  press: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return HomeScreenAdmin();
                        },
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  Widget uploadButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 1),
          width: MediaQuery.of(context).size.width * 0.25,
          child: RaisedButton.icon(
            color: Colors.deepOrange,
            onPressed: () {
              if (_imageFile == null) {
                showAlert('ไม่พบรูป', 'กรุณาถ่ายภาพ หรือ เลือกรูปภาพ ');
              } else if (lockernumber == null ||
                  lockernumber.isEmpty ||
                  licen == null ||
                  licen.isEmpty ||
                  detail == null ||
                  detail.isEmpty ||
                  offense == null ||
                  offense.isEmpty ||
                  place == null ||
                  place.isEmpty ||
                  fine == null ||
                  deposit == null ||
                  password == null ||
                  password.isEmpty ||
                  time == null) {
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

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  Future<void> insertValueToFireStore() async {
    Firestore firestore = Firestore.instance;
    Map<String, dynamic> map = Map();
    map['Lockernumber'] = lockernumber;
    map['Licenseplate'] = licen;
    map['Detail'] = detail;
    map['Offense'] = offense;
    map['Place'] = place;
    map['Fine'] = fine;
    map['Deposit'] = deposit;
    map['Time'] = time;
    map['PathImage'] = urlPicture;
    map['Password'] = password;
    map['Lat'] = lat;
    map['Lng'] = lng;
    map['sum'] = sum;
    map['searchKeywords'] = setSearchParam(licen);
    map['status'] = 'not paid';

    await firestore
        .collection('LockData')
        .document()
        .setData(map)
        .then((value) {
      print('Success');
      showAlertDialog(context);
      //MaterialPageRoute route = MaterialPageRoute(
      //  builder: (value) => Home2(),
      //);
      //Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeScreenAdmin()));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("บักทึกเสร็จสิ้น"),
      content: Text("กลับไปหน้าหลัก"),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                  HomeScreenAdmin();
                },
                child: Text('OK'),
              ),
            ],
          );
        });
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

  Future<LocationData> findLocationData() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
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
      padding: EdgeInsets.all(10.0),
      //color: Colors.blue[300],
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: _imageFile == null
          ? Image.asset('lib/images/photo.png')
          : Image.file(File(_imageFile.path)),
    );
  }
}

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged onChanged;
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
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      width: size.width * 0.9,
      decoration: BoxDecoration(
        color: kPrimaryLightColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: child,
    );
  }
}

class SaveButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const SaveButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.green,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class CancleButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const CancleButton({
    Key key,
    this.text,
    this.press,
    this.color = Colors.red,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1),
      width: size.width * 0.25,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          color: color,
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class SlipInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const SlipInputField({
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
          suffixIcon: IconButton(
              icon: Icon(Icons.location_on),
              color: kPrimaryColor,
              onPressed: () {}),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
