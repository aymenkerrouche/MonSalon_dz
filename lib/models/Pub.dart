class Pub {
  String? id;
  int? index;
  int? jours;
  String? nom;
  String? lien;
  bool? pay;
  String? start;
  String? fin;
  String photo = '';

  Pub( this.id, this.index, this.jours, this.nom,this.lien,this.pay, this.start, this.fin, this.photo);

  Pub.fromJson(Map<dynamic, dynamic> json){
    index = json['index'] ?? '';
    nom = json['nom'] ?? '';
    jours = json['jours'] ?? '';
    lien = json['lien'] ?? '';
    pay = json['pay'] ?? '';
    start = json['start'] ?? '';
    fin = json['fin'] ?? '';
  }
}