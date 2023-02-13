import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {


  // SEARCH
  TextEditingController _search = TextEditingController();
  TextEditingController get search => _search;


 // DATE

  TextEditingController _searchDate  = TextEditingController();
  TextEditingController get searchDate => _searchDate;

  setDate(date) {
    _searchDate.text = date;
    notifyListeners();
  }

  clearDay(){
    _searchDate.clear();
    notifyListeners();
  }



  // DAY

  String _day = '';
  String get day => _day;

  setDayName(dayName) {
    _day = dayName;
    notifyListeners();
  }
  clearDayName(){
    _day = '';
    notifyListeners();
  }



  // HOUR

  String _hour = '';
  String get hour => _hour;

  setHour(heure) {
    _hour = heure;
    notifyListeners();
  }

  clearHour(){
    _hour = '';
    notifyListeners();
  }


  // WILAYA

  TextEditingController _searchWilaya = TextEditingController();
  TextEditingController get searchWilaya => _searchWilaya;

  setWilaya(String newWilaya){
    _searchWilaya.text = newWilaya;
    notifyListeners();
  }

  clearWilaya(){
    _searchWilaya.clear();
    notifyListeners();
  }








  // PRIX
  static double _prix = 0;
  double get prix => _prix;
  set prix(double newPrix){
    _prix = newPrix;
    notifyListeners();
  }

  static double _prixFin = 0;
  double get prixFin => _prixFin;
  set prixFin(double newPrix){
    _prixFin = newPrix;
    notifyListeners();
  }

  static RangeValues _rangeValues = const RangeValues(0, 0);
  RangeValues get rangeValues => _rangeValues;
  set rangeValues(RangeValues newRangeValues){
    _rangeValues = newRangeValues;
    _prix = _rangeValues.start;
    _prixFin = _rangeValues.end;
    notifyListeners();
  }

}