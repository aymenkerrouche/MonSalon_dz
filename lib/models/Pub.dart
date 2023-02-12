class Pub {
  String? id;
  int? index;
  int? jours;
  String? nom;
  String? lien;
  bool? pay;
  String? start;
  String? fin;
  bool? show;
  String photo = '';

  Pub( this.id, this.show ,this.index, this.jours, this.nom,this.lien,this.pay, this.start, this.fin, this.photo);

  Pub.fromJson(Map<dynamic, dynamic> json){
    index = json['index'] ?? 0;
    nom = json['nom'] ?? '';
    jours = json['jours'] ?? -1;
    lien = json['lien'] ?? '';
    pay = json['pay'] ?? true ;
    start = json['start'] ?? '';
    fin = json['fin'] ?? '';
    show = json['show'] ?? true;
  }
}