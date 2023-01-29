
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppSettingsProvider extends ChangeNotifier {

  int _bestSalonNumber = 1;
  int get bestSalonNumber => _bestSalonNumber;

  updateBestSalonNumber() async {
    await FirebaseFirestore.instance.collection("settings").limit(1).get().then((snapshot){
      _bestSalonNumber = snapshot.docs.first.data()['best'];
    });
    notifyListeners();
  }
}