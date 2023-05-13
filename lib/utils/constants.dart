import 'package:flutter/material.dart';
import 'package:monsalondz/models/Pub.dart';
import 'package:monsalondz/theme/colors.dart';
import 'package:intl/intl.dart';


DateFormat dateFormat = DateFormat("dd-MM-yyyy HH:mm");
// DAYS
const Map<int, String> weekdayName = {1: "lundi", 2: "mardi", 3: "mercredi", 4: "jeudi", 5: "vendredi", 6: "samedi", 7: "dimanche"};

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

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
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
      gapPadding: 6);
}

OutlineInputBorder inputBorder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: primary, width: 1.5),
      gapPadding: 6);
}

String formatPrice(int priceToFormat) {
  final total = NumberFormat('#,###');
  return total.format(priceToFormat);
}


Pub localPub = Pub('0',true ,0, -1, "MonSalon", "https://monsalon-dz.com/", true, "${DateTime.now()}", "${DateTime.now().add(const Duration(days: 120))}", "assets/images/vide.jpg");