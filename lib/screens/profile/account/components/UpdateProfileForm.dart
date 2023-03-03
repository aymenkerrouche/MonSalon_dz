// ignore_for_file: curly_braces_in_flow_control_structures, avoid_returning_null_for_void, use_key_in_widget_constructors, non_constant_identifier_names
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:monsalondz/theme/colors.dart';
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
  String email = '';

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool done = false;
  bool loading = false;

  fillUser() async {
    done = await getInfos();
    emailController.text = FirebaseAuth.instance.currentUser?.email ?? FirebaseAuth.instance.currentUser!.providerData.first.email ?? email ;
    nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';

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

  Future<bool> getInfos() async {
    try{
      await firestore.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get().then((snapshot){
        phoneController.text = snapshot.data()?['phone'] ?? '';
        email = snapshot.data()?['email'] ?? '';
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
    print("=================${FirebaseAuth.instance.currentUser!.phoneNumber}===================");
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
        await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          'phone': phoneController.text.trim(),
          'name': nameController.text.trim(),
          'email' : emailController.text.trim()
        })
        .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
            snackBar("Mise à jour du profil réussie", primary, Icons.done_rounded,25)
        ));
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
    print("=================email===================");
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
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
    print("=================name===================");
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
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    ));
  }
}

class TextFormPhone extends StatelessWidget {
  TextFormPhone({Key? key, required this.phoneController}) : super(key: key);
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    print("=================phone===================");
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
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    ));
  }
}

