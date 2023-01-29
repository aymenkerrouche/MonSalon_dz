import 'package:flutter/material.dart';
import 'package:monsalondz/theme/colors.dart';

/*List categories = [
  {"category": "Coiffure", "pic": "assets/images/coiffure.jpg"},
  {"category": "Mains et Pieds", "pic": "assets/images/nails.jpg"},
  {"category": "Maquillage", "pic": "assets/images/make_up.jpg"},
  {"category": "Epilation", "pic": "assets/images/epilation.jpg"},

  {"category": "Spa", "pic": "assets/images/spa.jpg"},
  {"category": "Visage", "pic": "assets/images/visage.jpg"},
  {"category": "Mariage", "pic": "assets/images/mariage.jpg"},
  {"category": "Massage", "pic": "assets/images/massage.jpg"},

  {"category": "Homme", "pic": "assets/images/homme.jpg"},
  {"category": "Beauté à domicile", "pic": "assets/images/salon1.jpg"},
];*/


snackBar(String txt,Color color){
  return  SnackBar(
    content: Text(txt, style: TextStyle(color: white,fontWeight: FontWeight.w700,fontSize: 16),),
    backgroundColor: color,
    elevation: 10,
    margin: const EdgeInsets.only(bottom: 25,right: 15,left: 15),
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
    action: SnackBarAction(label: 'OK', onPressed: (){},textColor:Colors.white),
  );
}


// DAYS
const Map<int, String> weekdayName = {1: "Lundi", 2: "Mardi", 3: "Mercredi", 4: "Jeudi", 5: "Vendredi", 6: "Samedi", 7: "Dimanche"};



// Form Error
const String kEmailNullError = "Veuillez saisir votre email";
const String kInvalidEmailError = "Veuillez entrer un courriel valide";
const String kPassNullError = "Veuillez entrer votre mot de passe";
const String kShortPassError = "Mot de passe trop court";
const String kPhoneNumberNullError = "Veuillez entrer votre numéro";
const String kNamelNullError = "Veuillez saisir votre nom";

final RegExp emailValidatorRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9.]+");

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
      gapPadding: 6);
}

OutlineInputBorder inputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: primary, width: 1.5),
      gapPadding: 6);
}
