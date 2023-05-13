import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:monsalondz/models/Hours.dart';
import 'package:monsalondz/models/RendezVous.dart';
import '../models/Salon.dart';
import 'package:intl/intl.dart';
import '../models/Service.dart';
import '../utils/constants.dart';

/* ETAT
  0 en attente
  1 accepté
  2 annulé
  3 terminé
  -1 refusé
  -2 litige
  */

class RDVProvider extends ChangeNotifier {
  RendezVous? _rendezVous;
  RendezVous? get rendezVous => _rendezVous;

  set rendezVous(RendezVous? newrdv) {
    _rendezVous = newrdv;
    notifyListeners();
  }

  List<String> heures = [];
  List<String> heuresSHIMER = [
    '10:00',
    '10:30',
    '11:00',
    '11:30',
    '12:00',
    '12:30',
    '13:00',
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00'
  ];

  String _selectedHour = '';
  String get selectedHour => _selectedHour;
  set selectedHour(String heure) {
    _selectedHour = heure;
    _rendezVous?.hour = _selectedHour;
    String dateTemp = _rendezVous!.date!.split(" ").last;
    DateTime date2 = DateFormat('dd-MM-yyyy, HH:mm').parse('$dateTemp, $heure');
    _rendezVous?.date2 = Timestamp.fromDate(date2);
    notifyListeners();
  }

  String _selectedDay = 'Selectionnez une date';
  String get selectedDay => _selectedDay;
  set selectedDay(String day) {
    _selectedDay = day;
    _rendezVous?.date = day;
    notifyListeners();
  }

  getHours(DateTime pickedDay, Hours hours) {
    heures.clear();
    _selectedHour = '';

    String start = hours.jours[weekdayName[pickedDay.weekday]]["start"];
    String end = hours.jours[weekdayName[pickedDay.weekday]]["fin"];

    DateTime dateTimeStart = dateFormat
        .parse("${DateFormat("dd-MM-yyyy").format(pickedDay)} $start");
    DateTime dateTimeEnd =
        dateFormat.parse("${DateFormat("dd-MM-yyyy").format(pickedDay)} $end");
    DateTime dateTimeTemp = dateTimeStart;

    while (dateTimeTemp.isBefore(dateTimeEnd)) {
      heures.add(DateFormat.Hm().format(dateTimeTemp));
      dateTimeTemp = dateTimeTemp.add(const Duration(minutes: 30));
    }

    notifyListeners();
  }

  calcPrix() {
    int prix = 0;
    int prixFin = 0;
    for (var element in _rendezVous!.services) {
      prix += element.prix!;
      prixFin += element.prixFin == 0 ? element.prix! : element.prixFin!;
    }
    _rendezVous?.prix = prix;
    _rendezVous?.prixFin = prixFin;
    notifyListeners();
  }

  clear() {
    _selectedHour = '';
    _selectedDay = "Selectionnez une date";
    heures.clear();
    _rendezVous = RendezVous.fromJson({});
    notifyListeners();
  }

  fillRDV(Salon salon, String phone, List<Service> services, teamController) {
    _rendezVous?.salon = salon.nom;
    _rendezVous?.services = services;
    _rendezVous?.location = salon.location;
    _rendezVous?.salonID = salon.id;
    _rendezVous?.userID = FirebaseAuth.instance.currentUser?.uid;
    _rendezVous?.user = FirebaseAuth.instance.currentUser?.displayName;
    _rendezVous?.userPhone = phone;
    _rendezVous?.remise = salon.remise;
    if (salon.promo == true) _rendezVous?.remise = salon.remise;
    if (salon.teams.isNotEmpty) {
      if(teamController.selectedItem.name != "N'importe qui"){
        _rendezVous?.team = true;
        _rendezVous?.teamInfo = teamController.selectedItem;
      }
    }
    else {
      _rendezVous?.team = false;
      _rendezVous?.teamInfo = null;
    }
    notifyListeners();
  }

/*  Future<bool> createRDV() async {
    Map<String, dynamic> json = _rendezVous!.toJson();
    try {
      await FirebaseFirestore.instance
          .collection("rdv")
          .add(json)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("statistics")
            .doc(_rendezVous?.salonID)
            .update({
          "rdvTotal": FieldValue.increment(1),
          "rdv${DateTime.now().year}.${DateTime.now().month}":
              FieldValue.increment(1)
        });
        if (_rendezVous!.services.isNotEmpty) {
          for (var element in _rendezVous!.services) {
            await FirebaseFirestore.instance
                .collection("statistics")
                .doc(_rendezVous?.salonID)
                .update({
              "services.${element.service}": FieldValue.increment(1),
            });
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }*/

  Future<bool> createRDV() async {
    Map<String, dynamic> json = _rendezVous!.toJson();
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // Add appointment to Firestore with server timestamp
    DocumentReference appointmentRef = FirebaseFirestore.instance.collection("rdv").doc();
    json['createdAt'] = FieldValue.serverTimestamp();
    batch.set(appointmentRef, json);

    // Update salon statistics
    DocumentReference salonStatsRef = FirebaseFirestore.instance.collection("statistics").doc(_rendezVous!.salonID);
    batch.update(salonStatsRef, {
      "rdvTotal": FieldValue.increment(1),
      "rdv${DateTime.now().year}.${DateTime.now().month}": FieldValue.increment(1),
    });

    // Update service statistics (if any)
    if (_rendezVous!.services.isNotEmpty) {
      for (var element in _rendezVous!.services) {
        batch.update(salonStatsRef, {
          "services.${element.service}": FieldValue.increment(1),
        });
      }
    }

    // Commit the batch write
    try {
      await batch.commit();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }


}
