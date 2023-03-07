// ignore_for_file: curly_braces_in_flow_control_structures, avoid_returning_null_for_void, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/providers/AuthProvider.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/constants.dart';

class UpdateProfileForm extends StatefulWidget {
  const UpdateProfileForm({super.key});
  @override
  UpdateProfileFormState createState() => UpdateProfileFormState();
}

class UpdateProfileFormState extends State<UpdateProfileForm> {

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String email = '';

  bool done = false;
  bool loading = false;

  Future<void> getInfos() async {
    try{
      await firestore.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((snapshot){
        phoneController.text = snapshot.data()?['phone'] ?? '';
        email = snapshot.data()?['email'] ?? '';
      })
      .then((value) {
        if(FirebaseAuth.instance.currentUser!.email != null){
          emailController.text = FirebaseAuth.instance.currentUser!.email! ;
        }
        else if(FirebaseAuth.instance.currentUser!.providerData.first.email != null){
          emailController.text = FirebaseAuth.instance.currentUser!.providerData.first.email!;
        }
        else{emailController.text = email ;}
        nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
        Timer(const Duration(milliseconds: 700),(){setState(() {done = true;});});
      });
    }
    catch(e){
      GFToast.showToast(
        e.toString(), context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
    Timer(const Duration(seconds: 5),(){
      if(done == false) {
        setState(() {done = true;});
        GFToast.showToast(
          'Internet Connection Problem', context, toastDuration: 3,
          backgroundColor: Colors.red.shade600,
          textStyle: TextStyle(color: white),
          toastPosition: GFToastPosition.BOTTOM,
        );
      }
    });
  }

  @override
  void initState() {
    getInfos();
    super.initState();
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
    return done ?
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormEmail(emailController: emailController,),
        const SizedBox(height: 50),
        SizedBox(height: 60,child: TextFormName(nameController: nameController,)),
        const SizedBox(height: 50),
        SizedBox(height: 60,child: TextFormPhone(phoneController: phoneController,)),
        const  SizedBox(height: 50),
        SizedBox(
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: primary,
              elevation: 6
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
                fontSize: 25,
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
        Provider.of<AuthProvider>(context,listen: false).name = nameController.text.trim();
        Provider.of<AuthProvider>(context,listen: false).phone = phoneController.text.trim();
        await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).set({
          'phone': phoneController.text.trim(),
          'name': nameController.text.trim(),
          'email' : emailController.text.trim()
        })
        .then((v) => GFToast.showToast("Mise à jour du profil réussie", context,toastDuration: 3,backgroundColor: primary,textStyle: const TextStyle(color: Colors.white),toastPosition:GFToastPosition.BOTTOM));
      }
      on FirebaseAuthException catch (e) {
        GFToast.showToast(e.code, context,toastDuration: 3,backgroundColor: red,textStyle: TextStyle(color: white),toastPosition:GFToastPosition.BOTTOM,);
      }
    }

  }
}

class TextFormEmail extends StatelessWidget {
  TextFormEmail({Key? key, required this.emailController}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60,child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      readOnly: FirebaseAuth.instance.currentUser!.phoneNumber != null ? false : true,
      controller: emailController,
      cursorColor: primary,
      style: const TextStyle(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_rounded, color: primary),
        contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        hintStyle: const TextStyle(fontWeight: FontWeight.w400),
      ),
    ));
  }
}

class TextFormName extends StatelessWidget {
  TextFormName({Key? key, required this.nameController}) : super(key: key);
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60,child: TextFormField(
      controller: nameController,
      cursorColor: primary,
      style: const TextStyle(fontWeight: FontWeight.w700),
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
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    ));
  }
}

class TextFormPhone extends StatelessWidget {
  TextFormPhone({Key? key, required this.phoneController}) : super(key: key);
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 60,child: TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      readOnly: FirebaseAuth.instance.currentUser!.phoneNumber != null  ? true : false,
      cursorColor: primary,
      scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      style: const TextStyle(fontWeight: FontWeight.w700),
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
        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
    ));
  }
}

