// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {

  //Color _primary = const Color(0xFFFF007F);
  //Color _primaryPro = const Color(0xFFAB0054);

  Color pink = const Color(0xFFFF007F);
  Color pinkPro = const Color(0xFFAB0054);

  Color _primary = const Color(0xFF2C8F6A);
  Color _primaryPro = Colors.green.shade900;
  Color green = Colors.green.shade700;

  Color blue = Colors.blueAccent;
  Color bluePro = Colors.blueAccent.shade700;

  Color get primary =>  _primary;
  Color get primaryPro => _primaryPro;

  setPrimary(Color color, Color colorPro){
     _primary =  color;
     _primaryPro = colorPro;
     notifyListeners();
  }


}