// ignore_for_file: file_names, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  AuthCredential ? credential;

  Future LogOut() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}