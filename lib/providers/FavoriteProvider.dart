import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';

import '../models/Service.dart';

class FavoriteProvider extends ChangeNotifier {

  List<Salon> mesSalon = [];

  bool orderByRate = false;


  static const int _limit = 10;
  String favoriteError = '';
  bool hasMore = true;
  DocumentSnapshot? lastDocument;
  bool isRefreshing = false;
  bool isLoading = false;

  clear(){
    mesSalon.clear();
    lastDocument = null;
    hasMore = true;
    isRefreshing = false;
    isLoading = false;
    notifyListeners();
  }

  order(){
    if(!orderByRate){
      mesSalon.sort((a, b) => a.rate!.compareTo(b.rate!));
      orderByRate = true;
    }
    else{
      mesSalon.sort((a, b) => b.rate!.compareTo(a.rate!));
      orderByRate = false;
    }

    notifyListeners();
  }

  Future<void> getFavoriteList() async {
    QuerySnapshot? documentList;

    if (FirebaseAuth.instance.currentUser != null) {

      List<String> salonsID = [];
      if (mesSalon.isEmpty) {
        isRefreshing = true;
        await FirebaseFirestore.instance.collection("favorites")
            .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .limit(_limit)
            .get()
        .then((value) {
          documentList = value;
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              salonsID.add(element.get("salonID"));
            }
          }
        });
        isRefreshing = false;
      }

      else {
        isLoading= true;
        await FirebaseFirestore.instance.collection("favorites")
            .where("userID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .startAfterDocument(lastDocument!)
            .limit(_limit)
            .get()
        .then((value) {
          documentList = value;
          if (value.docs.isNotEmpty) {
            for (var element in value.docs) {
              salonsID.add(element.get("salonID"));
            }
          }
        });
      }

      if( documentList != null && documentList!.docs.isNotEmpty){
        lastDocument = documentList!.docs[documentList!.docs.length - 1];
        if (documentList!.docs.length < _limit) {
          hasMore = false;
        }
      }

      if(salonsID.isNotEmpty){
        await FirebaseFirestore.instance.collection("salon").where(FieldPath.documentId,whereIn: salonsID)
            .limit(_limit)
            .get()
        .then((snapshot){
          for (var element in snapshot.docs) {
            Salon data = Salon.fromJson(element.data());
            data.id = element.id;
            mesSalon.add(data);
          }
        })
        .catchError((e){
          favoriteError = e.toString();
          debugPrint("$favoriteError ==========");
        });

        try{
          await FirebaseFirestore.instance.collection("services")
              .where("salonID", whereIn: salonsID)
              .get()
          .then((snapshot) async {
            if(snapshot.docs.isNotEmpty){
              for (var element in snapshot.docs) {
                Service service =  Service.fromJson(element.data());
                mesSalon.where((salon) => salon.id == service.salonID).first.service.add(service);
              }
            }
          });
        }
        catch(e){print(e);}

      }
    }
    isRefreshing= false;
    isLoading= false;
    notifyListeners();
  }

}