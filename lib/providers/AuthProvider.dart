// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AuthProvider extends ChangeNotifier {

  AuthCredential ? credential;

  Future LogOut() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }


  static bool? _isConnect;
  static bool? get isConnect => _isConnect;

  late StreamSubscription<InternetConnectionStatus> listener;

  checkCnx(){
    listener = InternetConnectionChecker().onStatusChange.listen((InternetConnectionStatus status) {
      switch (status) {
        case InternetConnectionStatus.connected:
          _isConnect= true;
          notifyListeners();
          break;
        case InternetConnectionStatus.disconnected:
          _isConnect= false;
          notifyListeners();
          break;
      }
    });
  }
}