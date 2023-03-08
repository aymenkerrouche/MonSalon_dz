// ignore_for_file: file_names, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {

  AuthCredential ? credentialAuth;
  UserCredential ? googleUserCredential;
  UserCredential ? facebookUserCredential;

  Map? _profile;
  Map? get profile => _profile;

  FirebaseAuthException? error;

  bool sendSMS = false;


  static bool? _isConnect;
  static bool? get isConnect => _isConnect;

  late StreamSubscription<InternetConnectionStatus> listener;

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool done = false;

  Future<void> getInfos(context) async {
    phoneController.clear();
    nameController.clear();
    emailController.clear();
    done = false;
    try{
      await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((snapshot){
        phoneController.text = snapshot.data()?['phone'] ?? '';
        emailController.text = snapshot.data()?['email'] ?? '';
        nameController.text = snapshot.data()?['name'] ?? '';
      })
      .whenComplete(() {
        if(FirebaseAuth.instance.currentUser!.email != null){
          emailController.text = FirebaseAuth.instance.currentUser!.email! ;
        }
        if(FirebaseAuth.instance.currentUser!.providerData.first.email != null){
          emailController.text = FirebaseAuth.instance.currentUser!.providerData.first.email!;
        }
        if(FirebaseAuth.instance.currentUser?.displayName != null){nameController.text = FirebaseAuth.instance.currentUser!.displayName!;}
        if(FirebaseAuth.instance.currentUser?.phoneNumber != null){phoneController.text = FirebaseAuth.instance.currentUser!.phoneNumber!;}
        Timer(const Duration(milliseconds: 700),(){done =true;notifyListeners();});
      });
    }
    catch(e){
      print(e);
    }
    Timer(const Duration(seconds: 5),(){
      if(done == false) {
        done = true;
        GFToast.showToast(
          'Internet Connection Problem', context, toastDuration: 3,
          backgroundColor: Colors.red.shade600,
          textStyle: const TextStyle(color: Colors.white),
          toastPosition: GFToastPosition.BOTTOM,
        );
      }
    });
  }

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

  Future<UserCredential> signInWithFacebook() async {

    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ["public_profile", "email"],);

    // check the status of our login
    if (loginResult.status == LoginStatus.success) {
      final graphResponse = await http.get(Uri.parse('https://graph.facebook.com/v2.12/me?fields=name,picture.width(500).height(500),email&access_token=${loginResult.accessToken!.token}'));
      _profile = jsonDecode(graphResponse.body);
    }
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    facebookUserCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    notifyListeners();
    return facebookUserCredential!;
  }

  Future signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final Credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    googleUserCredential = await FirebaseAuth.instance.signInWithCredential(Credential);

    notifyListeners();

    if(googleUserCredential != null)return googleUserCredential;
  }

  Future<void> googleLogOut() async {
    FirebaseAuth.instance.signOut();
    await GoogleSignIn().disconnect();
    await GoogleSignIn().signOut();
    notifyListeners();
  }

  Future<void> facebookLogOut() async {
    await FacebookAuth.i.logOut();
    FirebaseAuth.instance.signOut();
    _profile = null;
    notifyListeners();
  }

  Future<void> LogOut() async {
    FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}