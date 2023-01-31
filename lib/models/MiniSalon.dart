// ignore_for_file: file_names

class MiniSalon {
  late String id;
  late String nom;
  late String wilaya;
  late bool best;
  late String photo;
  late bool promo;
  late double rate;

  MiniSalon(this.nom, this.wilaya, this.best, this.promo,this.rate,this.photo, this.id);

  MiniSalon.fromJson(Map<String, dynamic> json){
    id= json['id'] ?? '';
    nom = json['nom'] ?? '';
    wilaya = json['wilaya'] ?? '';
    best = json['best'] ?? '';
    promo = json['promo'] ?? '';
  }
}