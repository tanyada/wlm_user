import 'package:loginsss/models/car.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:loginsss/screens/home/cartile.dart';

class Carlist extends StatefulWidget {
  @override
  _CarlistState createState() => _CarlistState();
}

class _CarlistState extends State<Carlist> {
  @override
  Widget build(BuildContext context) {

    final cars = Provider.of<List<Car>>(context);
    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        //return CarTile(car: cars[index]);
    });
  }
} 