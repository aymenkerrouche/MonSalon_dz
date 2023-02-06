// ignore_for_file: non_constant_identifier_names, avoid_returning_null_for_void, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/providers/GoogleSignIn.dart';
import 'package:monsalondz/theme/colors.dart';
import '../../../../providers/AuthProvider.dart';
import '../../../../providers/ThemeProvider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/keyboard.dart';
import '../../../../widgets/form_error.dart';
import '../../../../widgets/PhoneTextField.dart';

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
  double height = 60;
  double width = 500;
  bool login = false;
  Color? color;

  @override
  void initState() {
    color = Provider.of<ThemeProvider>(context,listen: false).primary;
    super.initState();
  }

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
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
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
                    style: TextStyle(color: providerColor.primary, fontSize: 25, fontWeight: FontWeight.w700, letterSpacing: 1.0),
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
                if (login) BuildPhoneNumberFormField(phoneController:phoneController),
                if (login && errors.isNotEmpty) Container(height:  size.height * 0.01),
                FormError(errors: errors),
                SizedBox(height: size.height * 0.05),
                AnimatedContainer(
                  width: width,
                  height: height,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.fastOutSlowIn,
                  child: isLoading ?
                  Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration:  BoxDecoration(shape: BoxShape.circle,color: providerColor.primary,),
                    child: CircularProgressIndicator(color: white,),
                  ) :
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      backgroundColor: providerColor.primary,
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
                                if (value) {
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
                    child: Text("Continue",
                      style: TextStyle(fontSize: 22, color: white,fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    side: BorderSide(color: providerColor.primary, width: 1),
                    foregroundColor: providerColor.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),),
                  onPressed: () async {
                    KeyboardUtil.hideKeyboard(context);
                    try {
                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                      final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                      final credential = await provider.googleLogin();
                      providerAuth.credential = credential;

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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/google.svg",
                        height: 28,
                        width: 28,
                      ),
                      const SizedBox(width: 15,),
                      Text(
                        "Se connecter avec google",
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
                            color: providerColor.primary,
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
      provider.credential = EmailAuthProvider.credential(email: emailController.text, password: passwordController.text);
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
      provider.credential = EmailAuthProvider.credential(email: emailController.text, password: passwordController.text);
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
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
    return TextFormField(
      obscureText: obscureText,
      controller: passwordController,
      cursorColor: providerColor.primary,
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
        labelStyle: TextStyle(color: providerColor.primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
        suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility,
                color: providerColor.primary),
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
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: providerColor.primary, width: 1.5),
            gapPadding: 6),
        enabledBorder: outlineInputBorder(),
      ),
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
  }

  TextFormField buildEmailFormField() {
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      cursorColor: providerColor.primary,
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
        labelStyle: TextStyle(color: providerColor.primary,),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.email_rounded, color: providerColor.primary,),
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        border: outlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: providerColor.primary, width: 1.5),
            gapPadding: 6),
        enabledBorder: outlineInputBorder(),
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}
