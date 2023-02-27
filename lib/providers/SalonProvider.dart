import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Category.dart';
import 'package:monsalondz/models/Salon.dart';
import 'package:monsalondz/models/Service.dart';
import '../models/Hours.dart';
import '../models/Team.dart';

class SalonProvider extends ChangeNotifier {

  List<String> _images = [];
  List<String> get images => _images;

  Future<void> getSalonImages(String id) async {
    try{
      ListResult listResult = await FirebaseStorage.instance.ref().child('salons/$id').listAll();
      listResult.items.forEach((element) async {
        try{
          String image = await FirebaseStorage.instance.ref().child(element.fullPath).getDownloadURL();
          images.add(image);
          notifyListeners();
        }
        catch(ee){print(ee);}
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }
  clearImages(){
    images.clear();
    notifyListeners();
  }

  Salon? salon;
  bool done = false;

  Future<void> setSalon(Salon newSalon) async {
    salon = newSalon ;
    notifyListeners();
    await getSalonImages(salon!.id!);
    await getCategories();
    await getHours();
    await getServices();
    if(newSalon.team == true)await getTeam();
    notifyListeners();
  }

  clearSalon(){
    salon = null;
    clearImages();
    notifyListeners();
  }

  Future<void> getHours() async {
    try{
      await FirebaseFirestore.instance.collection("hours").where("salonID", isEqualTo: salon?.id ).limit(1).get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          Hours data = Hours.fromJson(snapshot.docs.first.data());
          salon?.hours = data;
        }
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<void> getCategories() async {
    try{
      await FirebaseFirestore.instance.collection("salonsSearch").where("salonID", isEqualTo: salon?.id ).limit(1).get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          for (var element in snapshot.docs.first.data()["category"]) {
            salon?.categories.add(element);
          }
        }
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  Future<void> getServices() async {
    if(salon!.categories.isNotEmpty){

      try{
        await FirebaseFirestore.instance.collection("services").where("categoryID", whereIn: salon!.categories).get()
            .then((snapshot) async {
          if(snapshot.docs.isNotEmpty){
            for (var element in snapshot.docs) {
              Service service =  Service.fromJson(element.data());
              salon?.service.add(service);
            }
          }
        });
      }
      catch(e){print(e);}


      try{
        await FirebaseFirestore.instance.collection("services")
            .where("salonID", isEqualTo: salon?.id)
            .where("categoryID", whereNotIn: salon!.categories)
            .get()
            .then((snapshot) async {
          if(snapshot.docs.isNotEmpty){
            for (var element in snapshot.docs) {
              Service service =  Service.fromJson(element.data());
              salon?.service.add(service);
            }
          }
        });
      }
      catch(e){print(e);}
    }
    else{
      try{
        await FirebaseFirestore.instance.collection("services")
            .where("salonID", isEqualTo: salon?.id)
            .get()
            .then((snapshot) async {
          if(snapshot.docs.isNotEmpty){
            for (var element in snapshot.docs) {
              Service service =  Service.fromJson(element.data());
              salon?.service.add(service);
            }
          }
        });
      }
      catch(e){print(e);}
    }
    notifyListeners();
  }

  Future<void> getTeam() async {
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
}