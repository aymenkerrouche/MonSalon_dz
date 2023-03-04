import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';
import 'package:monsalondz/models/Service.dart';
import '../models/Comment.dart';
import '../models/Hours.dart';
import '../models/Team.dart';

class SalonProvider extends ChangeNotifier {

  List<String> _images = [];
  List<String> get images => _images;
  Salon? salon;
  bool search = false;

  Future<void> getSalonImages(String id) async {
    try{
      ListResult listResult = await FirebaseStorage.instance.ref().child('salons/$id').listAll();
      for (var element in listResult.items){
        try{
          String image = await FirebaseStorage.instance.ref().child(element.fullPath).getDownloadURL();
          images.add(image);
          //notifyListeners();
        }
        catch(ee){print("====== $ee =======");}
      }
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<void> setSalon(Salon newSalon) async {
    search = true;
    salon = newSalon ;
    await getSalonImages(salon!.id!);
    await getHours();
    await getServices();
    await getCommments();
    if(newSalon.team == true)await getTeam();
    await checkFavorite();
    search = false;
    notifyListeners();
  }

  clearSalon(){
    salon?.categories.clear();
    salon?.teams.clear();
    salon?.comments.clear();
    salon?.isFavorite["like"] = false;
    salon = null;
    images.clear();
    notifyListeners();
  }

  Future<void> getHours() async {
    //salon?.hours?.jours.clear();
    try{
      await FirebaseFirestore.instance.collection("hours").where("salonID", isEqualTo: salon?.id ).limit(1).get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          Hours hour = Hours.fromJson(snapshot.docs.first.data());
          salon?.hours = hour;
        }
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<void> getServices() async {
    salon!.service.clear();
    try{
      await FirebaseFirestore.instance.collection("services")
          .where("salonID", isEqualTo: salon?.id)
          .get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          for (var element in snapshot.docs) {
            Service service =  Service.fromJson(element.data());
            salon?.service.add(service);
            if(!salon!.categories.contains(service.category)){
              salon?.categories.add(service.category!);
            }
          }
        }
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<void> getTeam() async {
    salon!.teams.clear();
    if(salon!.team){
      try{
        await FirebaseFirestore.instance.collection("team").where("salonID", isEqualTo: salon?.id ).get()
        .then((snapshot) async {
          if(snapshot.docs.isNotEmpty){
            for (var element in snapshot.docs) {
              Team team = Team.fromJson(element.data());
              salon?.teams.add(team);
            }
          }
        });
      }
      catch(e){print(e);}
      notifyListeners();
    }
  }

  Future<void> getCommments() async {
    salon?.comments.clear();
    try{
      await FirebaseFirestore.instance.collection("notes")
          .where("salonID", isEqualTo: salon?.id )
          .orderBy("rate",descending: true)
          .limit(5)
          .get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          for (var element in snapshot.docs) {
            Comment comment = Comment.fromJson(element.data());
            comment.id = element.id;
            salon?.comments.add(comment);
          }
        }
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<bool> checkFavorite() async {
    if(FirebaseAuth.instance.currentUser != null){
      await FirebaseFirestore.instance.collection("favorites")
        .where("salonID", isEqualTo: salon?.id )
        .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid).limit(1)
        .get()
      .then((value){
        if(value.docs.isNotEmpty){
          salon?.isFavorite["id"] = value.docs.first.id;
          salon?.isFavorite["like"] = true;
        }
        else{
          salon?.isFavorite["id"] = "";
          salon?.isFavorite["like"] = false;
        }
      });
    }
    notifyListeners();
    return salon?.isFavorite["like"];
  }

  Future<void> disLikeSalon() async {
    await FirebaseFirestore.instance.collection("favorites").doc(salon?.isFavorite["id"]).delete()
    .then((value){
      salon?.isFavorite["id"] = "";
      salon?.isFavorite["like"] = false;
    });

    notifyListeners();
  }

  Future<void> likeSalon() async {
    await FirebaseFirestore.instance.collection("favorites").add({
      "salonID":salon?.id,
      "userID":FirebaseAuth.instance.currentUser?.uid
    })
    .then((value){
      salon?.isFavorite["id"] = value.id;
      salon?.isFavorite["like"] = true;
    });
    notifyListeners();
  }


}