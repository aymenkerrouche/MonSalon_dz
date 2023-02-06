import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {

  final TextEditingController _search = TextEditingController();
  TextEditingController get search => _search;

  final TextEditingController _searchWilaya = TextEditingController();
  TextEditingController get searchWilaya => _searchWilaya;

  final TextEditingController _searchDate  = TextEditingController();
  TextEditingController get searchDate => _searchDate;

  String _hour = '';
  String get hour => _hour;

  String _day = '';
  String get day => _day;

  setDate(day) {
    _searchDate.text = day;
    notifyListeners();
  }

  setDayName(dayName) {
    _day = dayName;
    notifyListeners();
  }

  setHour(heure) {
    _hour = heure;
    notifyListeners();
  }

}