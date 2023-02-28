import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
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

  Salon? salon;
  bool search = false;

  Future<void> setSalon(Salon newSalon) async {
    salon = null;
    search = true;
    salon = newSalon ;
    await getSalonImages(salon!.id!);
    await getHours();
    await getServices();
    if(newSalon.team == true)await getTeam();
    search = false;
    notifyListeners();
  }

  clearSalon(){
    salon?.service.clear();
    salon?.categories.clear();
    salon?.teams.clear();
    salon = null;
    images.clear();
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

  Future<void> getServices() async {
    try{
      await FirebaseFirestore.instance.collection("services")
      //.where("categoryID", whereIn: salon!.categories)
          .where("salonID", isEqualTo: salon?.id)
          .get()
      .then((snapshot) async {
        if(snapshot.docs.isNotEmpty){
          for (var element in snapshot.docs) {
            print(element.data());
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