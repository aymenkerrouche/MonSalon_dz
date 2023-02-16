// ignore_for_file: non_constant_identifier_names, avoid_returning_null_for_void, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/components/toast/gf_toast.dart';
import 'package:getwidget/position/gf_toast_position.dart';
import 'package:provider/provider.dart';
import 'package:monsalondz/theme/colors.dart';
import '../../../../providers/AuthProvider.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/keyboard.dart';
import '../../../../widgets/Otp.dart';
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

                  // EMAIL
                  buildEmailFormField(),
                  SizedBox(height: size.height * 0.03),

                  // PASSWORD
                  buildPasswordFormField(),

                  // FORGOT PASSWORD
                  if(!login) SizedBox(
                    height: 30,
                    width: size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed:(){
                            showModalBottomSheet(
                              context: context,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                              ),
                              builder: (context) {
                                return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                    width: size.width,
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children:[
                                        Container(
                                         height: 4,
                                         width: 30,
                                         margin: const EdgeInsets.only(top: 5,bottom: 30),
                                         decoration:  BoxDecoration(
                                           color: primaryPro,
                                           borderRadius: const BorderRadius.all(Radius.circular(50)),
                                         ),
                                       ),
                                        const Text( "Réinitialiser le mot de passe",
                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                        ),
                                        const SizedBox(height: 25,),
                                        buildEmailFormField(),
                                        Container(
                                          margin: const EdgeInsets.only(top: 20,bottom: 40),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                              backgroundColor: primary,
                                              fixedSize: Size(size.width, 50)
                                            ),
                                            onPressed: () async {
                                              KeyboardUtil.hideKeyboard(context);
                                              await passwordReset();
                                              Navigator.pop(context);
                                            },
                                            child: isLoading ?
                                            SizedBox(width: 30,height: 30,child: Center(child: CircularProgressIndicator(color: white,),),):
                                            Text( "Envoyer le code",
                                              style: TextStyle(fontSize: 20, color: white,fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          child: Text(
                              "Mot de passe oublié ?",
                              style: TextStyle(fontSize: 12,color: primary),
                            ),
                        ),
                      ],
                    ),
                  ),
                  if (login) SizedBox(height:  size.height * 0.03),

                  //PHONE
                  if (login) buildPhoneNumberFormField(phoneController,"Phone","Saisir votre numéro"),
                  if (login && errors.isNotEmpty) SizedBox(height:  size.height * 0.01),


                  // ERRORS
                  FormError(errors: errors),
                  SizedBox(height: login ? size.height * 0.04 : size.height * 0.02 ),

                  // SUBMIT
                  Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        backgroundColor: primary,
                        fixedSize: Size(size.width, 55)
                      ),
                      onPressed: () async {
                        KeyboardUtil.hideKeyboard(context);
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          setState(() {errors.clear();isLoading = true;});

                          // Sign Up
                          if (login) {
                            await signUp();
                          }

                          // Sign In
                          else {
                            await signIn();
                          }

                        }
                      },
                      child: isLoading ?
                      SizedBox(width: 40,height: 40,child: Center(child: CircularProgressIndicator(color: white,),),):
                      Text( login ? "Continue" : "Se connecter",
                        style: TextStyle(fontSize: 24, color: white,fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),

                  // GOOGLE
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      side: BorderSide(color: primary, width: 1),
                      foregroundColor: primary,
                        fixedSize: const Size(double.infinity, 55)
                    ),
                    onPressed: () async {
                      final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                      KeyboardUtil.hideKeyboard(context);
                      try {
                        await providerAuth.signInWithGoogle();
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      foregroundColor: primary,
                      fixedSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.blueAccent
                    ),
                    onPressed: () async {
                      KeyboardUtil.hideKeyboard(context);
                      final providerAuth = Provider.of<AuthProvider>(context, listen: false);
                      try {
                        UserCredential user = await providerAuth.signInWithFacebook();

                        // Photo & email
                        if(user.user != null  && user.user!.metadata.creationTime!.isAfter(DateTime.now().subtract(const Duration(minutes: 2)))) {
                          try{
                            await user.user?.updatePhotoURL(providerAuth.profile?['picture']['data']['url']);
                          }
                          catch(ee){
                            debugPrint(ee.toString());
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
                        const Icon(Icons.facebook_rounded,size: 37,color: Colors.white,),
                        const SizedBox(width: 10,),
                        const Text(
                          "Connecter avec Facebook",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15,),

                  // OTP
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      foregroundColor: primary,
                      fixedSize: const Size(double.infinity, 55),
                      backgroundColor: Colors.greenAccent.shade700
                    ),
                    onPressed: () async {
                      bool waitCode = false;
                      showModalBottomSheet(
                        context: context,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight: Radius.circular(16))
                        ),
                        builder: (context) {
                          return Padding(
                            padding: MediaQuery.of(context).viewInsets,
                            child: Container(
                              width: size.width,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:[
                                  Container(
                                    height: 4,
                                    width: 30,
                                    margin: const EdgeInsets.only(top: 5,bottom: 30),
                                    decoration:  BoxDecoration(
                                      color: primaryPro,
                                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                                    ),
                                  ),
                                  Text( waitCode == false ? "Saisir votre numéro télephone" : "Saisir le code",
                                    style: const TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  const SizedBox(height: 25,),
                                  waitCode == false ? buildPhoneNumberFormField(phoneController,"Phone","Saisir votre numéro"):buildPhoneNumberFormField(phoneController,"code","Saisir le code"),

                                  Container(
                                    margin: const EdgeInsets.only(top: 20,bottom: 40),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          backgroundColor: Colors.greenAccent.shade700,
                                          fixedSize: Size(size.width, 50)
                                      ),
                                      onPressed: () async {
                                        KeyboardUtil.hideKeyboard(context);
                                        EasyLoading.show(status: 'loading...',maskType:EasyLoadingMaskType.black);
                                        EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.circle;

                                        await FirebaseAuth.instance.verifyPhoneNumber(
                                          phoneNumber: phoneController.text,

                                          verificationCompleted: (PhoneAuthCredential credential) async {
                                            EasyLoading.dismiss();
                                            EasyLoading.showSuccess('Bienvenue');
                                            await FirebaseAuth.instance.signInWithCredential(credential);
                                          },

                                          verificationFailed: (e) {
                                            EasyLoading.dismiss();
                                            GFToast.showToast(
                                              Provider.of<AuthProvider>(context,listen: false).error.toString(),
                                              context,
                                              toastDuration: 3,
                                              backgroundColor: red,
                                              textStyle: TextStyle(color: white),
                                              toastPosition: GFToastPosition.BOTTOM,
                                            );
                                          },

                                          codeAutoRetrievalTimeout: (String verificationId) {
                                            // Auto-resolution timed out...
                                          },

                                          // Displays a dialog box when OTP is sent
                                          codeSent: ((String verificationId, int? resendToken) async {

                                            Navigator.of(context).pop();


                                                /*PhoneAuthCredential credential = PhoneAuthProvider.credential(
                                                  verificationId: verificationId,
                                                  smsCode: codeController.text.trim(),
                                                );

                                                // !!! Works only on Android, iOS !!!
                                                await FirebaseAuth.instance.signInWithCredential(credential);
                                                Navigator.of(context).pop(); */// Remove the dialog box

                                          }),
                                        );
                                      },
                                      child: Text( "Envoyer le code",
                                        style: TextStyle(fontSize: 20, color: white,fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                         Spacer(),
                        Icon(Icons.phone_rounded,size: 37,color: Colors.white,),
                        SizedBox(width: 10,),
                        Text(
                          "Numéro téléphone",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        Spacer()
                      ],
                    ),
                  ),

                  // TYPE
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
      setState(() {
        isLoading = false;
      });
    }
    on FirebaseAuthException catch (e) {
      setState(() {
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
        await FirebaseFirestore.instance.collection("users").doc(currentUser.user?.uid).set({"phone": phoneController.text,"email": emailController.text})
      );
      provider.credentialAuth = EmailAuthProvider.credential(email: emailController.text, password: passwordController.text);
      setState(() {
        isLoading = false;
      });
      return true;
    }
    on FirebaseAuthException catch (e) {
      setState(() {
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
          vertical: 15,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: outlineInputBorder(),
        focusedBorder: inputBorder(),
        enabledBorder: outlineInputBorder(),
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((v) =>
        GFToast.showToast("le code a été envoyé", context,backgroundColor: Colors.green.shade700,toastPosition: GFToastPosition.BOTTOM)
      );

    }
    on FirebaseException catch (e) {
      debugPrint(e.message);
      GFToast.showToast(e.message!, context,backgroundColor: Colors.red.shade700,toastPosition: GFToastPosition.BOTTOM,toastDuration: 4);

    }
  }
}
