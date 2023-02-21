import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/MiniSalon.dart';

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







  // SALONS LIST

  List<MiniSalon> _listSalon = [];
  List<MiniSalon> get listSalon => _listSalon;

  final int _limit = 7;
  bool isLoading = false;
  String searchError = '';
  bool hasMore = true;
  DocumentSnapshot? lastDocument;


  Future fetchSalons() async {
    QuerySnapshot? documentList;
    if(!hasMore) {
      notifyListeners();
      return;
    }
    else{
      isLoading = true;
      print("============================ fat ===================");
      if (_listSalon.isEmpty){
        await FirebaseFirestore.instance.collection("salon").orderBy('nom').limit(_limit).get().then((snapshot){
          documentList = snapshot;
          for (var element in snapshot.docs) {
            MiniSalon data = MiniSalon.fromJson(element.data());
            data.id = element.id;
            _listSalon.add(data);
          }
        })
            .catchError((e){
          isLoading = false;
          searchError = e.toString();
        });
      }
      else {
        await FirebaseFirestore.instance.collection("salon").orderBy('nom').startAfterDocument(lastDocument!).limit(_limit).get().then((snapshot){
          documentList = snapshot;
          for (var element in snapshot.docs) {
            MiniSalon data = MiniSalon.fromJson(element.data());
            data.id = element.id;
            _listSalon.add(data);
          }
        })
            .catchError((e){
          isLoading = false;
          searchError = e.toString();
        });
      }

      if(documentList != null){
        lastDocument = documentList!.docs[documentList!.docs.length - 1];
        if (documentList!.docs.length < _limit) {
          hasMore = false;
        }
      }
      isLoading = false;
      notifyListeners();
    }
  }

}