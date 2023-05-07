import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';
import 'package:monsalondz/models/Service.dart';
import '../models/Comment.dart';
import '../models/Hours.dart';
import '../models/RendezVous.dart';
import '../models/Team.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SalonProvider extends ChangeNotifier {

  List<String> _images = [];
  List<String> get images => _images;
  Salon? salon;
  bool search = false;

  // IMAGE

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


  // STATISTIQUES

  Future<void> incrVU(String id) async {
    await FirebaseFirestore.instance.collection("statistics").doc(id).update({
      "vuTotal": FieldValue.increment(1),
      "vu${DateTime.now().year}.${DateTime.now().month}" : FieldValue.increment(1),
    }).catchError((e) async {
      await FirebaseFirestore.instance.collection("statistics").doc(id).set({
        "vuTotal": FieldValue.increment(1),
        "vu${DateTime.now().year}" : {"${DateTime.now().month}":FieldValue.increment(1)},
      });
    });
  }

  Future<void> incrJaime(String id) async {
    await FirebaseFirestore.instance.collection("statistics").doc(id).update({
      "favorites": FieldValue.increment(1),
    });
  }

  Future<void> DecriJaime(String id) async {
    await FirebaseFirestore.instance.collection("statistics").doc(id).update({
      "favorites": FieldValue.increment(-1),
    });
  }

  Future<void> incrMaps(String id) async {
    await FirebaseFirestore.instance.collection("statistics").doc(id).update({
      "mapsTotal": FieldValue.increment(1),
      "maps${DateTime.now().year}.${DateTime.now().month}" : FieldValue.increment(1),
    });
  }

  Future<void> incrTlpn(String id) async {
    await FirebaseFirestore.instance.collection("statistics").doc(id).update({
      "tlpnTotal": FieldValue.increment(1),
      "tlpn${DateTime.now().year}.${DateTime.now().month}" : FieldValue.increment(1),
    });
  }



  // SET SALON
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
    await incrVU(newSalon.id!);
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


  // GET SALON INFORMATIONS

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
            service.id = element.id;
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


  // FAVORITES

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
    await DecriJaime(salon!.id!);
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
    await incrJaime(salon!.id!);
  }




  // RDV LIST
  List<RendezVous> listRDV = [];
  List<RendezVous> listDemandes = [];
  bool done = false;

  Future<void> getDemandes(context) async {
    listDemandes.clear();
    done = false;
    await FirebaseFirestore.instance.collection("rdv")
        .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("etat",isEqualTo: 0)
        .where("date2", isGreaterThanOrEqualTo: DateTime.now()).orderBy("date2")
        .get().then((snapshot){
      if(snapshot.docs.isNotEmpty){
        for (var element in snapshot.docs) {
          RendezVous rdv = RendezVous.fromJson(element.data());
          rdv.id = element.id;
          if(element.data()["service"] != null){
            for (var srv in element.data()["service"]) {
              rdv.services.add(Service.fromJson(srv));
            }
          }
          listDemandes.add(rdv);
          notifyListeners();
        }
      }
    })
    .catchError((onError){
      debugPrint(onError.toString());
      done = false;
      final snackBar = SnackBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        behavior: SnackBarBehavior.floating,
        content: Text(
          onError.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
    });
    done = true;
    notifyListeners();
  }

  Future<void> deleteDemande(String salonID,String rdvID,BuildContext context) async {
    try{
      await FirebaseFirestore.instance.collection("rdv").doc(rdvID).update({
        "etat": -1,
      });
      listDemandes.removeWhere((element) => element.id == rdvID);
      await getUserToken(salonID,rdvID,"Le client(e) ${FirebaseAuth.instance.currentUser?.displayName} a annulé son rendez-vous","Rendez-vous annulé");
    }
    catch(e){
      debugPrint(e.toString());
      final snackBar = SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    notifyListeners();
  }



  Future<void> getRDV(context) async {
    listRDV.clear();
    done = false;
    await FirebaseFirestore.instance.collection("rdv")
        .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("etat",isEqualTo: 1)
        .where("date2", isGreaterThanOrEqualTo: DateTime.now()).orderBy("date2")
        .get().then((snapshot){
      if(snapshot.docs.isNotEmpty){
        for (var element in snapshot.docs) {
          RendezVous rdv = RendezVous.fromJson(element.data());
          rdv.id = element.id;
          if(element.data()["service"] != null){
            for (var srv in element.data()["service"]) {
              rdv.services.add(Service.fromJson(srv));
            }
          }
          listRDV.add(rdv);
          notifyListeners();
        }
      }
    })
    .catchError((onError){
      debugPrint(onError.toString());
      done = false;
      final snackBar = SnackBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        behavior: SnackBarBehavior.floating,
        content: Text(
          onError.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      notifyListeners();
    });
    done = true;
    notifyListeners();
  }

  Future<void> deleteRDV(String rdvID, String salonID,context) async {
    try{
      await FirebaseFirestore.instance.collection("statistics").doc(salonID).update({
        "rdv${DateTime.now().year}.${DateTime.now().month}done":FieldValue.increment(-1),
        "rdvDone":FieldValue.increment(-1),
      });
      await FirebaseFirestore.instance.collection("rdv").doc(rdvID).update({
        "etat": 2,
      });
      listRDV.removeWhere((element) => element.id == rdvID);
      await getUserToken(salonID,rdvID,"Nous sommes désolés de vous informer que le client(e) ${FirebaseAuth.instance.currentUser?.displayName} a annulé le rendez-vous .","Rendez-vous annulé");
    }
    catch(onError){
      final snackBar = SnackBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        behavior: SnackBarBehavior.floating,
        content: Text(
          onError.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      debugPrint(onError.toString());
    }
    notifyListeners();
  }

  Future<void> terminerRDV(String rdvID,String salonID,context) async {
    try{
      await FirebaseFirestore.instance.collection("rdv").doc(rdvID).update({
        "etat": 3,
      });
      listDemandes.removeWhere((element) => element.id == rdvID);
      await getUserToken(salonID,rdvID,"Nous souhaitons que vous ayez eu une expérience formidable, Notez le salon et laissez un commentaire","Rendez-vous terminé");
    }
    catch(e){
      debugPrint(e.toString());
      final snackBar = SnackBar(
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
        content: Text(
          e.toString(),
          style: const TextStyle(color: Colors.white),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    notifyListeners();
  }



  getUserToken(String userID, String rdvID,String body, String title) async {
    await FirebaseFirestore.instance.collection("salon").doc(userID).get().then((value) async {
      if(value.exists){
        if(value.data()!.isNotEmpty){
          await sendPushMessage(value.get("token"),rdvID,userID,body,title);
        }
      }
    });
  }

  Future<void> sendPushMessage(String token, String rdvID, String userID, String body, String title) async {
    String serverToken = "AAAA_zv9Bzo:APA91bFHW72_Q55L2tgImKoSrFUDWRI9NAmftCmsKiB2SLpJ1IJ5JV8rbxuXLj32E9a0Xx_YvaQV2c7FaPkZaNsiYhkTCznakDolzHoDV7MW-_OJarNiSNhwHD2BhgdO1VOFcj_WRAxB";
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': rdvID,
              "userID" : userID
            },
            "to": token,
          },
        ),
      );
    } catch (e) {
      debugPrint('error push notification');
    }
  }

}