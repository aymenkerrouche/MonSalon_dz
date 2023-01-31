import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {

  final TextEditingController _search = TextEditingController();
  TextEditingController get search => _search;

  final TextEditingController _searchWilaya = TextEditingController();
  TextEditingController get searchWilaya => _searchWilaya;

  final TextEditingController _searchDate  = TextEditingController();
  TextEditingController get searchDate => _searchDate;

  late String _searchHour;
  String get searchHour => _searchHour;

  getSearchDay(day) {
    _searchDate.text = day;
    notifyListeners();
  }
  getSearchDayName(dayName) {
    _searchDate.text = dayName;
    notifyListeners();
  }

  getSearchHour(hour) {
    _searchHour = hour;
    notifyListeners();
  }

  getSearchWilaya(wilaya) {
    _searchWilaya.text = wilaya;
    notifyListeners();
  }

  getSearch(searched) {
    _search.text = searched;
    notifyListeners();
  }
}