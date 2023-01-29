// ignore_for_file: file_names

class MiniOffer {
  late String nom;
  late String wilaya;
  late bool best;
  late String photo;
  late bool promo;

  MiniOffer(this.nom, this.wilaya, this.best, this.promo);

  MiniOffer.fromJson(Map<String, dynamic> json){
    nom = json['nom'];
    wilaya = json['wilaya'];
    best = json['best'];
    promo = json['promo'];
  }
}