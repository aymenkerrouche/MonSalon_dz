// ignore_for_file: non_constant_identifier_names, avoid_returning_null_for_void, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/theme/colors.dart';
import '../../../../providers/AuthProvider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/keyboard.dart';
import '../../../../widgets/form_error.dart';
import '../../../../widgets/phone TextField.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final List<String?> errors = [];
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;
  bool accept = false;
  bool isLoading = false;
  double height = 55;
  double width = 500;
  Color color = primary;
  bool login = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [

          //titre
          const SizedBox(height: 20),
          Text.rich(
            maxLines:1,
            TextSpan(
                text: login ? "Créer un " : "Connectez-",
                style:  TextStyle(color: black, fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                children: <InlineSpan>[
                  TextSpan(
                    text: login ? "compte" : "vous",
                    style: TextStyle(color: primary, fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 1.0),
                  )
                ]
            ),
          ),
          SizedBox(height: size.height * 0.05),

          //EMAIL PASSWORD
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                buildEmailFormField(),
                SizedBox(height: size.height * 0.03),
                buildPasswordFormField(),
                if (login) Container(height:  size.height * 0.03),
                if (login) buildPhoneNumberFormField(phoneController),
                if (login && errors.isNotEmpty) Container(height:  size.height * 0.01),
                FormError(errors: errors),
                SizedBox(height: size.height * 0.05),

                Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: primary,
                      fixedSize: Size(size.width, 55)
                    ),
                    onPressed: () async {
                      KeyboardUtil.hideKeyboard(context);
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        setState(() {errors.clear();width = 70;});
                        Timer(const Duration(milliseconds: 200), () {setState(() {isLoading = true;});
                          Timer(const Duration(milliseconds: 600), () async {
                            // Sign Up
                            if (login) {
                              await signUp().then((value) {
                                if (value == true) {
                                  if (!mounted)return ;
                                  setState(() {width = 100;height = 100;color = white;});
                                }
                              });
                            }

                            // Sign In
                            else {
                              await signIn().then((value) {
                                if (value == true) {
                                  if (!mounted) return;
                                  setState(() {width = 100;height = 100;color = white;});
                                }
                              });
                            }
                          });
                        });
                      }
                    },
                    child: isLoading ?
                    SizedBox(width: 40,height: 40,child: Center(child: CircularProgressIndicator(color: white,),),):
                    Text("Continue",
                      style: TextStyle(fontSize: 22, color: white,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                // GOOGLE
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color: primary, width: 1),
                    foregroundColor: primary,
                      fixedSize: const Size(double.infinity, 55)
                  ),
                  onPressed: () async {
                    final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                    KeyboardUtil.hideKeyboard(context);
                    try {
                      UserCredential user  = await providerAuth.signInWithGoogle();
                      // Photo & email
                      if(user.user != null  && user.user!.metadata.creationTime!.isAfter(DateTime.now().subtract(const Duration(minutes: 10)))) {

                        if(user.user?.email == null){
                          try{
                            await user.user?.updateEmail(FirebaseAuth.instance.currentUser!.providerData.first.email!);
                          }
                          catch(ee){
                            print("eeeeeeeeee$ee");
                          }
                        }
                      }

                    }
                    catch (e) {
                      GFToast.showToast(
                        e.toString(),
                        context,
                        toastDuration: 3,
                        backgroundColor: red,
                        textStyle: TextStyle(color: white),
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: size.width * 0.1,),
                      SvgPicture.asset(
                        "assets/icons/google.svg",
                        height: 28,
                        width: 28,
                      ),
                      const SizedBox(width: 15,),
                      Text(
                        "Connecter avec Google",
                        style: TextStyle(
                          fontSize: 18,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15,),

                // FACEBOOK
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color: primary, width: 1),
                    foregroundColor: primary,
                    fixedSize: const Size(double.infinity, 55)
                  ),
                  onPressed: () async {
                    KeyboardUtil.hideKeyboard(context);
                    final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                    try {
                      UserCredential user = await providerAuth.signInWithFacebook();

                      // Photo & email
                      if(user.user != null  && user.user!.metadata.creationTime!.isAfter(DateTime.now().subtract(const Duration(minutes: 10)))) {

                        await user.user?.updatePhotoURL(providerAuth.profile?['picture']['data']['url']);
                        if(user.user?.email == null){
                          try{
                            await user.user?.updateEmail(FirebaseAuth.instance.currentUser!.providerData.first.email!);
                          }
                          catch(ee){
                            print("eeeeeeeeee$ee");
                          }
                        }
                      }
                    }
                    on FirebaseAuthException catch (e) {
                      GFToast.showToast(
                        e.message,
                        context,
                        toastDuration: 10,
                        backgroundColor: red,
                        textStyle: TextStyle(color: white),
                        toastPosition: GFToastPosition.BOTTOM,
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: size.width * 0.09,),
                      const Icon(Icons.facebook_rounded,size: 37,color: Colors.blueAccent,),
                      const SizedBox(width: 10,),
                      Text(
                        "Connecter avec Facebook",
                        style: TextStyle(
                          fontSize: 18,
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),


                SizedBox(
                  width: size.width * 0.9,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        login ? "Vous avez un compte ?" : "Vous n’avez pas de compte ?",
                        style: TextStyle(
                          fontSize: 18,
                          color: black,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (login) {
                            setState(() {
                              login = false;
                            });
                          } else {
                            setState(() {
                              login = true;
                            });
                          }
                        },
                        child: Text(
                          login ? "Se connecter" : "S'inscrire",
                          style: TextStyle(
                            fontSize: 18,
                            color: primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.08),
        ],
      ),
    );
  }

  Future signIn() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
      provider.credentialAuth = EmailAuthProvider.credential(email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        width = 500;
        isLoading = false;
      });
      GFToast.showToast(
        e.message,
        context,
        toastDuration: 3,
        backgroundColor: red,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  Future signUp() async {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
      .then((currentUser) async =>
        await FirebaseFirestore.instance.collection("users").doc(currentUser.user?.uid).set({"phone": phoneController.text})
      );
      provider.credentialAuth = EmailAuthProvider.credential(email: emailController.text, password: passwordController.text);
      return true;
    }
    on FirebaseAuthException catch (e) {
      setState(() {
        width = 500;
        isLoading = false;
      });
      GFToast.showToast(
        e.message,
        context,
        toastDuration: 3,
        backgroundColor: red,
        textStyle: TextStyle(color: white),
        toastPosition: GFToastPosition.BOTTOM,
      );
    }
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: obscureText,
      controller: passwordController,
      cursorColor: primary,
      onSaved: (s){FocusScope.of(context).unfocus();},
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        }
        if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          removeError(error: kShortPassError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "Saisir votre mot de passe",
        labelStyle: TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
        suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                color: primary),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            }),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
      ),
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      cursorColor: primary,
      onSaved: (s){FocusScope.of(context).unfocus();},
      style: const TextStyle(fontWeight: FontWeight.w700),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          setState(() {
            addError(error: kInvalidEmailError);
          });
          return '';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Saisir votre email",
        labelStyle: TextStyle(color: primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_rounded, color: primary),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
