import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Salon.dart';
import 'package:monsalondz/models/Service.dart';
import 'package:monsalondz/widgets/SnaKeBar.dart';
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
    _images.clear();
    try{
      ListResult listResult = await FirebaseStorage.instance.ref().child('salons/$id').listAll();
      for (var element in listResult.items){
        try{
          String image = await FirebaseStorage.instance.ref().child(element.fullPath).getDownloadURL();
          images.add(image);
          notifyListeners();
        }
        catch(ee){print("====== $ee =======");}
      }
    }
    catch(e){print(e);}
    notifyListeners();
  }


  // STATISTIQUES
  Future<void> incrVU(String id) async {

    final statisticsDoc = FirebaseFirestore.instance.collection("statistics").doc(id);
    final batch = FirebaseFirestore.instance.batch();

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    batch.update(statisticsDoc, {
      "vuTotal": FieldValue.increment(1),
      "vu$currentYear.$currentMonth": FieldValue.increment(1),
    });
    try {
      await batch.commit();
    } catch (e) {
      print("Error incrementing VU: $e");
    }
  }

  Future<void> incrMaps(String id) async {
    final statisticsDoc = FirebaseFirestore.instance.collection("statistics").doc(id);

    final batch = FirebaseFirestore.instance.batch();

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    batch.update(statisticsDoc, {
      "mapsTotal": FieldValue.increment(1),
      "maps$currentYear.$currentMonth": FieldValue.increment(1),
    });

    try {
      await batch.commit();
    } catch (e) {
      print("Error incrementing Maps: $e");
    }
  }

  Future<void> incrTlpn(String id) async {
    final statisticsDoc = FirebaseFirestore.instance.collection("statistics").doc(id);

    final batch = FirebaseFirestore.instance.batch();

    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;

    batch.update(statisticsDoc, {
      "tlpnTotal": FieldValue.increment(1),
      "tlpn$currentYear.$currentMonth": FieldValue.increment(1),
    });

    try {
      await batch.commit();
    } catch (e) {
      print("Error incrementing Tlpn: $e");
    }
  }




  // SET SALON
  Future<void> setSalon(Salon newSalon) async {
    print(DateTime.now());
    search = true;
    salon = newSalon ;
    await getSalonImages(salon!.id!);
    await getHours();
    await getServices();
    await getComments();
    if(newSalon.team == true)await getTeam();
    await checkFavorite();
    search = false;
    notifyListeners();
    await incrVU(newSalon.id!);
    print(DateTime.now());
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
    try {
      final snapshot = await FirebaseFirestore.instance.collection("hours").doc(salon?.id).get();
      if (snapshot.exists) {
        final hour = Hours.fromJson(snapshot.data()!);
        salon?.hours = hour;
      }
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> getServices() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("services")
          .where("salonID", isEqualTo: salon?.id)
          .get();

      final serviceList = <Service>[];
      final categorySet = <String>{};

      for (var element in snapshot.docs) {
        final service = Service.fromJson(element.data());
        service.id = element.id;
        serviceList.add(service);
        categorySet.add(service.category!);
      }

      salon?.service = serviceList;
      salon?.categories = categorySet.toList();
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> getTeam() async {
    if (!salon!.team) {
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("team")
          .where("salonID", isEqualTo: salon?.id)
          .get();

      final teamList = <Team>[];

      for (var element in snapshot.docs) {
        final team = Team.fromJson(element.data());
        teamList.add(team);
      }

      salon?.teams = teamList;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }

  Future<void> getComments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("notes")
          .where("salonID", isEqualTo: salon?.id)
          .orderBy("rate", descending: true)
          .limit(5)
          .get();

      final commentList = <Comment>[];

      for (var element in snapshot.docs) {
        final comment = Comment.fromJson(element.data());
        comment.id = element.id;
        commentList.add(comment);
      }

      salon?.comments = commentList;
    } catch (e) {
      print(e);
    }

    notifyListeners();
  }


  Future<void> setCommment(String comment, double rate, String salonID, String userID, String name, BuildContext context, String rdvID,) async {
    final notesCollection = FirebaseFirestore.instance.collection("notes");
    final rdvDoc = FirebaseFirestore.instance.collection("rdv").doc(rdvID);

    final batch = FirebaseFirestore.instance.batch();

    try {
      final newNoteRef = notesCollection.doc();
      batch.set(newNoteRef, {
        "comment": comment,
        "rate": rate,
        "salonID": salonID,
        "userID": userID,
        "name": name,
      });

      batch.update(rdvDoc, {
        "note": true,
      });

      await batch.commit();

      listRDV.firstWhere((element) => element.id == rdvID).note = true;
    } catch (e) {
      final snackBar = snaKeBar(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

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
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && salon != null && salon!.isFavorite["id"] != null) {
      final favoritesCollection = FirebaseFirestore.instance.collection("favorites");
      final statisticsDoc = FirebaseFirestore.instance.collection("statistics").doc(salon!.id);

      final batch = FirebaseFirestore.instance.batch();

      final favoritesId = salon!.isFavorite["id"];

      final favoritesDocRef = favoritesCollection.doc(favoritesId);

      batch.delete(favoritesDocRef);
      batch.update(statisticsDoc, {
        "favorites": FieldValue.increment(-1),
      });

      await batch.commit();

      salon!.isFavorite = {
        "id": null,
        "like": false,
      };

      notifyListeners();
    }
  }

  Future<void> likeSalon() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && salon != null) {
      final favoritesCollection = FirebaseFirestore.instance.collection("favorites");
      final statisticsDoc = FirebaseFirestore.instance.collection("statistics").doc(salon!.id);

      final favoritesData = {
        "salonID": salon!.id,
        "userID": user.uid,
      };

      final batch = FirebaseFirestore.instance.batch();

      final favoritesDocRef = favoritesCollection.doc();
      final favoritesId = favoritesDocRef.id;

      batch.set(favoritesDocRef, favoritesData);
      batch.update(statisticsDoc, {
        "favorites": FieldValue.increment(1),
      });

      await batch.commit();

      salon!.isFavorite = {
        "id": favoritesId,
        "like": true,
      };

      notifyListeners();
    }
  }





  // RDV LIST
  List<RendezVous> listRDV = [];
  List<RendezVous> listDemandes = [];

  bool done = false;

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



  Future<void> getRDV(context,chosenValue) async {
    listRDV.clear();
    done = false;

    Query<Map<String, dynamic>> query;

    switch(chosenValue) {
      case "Tous": {
        query = FirebaseFirestore.instance.collection("rdv").where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid);
      }
      break;

      case 'Prochains': {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("etat",isEqualTo: 1)
            .where("date2", isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 1))).orderBy("date2");
      }
      break;

      case 'Terminé': {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("etat",isEqualTo: 3)
            .where("date2", isLessThanOrEqualTo: DateTime.now()).orderBy("date2");
      }
      break;

      case 'Annulé': {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("etat",whereIn: [2, -1]);
      }
      break;

      case 'Récent': {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy("date2",descending: true);
      }
      break;

      case 'Ancien': {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .orderBy("date2");
      }
      break;

      case "Demandes":{
        query = FirebaseFirestore.instance.collection("rdv").where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .where("etat",isEqualTo: 0)
        .where("date2", isGreaterThanOrEqualTo: DateTime.now()).orderBy("date2");
      }
      break;

      default: {
        query = FirebaseFirestore.instance.collection("rdv")
            .where("userID",isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .where("etat",isEqualTo: 1)
            .where("date2", isGreaterThanOrEqualTo: DateTime.now().subtract(const Duration(days: 1))).orderBy("date2");
      }
      break;
    }

    await query.get().then((snapshot){
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
      final snackBar = snaKeBar(onError.toString());
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