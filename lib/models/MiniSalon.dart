// ignore_for_file: file_names

class MiniSalon {
  String? id;
  String? nom;
  String? wilaya;
  bool? best;
  String? photo;
  bool? promo;
  double rate = 5;

  MiniSalon(this.nom, this.wilaya, this.best, this.promo,this.rate,this.photo, this.id);

  MiniSalon.fromJson(Map<String, dynamic> json){
    id= json['id'] ?? '';
    nom = json['nom'] ?? '';
    wilaya = json['wilaya'] ?? '';
    best = json['best'] ?? false;
    promo = json['promo'] ?? false;
    photo = json['lien'] ?? '';
  }
}