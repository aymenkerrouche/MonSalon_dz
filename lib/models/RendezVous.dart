import 'package:monsalondz/models/Service.dart';

class RendezVous {
  String? id;
  String? date;
  String? hour;
  int? etat;
  String? salonID;
  String? salon;
  String? userID;
  String? user;
  int? duree;
  int? prix;
  int? prixFin;
  String? comment;
  int? remise;
  bool? team;
  String? teamID;
  String? teamName;
  List<String> servicesID = [];
  List<Service> services = [];
  String? location;
  String? userPhone;

  RendezVous(this.id, this.team, this.prixFin,this.userPhone,this.location,this.servicesID,this.teamID,this.teamName,this.comment, this.date, this.remise,this.salonID,this.hour, this.etat, this.salon, this.user, this.userID,this.duree, this.prix);

  RendezVous.fromJson(Map<String, dynamic> json){
    userID = json['userID'] ?? '';
    salonID = json['salonID'] ?? '';
    date = json['date'] ?? '';
    hour = json['hour'] ?? '';
    etat = json["etat"] ??  0 ;
    salon = json["salon"] ??  '' ;
    user = json["user"] ??  '' ;
    duree = json["duree"] ??  30 ;
    prix = json["prix"] ??  0 ;
    remise = json["remise"] ??  0 ;
    comment = json['comment'] ?? '';
    team = json['team'] ?? false;
    teamID = json['teamID'] ?? '';
    teamName = json['teamName'] ?? '';
    servicesID = json['servicesID'] ?? [];
    location = json['location'] ?? '';
    userPhone = json['userPhone'] ?? '';
    prixFin = json["prixFin"] ?? 0 ;
  }

  Map<String, dynamic> toJson() => {
    "userID": userID,
    "salonID": salonID,
    "date": date,
    "hour": hour,
    "etat": etat,
    "salon": salon,
    "user": user,
    "duree": duree,
    "prix": prix,
    "remise": remise,
    "comment": comment,
    "team":team,
    "teamID":teamID,
    "teamName":teamName,
    "servicesID" : servicesID,
    "location" : location,
    "userPhone" : userPhone,
    "prixFin" : prixFin
  };
}