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


  bool loading = false;

  Future<void> getInfos() async {
    await Provider.of<AuthProvider>(context,listen: false).getInfos(context);
  }

  @override
  void initState() {
    getInfos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<AuthProvider>(
        builder:(context, userInfo, child){
          if(userInfo.done == true){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormEmail(emailController: userInfo.emailController,),
                const SizedBox(height: 50),
                SizedBox(height: 60,child: TextFormName(nameController: userInfo.nameController,)),
                const SizedBox(height: 50),
                SizedBox(height: 60,child: TextFormPhone(phoneController: userInfo.phoneController,)),
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
                    const Text("Mettre à jour", style:  TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),),
                  ),
                ),
                const  SizedBox(height: 50),

              ],
            );
          }
          return GFShimmer(
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

    });




  }

  Widget buildShimmer(){
    return Container(height: 60, width: double.infinity, decoration: const BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(20))));
  }

  Future<void> updateUser() async {
    final provider = Provider.of<AuthProvider>(context,listen: false);

    // CHECK NAME
    if(provider.nameController.text.isEmpty && provider.phoneController.text.isNotEmpty){
      GFToast.showToast(
        "Le nom d'utilisateur est vide, veuillez entrer votre nom", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // CHECK PHONE
    if(provider.nameController.text.isNotEmpty && provider.phoneController.text.isEmpty){
      GFToast.showToast(
        "Veuillez entrer votre téléphone", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // CHECK BOTH
    if(provider.nameController.text.isEmpty && provider.phoneController.text.isEmpty){
      GFToast.showToast(
        "Veuillez saisir votre nom et téléphone", context, toastDuration: 3,
        backgroundColor: Colors.red.shade600,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }

    // UPDATE
    if(provider.nameController.text.isNotEmpty && provider.phoneController.text.isNotEmpty){
      try{
        await FirebaseAuth.instance.currentUser?.updateDisplayName(provider.nameController.text);
        await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
          'phone': provider.phoneController.text.trim(),
          'name': provider.nameController.text.trim(),
          'email' : provider.emailController.text.trim()
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
        labelText: "Nom",
        hintText: "Entrez votre nom",
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
        labelText: "Téléphone",
        hintText: "Entrez votre numéro de téléphone",
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

