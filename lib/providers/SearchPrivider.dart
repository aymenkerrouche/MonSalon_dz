import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';

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



clearAll(){
  _searchWilaya.clear();
  _search.clear();
  _day = '';
  _searchDate.clear();
  _hour = '';
  _prixFin = 0;
  _prix = 0;
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

  List<Salon> _listSalon = [];
  List<Salon> get listSalon => _listSalon;

  static const int _limit = 15;
  bool isLoading = false;
  String searchError = '';
  bool hasMore = true;
  DocumentSnapshot? lastDocument;
  bool isSearching = false;


  Future fetchSalons() async {
    QuerySnapshot? documentList;
    isLoading = true;

    if (_listSalon.isEmpty){
      isSearching= true;
      await FirebaseFirestore.instance.collection("salon").orderBy('nom').limit(_limit).get().then((snapshot){
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
      await FirebaseFirestore.instance.collection("salon").orderBy('nom').startAfterDocument(lastDocument!).limit(_limit).get().then((snapshot){
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


  // FILTER
  Future<void> filterSalons(dynamic category,dynamic wilaya,dynamic price,dynamic date) async {

    isSearching= true;
    _listSalon.clear();
    notifyListeners();

    if(category != null ){

      if(wilaya != null){

        if(price != null){

          if(date != null){

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("days.$date", isEqualTo: true )
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

        }

        else{

          if(date != null){
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("days.$date", isEqualTo: true )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

        }

      }

      // IF WILAYA NULL
      else{

        if(price != null){

          if(date != null){
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("days.$date", isEqualTo: true )
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }
        }

        else{

          if(date != null){

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("category", arrayContains: category )
                .where("days.$date", isEqualTo: true )
                .get()
            .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{
            await FirebaseFirestore.instance.collection("salonsSearch")
            .where("category", arrayContains: category )
            .get()
            .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                  .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }
            });
          }

        }

      }
    }

    else{

      if(wilaya != null){

        if(price != null){

          if(date != null){
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("days.$date", isEqualTo: true )
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("prix", isLessThanOrEqualTo: price )
                .where("prix", isGreaterThanOrEqualTo: _prix )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }
        }

        else{

          if(date != null){
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("days.$date", isEqualTo: true )
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{
            await FirebaseFirestore.instance.collection("salon")
                .where("wilaya", isEqualTo: wilaya ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {
                  Salon data = Salon.fromJson(element.data() );
                  data.id = element.id;
                  _listSalon.add(data);
                    notifyListeners();
                });
              }
            });
          }
        }

      }

      // IF WILAYA NULL
      else{

        if(price != null){

          if(date != null){
            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("days.$date", isEqualTo: true )
                .where("prix", isLessThanOrEqualTo: price ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          else{

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("prix", isLessThanOrEqualTo: price ).get()
                .then((value) async {

              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }
        }

        else{

          if(date != null){

            await FirebaseFirestore.instance.collection("salonsSearch")
                .where("days.$date", isEqualTo: true ).get()
                .then((value) async {
              if(value.docs.isNotEmpty){

                value.docs.forEach((element) async {

                  await FirebaseFirestore.instance.collection("salon").doc(element["salonID"]).get()
                      .then((salons){

                    if(salons.exists){
                      Salon data = Salon.fromJson(salons.data() as Map<String, dynamic> );
                      data.id = salons.id;
                      _listSalon.add(data);
                    }
                    notifyListeners();
                  });
                });
              }

            });
          }

          //IF DATE NULL
          else{
            await fetchSalons();
          }
        }
      }
    }

    Timer(const Duration(seconds: 1), () {isSearching= false;notifyListeners(); });

    notifyListeners();

  }


}