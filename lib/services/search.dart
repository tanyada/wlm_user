import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _formKey = GlobalKey<FormState>();

class SearchService {
  searchByNumber(String searchfield){
    return Firestore.instance
    .collection('wheellock')
    .where('licenseplate')
    .getDocuments();
  }
}