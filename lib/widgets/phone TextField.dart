// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../utils/constants.dart';

TextFormField buildPhoneNumberFormField(phoneController,label, hint) {
  return TextFormField(
    keyboardType: TextInputType.phone,
    controller: phoneController,
    cursorColor: primary,
    style: const TextStyle(fontWeight: FontWeight.w700),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: primary),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      suffixIcon: Icon(
        Icons.phone_rounded,
        color: primary,
      ),
      hintStyle: const TextStyle(fontWeight: FontWeight.w700),
      border: outlineInputBorder(),
      focusedBorder: inputBorder(),
      enabledBorder: outlineInputBorder(),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    ),
  );
}