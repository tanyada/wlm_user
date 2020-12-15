import 'package:loginsss/models/car.dart';
import 'package:flutter/material.dart';

class CarTile extends StatelessWidget {

  final Car car;
  CarTile({ this.car });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 40.0, 0.0),
        child: ListTile(
          title: Text(car.licenseplate),
          subtitle: Text('Brand ${car.brand} Color ${car.color}'),
          
        ),
      ),
    );
  }
} 