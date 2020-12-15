import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loginsss/models/car.dart';
import 'package:loginsss/models/lockdata.dart';
import 'package:loginsss/models/role.dart';
//import 'package:loginsss/screens/home/Carlist.dart';
import 'package:loginsss/models/user.dart';
import 'package:loginsss/models/lockdata.dart';
import 'package:loginsss/services/search.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference wheellockCollection =
      Firestore.instance.collection('LockData');
  final CollectionReference userdata =
      Firestore.instance.collection('userdata');

  Future<void> updateUserData(
      String licenseplate, String brand, String color) async {
    return await userdata.document(uid).setData({
      'Licenseplate': licenseplate
    });
  }

  // brew list from snapshot
  List<Car> _carlistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.data);
      return Car(
          licenseplate: doc.data['licenseplate'] ?? '',
          brand: doc.data['brand'] ?? 0,
          color: doc.data['color'] ?? '0');
    }).toList();
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        licenseplate: snapshot.data['licenseplate'],
        color: snapshot.data['color'],
        brand: snapshot.data['brand']);
  }

// get brews stream
  Stream<List<Car>> get brews {
    return wheellockCollection.snapshots().map(_carlistFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return wheellockCollection
        .document(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Lockdata _lockdataFromsnapshot(DocumentSnapshot snapshot) {
    return Lockdata(
      name: snapshot.data['name'],
    );
  }

  Stream<Lockdata> get usernamedata {
    return userdata.document(uid).snapshots().map(_lockdataFromsnapshot);
  }

  Role _roleFromsnapshot(DocumentSnapshot snapshot) {
    return Role(
      role: snapshot.data['role'],
    );
  }

  Stream<Role> get getrole {
    return userdata.document(uid).snapshots().map(_roleFromsnapshot);
  }
}
