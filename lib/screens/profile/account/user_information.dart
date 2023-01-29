// ignore_for_file: curly_braces_in_flow_control_structures, avoid_returning_null_for_void, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/colors/gf_color.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/theme/colors.dart';
import '../../../../utils/constants.dart';

class UpdateProfile extends StatefulWidget {
  @override
  UpdateProfileState createState() => UpdateProfileState();
}

class UpdateProfileState extends State<UpdateProfile> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool done = false;
  bool loading = false;

  fillUser() async {
    done = await getUser();
    emailController.text = user?.email ?? '';
    nameController.text = user?.displayName ?? '';

    if(done == false){
      Timer(const Duration(seconds: 5),(){
        setState(() {done = true;});
        GFToast.showToast(
          'Internet Connection Problem', context, toastDuration: 3,
          backgroundColor: Colors.red.shade600,
          textStyle: TextStyle(color: white),
          toastPosition: GFToastPosition.BOTTOM,
        );
      });
    }
    else{Timer(const Duration(milliseconds: 700),(){setState(() {done = true;});});}

  }

  Future<bool> getUser() async {
    try{
      await firestore.collection("users").doc(user?.uid).get().then((snapshot){
        phoneController.text = snapshot.data()?.values.first ?? '';
      });
      return true;
    }
    catch(e){
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    fillUser();
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return done ? Column(
      children: [
        buildEmailFormField(),
        SizedBox(height: size.height * 0.05),
        buildNameFormField(),
        SizedBox(height: size.height * 0.05),
        buildPhoneNumberFormField(),
        SizedBox(height: size.height * 0.1),
        SizedBox(
          width: size.width,
          height: size.height * 0.07,
          child: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: primary,
            ),
            onPressed: () async {
              setState(() {loading = true;});
              try{
                await updateUser();
              }
              on FirebaseAuthException catch(e){
                GFToast.showToast(
                  e.code, context, toastDuration: 3,
                  backgroundColor: Colors.red.shade600,
                  textStyle: TextStyle(color: white),
                  toastPosition: GFToastPosition.BOTTOM,
                );
              }
              setState(() {loading = false;});
            },
            child: loading ?
              const SizedBox(height: 30,width: 30,child: CircularProgressIndicator(color: Colors.white,)):
              const Text("Confirm", style:  TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),),
          ),
        )
      ],
    ):
    GFShimmer(
      mainColor: Colors.grey.shade50,
      child: Column(
        children: [
          buildShimmer(),
          SizedBox(height: size.height * 0.05),
          buildShimmer(),
          SizedBox(height: size.height * 0.05),
          buildShimmer(),
          SizedBox(height: size.height * 0.1),
          buildShimmer(),
        ],
      ),
    );
  }

  Widget buildShimmer(){
    return Container(height: 60, width: double.infinity, decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))));
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      readOnly: true,
      controller: emailController,
      cursorColor: primary,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_rounded, color: primary),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: nameController,
      cursorColor: primary,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        labelStyle:  TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.person,
          color: primary,
        ),
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      cursorColor: primary,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: "Phone",
        hintText: "Enter your phone number",
        labelStyle:  TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.phone_rounded,
          color: primary,
        ),
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }

  Future<void> updateUser() async {

    // CHECK NAME
    if(nameController.text.isEmpty && phoneController.text.isNotEmpty){
      GFToast.showToast(
        "User name is empty, Please enter your name", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // CHECK PHONE
    if(nameController.text.isNotEmpty && phoneController.text.isEmpty){
      GFToast.showToast(
        "Please enter your phone", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // CHECK BOTH
    if(nameController.text.isEmpty && phoneController.text.isEmpty){
      GFToast.showToast(
        "Please enter your Name and Phone", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // UPDATE
    if(nameController.text.isNotEmpty && phoneController.text.isNotEmpty){
      try{
        await user?.updateDisplayName(nameController.text);
        await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
          'phone': phoneController.text.trim(),
        })
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(snackBar("Profile updated",Colors.green.shade600)));
      }
      on FirebaseAuthException catch (e) {
        GFToast.showToast(e.code, context,toastDuration: 3,backgroundColor: red,textStyle: TextStyle(color: white),toastPosition:GFToastPosition.BOTTOM,);
      }
    }

  }
}
