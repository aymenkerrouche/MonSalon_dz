// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ThemeProvider.dart';
import '../utils/constants.dart';

class BuildPhoneNumberFormField extends StatelessWidget {
  BuildPhoneNumberFormField({Key? key,required this.phoneController}) : super(key: key);
  TextEditingController phoneController;
  @override
  Widget build(BuildContext context) {
    final providerColor = Provider.of<ThemeProvider>(context,listen: false);
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      cursorColor: providerColor.primary,
      style: const TextStyle(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
        labelText: "Phone",
        hintText: "Saisir votre numéro",
        labelStyle: TextStyle(color: providerColor.primary),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(
          Icons.phone_rounded,
          color: providerColor.primary,
        ),
        hintStyle: const TextStyle(fontWeight: FontWeight.w700),
        border: outlineInputBorder(),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: providerColor.primary, width: 1.5),
            gapPadding: 6),
        enabledBorder: outlineInputBorder(),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      ),
    );
  }
}