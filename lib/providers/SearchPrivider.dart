import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';
import '../models/Service.dart';

class SearchProvider extends ChangeNotifier {


  // SEARCH
  TextEditingController _search = TextEditingController();
  TextEditingController get search => _search;

  clearSearch(){
    _search.clear();
    notifyListeners();
  }

  refreshSearch(){
    notifyListeners();
  }


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

  clearAll(){
  _searchWilaya.clear();
  _search.clear();
  _day = '';
  _searchDate.clear();
  _hour = '';
  _prixFin = 0;
  clearServicesSelectioned();
  notifyListeners();
}

  static int _prixFin = 0;
  int get prixFin => _prixFin;
  set prixFin(int newPrix){
    _prixFin = newPrix;
    notifyListeners();
  }







  // SALONS LIST

  List<Salon> _listSalon = [];
  List<Salon> get listSalon => _listSalon;

  static const int _limit = 50;
  bool isLoading = false;
  String searchError = '';
  bool hasMore = true;
  DocumentSnapshot? lastDocument;
  bool isSearching = false;
  Service? servicesSelectioned;


  clearServicesSelectioned(){
    servicesSelectioned = null;
    notifyListeners();
  }

  setPrestation(Service service){
    servicesSelectioned = service;
    notifyListeners();
  }

  filterPrestation(){
    if(servicesSelectioned != null){
      List<Salon> salonTemps = [];
      for (var sln in _listSalon) {
        if(sln.service.where((element) => element.service == servicesSelectioned?.service).isNotEmpty){
          salonTemps.add(sln);
        }
      }
      _listSalon = salonTemps;
    }
    notifyListeners();
  }


  Future<void> fetchSalons() async {

    QuerySnapshot? documentList;
    isLoading = true;

    if (_listSalon.isEmpty){
      isSearching= true;
      await FirebaseFirestore.instance.collection("salon").where("visible", isEqualTo: true).orderBy('nom').limit(_limit).get().then((snapshot){
        documentList = snapshot;
        for (var element in snapshot.docs) {
          Salon data = Salon.fromJson(element.data());
          data.id = element.id;
          _listSalon.add(data);
        }
      })
      .catchError((e){
        isLoading = false;
        searchError = e.toString();
      });
      isSearching= false;
    }

    else {
      await FirebaseFirestore.instance.collection("salon").where("visible", isEqualTo: true).orderBy('nom').startAfterDocument(lastDocument!).limit(_limit).get().then((snapshot){
        documentList = snapshot;
        for (var element in snapshot.docs) {
          Salon data = Salon.fromJson(element.data());
          data.id = element.id;
          _listSalon.add(data);
        }
      })
      .catchError((e){
        isLoading = false;
        searchError = e.toString();
      });
    }

    if(documentList != null && documentList!.docs.isNotEmpty){
      lastDocument = documentList!.docs[documentList!.docs.length - 1];
      if (documentList!.docs.length < _limit) {
        hasMore = false;
      }
    }
    notifyListeners();

    Timer(const Duration(seconds: 1), () {isLoading = false;notifyListeners(); });
  }

  Future<void> filterSalons(dynamic category, dynamic wilaya, dynamic price, dynamic date) async {

    final CollectionReference salonsSearchRef = FirebaseFirestore.instance.collection("salonsSearch");
    final CollectionReference salonRef = FirebaseFirestore.instance.collection("salon");

    Query query = salonsSearchRef;

    if (category != null) {
      query = query.where("category", arrayContains: category);
    }

    if (wilaya != null) {
      query = query.where("wilaya", isEqualTo: wilaya);
    }

    if (price != null) {
      query = query.where("prix", isLessThanOrEqualTo: price);
    }

    if (date != null) {
      query = query.where("days.$date", isEqualTo: true);
    }

    query = query.where("visible", isEqualTo: true);

    final QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      final List<String> salonIds = [];
      final List<Future<DocumentSnapshot>> salonFutures = [];

      for (final QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        final String salonID = documentSnapshot["salonID"];
        salonIds.add(salonID);
        salonFutures.add(salonRef.doc(salonID).get());
      }

      final List<DocumentSnapshot> salonSnapshots = await Future.wait(salonFutures);

      for (int i = 0; i < salonSnapshots.length; i++) {
        final DocumentSnapshot salon = salonSnapshots[i];
        if (salon.exists) {
          final Salon data = Salon.fromJson(salon.data() as Map<String, dynamic>);
          data.id = salon.id;
          try{
            data.prix = querySnapshot.docs[i].get("prix") ?? 0;
          }
          catch(e){
            data.prix = 0;
          }
          _listSalon.add(data);
        }
      }
    }
  }

  Future<void> filterSalonsWithPrestation(dynamic category, dynamic wilaya, dynamic price, dynamic date) async {
    isSearching = true;
    _listSalon.clear();
    notifyListeners();
    try{
      await filterSalons(category, wilaya, price, date).then((value) async => await getServices().whenComplete(() => filterPrestation()));
    }
    catch(e){print(e);}
    isSearching = false;
    notifyListeners();
  }

  Future<void> getServices() async {
    if(_listSalon.isNotEmpty){
      for (var element in _listSalon) {
        await FirebaseFirestore.instance.collection("services").
        where("salonID", isEqualTo: element.id ).get().then((services){
          if(services.docs.isNotEmpty){
            for (var sr in services.docs) {
              Service service =  Service.fromJson(sr.data());
              service.id = sr.id;
              element.service.add(service);
            }
          }
        });
      }
    }
    notifyListeners();
  }

/*  Future<void> searchByWord() async{



    await FirebaseFirestore.instance.collection("salon")
        .orderBy("nom")
        //.startAt([_search.text]).endAt(["${_search.text}\uf8ff"])
        .where("nom", isGreaterThanOrEqualTo: _search.text)
        .where("nom", isLessThanOrEqualTo: "${_search.text}\uf8ff")
        .get().then((value){
          if(value.docs.isNotEmpty){
            for (var element in value.docs) {
              print(element.data());
            }
          }
          else{
            print(value.docs);
          }
    });
  }*/

}