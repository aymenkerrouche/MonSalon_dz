// ignore_for_file: file_names

class Salon {
  String? id;
  String? nom;
  String? wilaya;
  bool? best;
  String? photo;
  bool? promo;
  double rate = 5;
  double? latitude;
  double? longitude;
  String? location;
  String? description;

  Salon(
      this.nom, this.wilaya, this.best, this.promo,this.rate,this.photo, this.id,
      this.description,
      this.latitude,
      this.longitude,this.location
  );

  Salon.fromJson(Map<String, dynamic> json){
    id= json['id'] ?? '';
    nom = json['nom'] ?? '';
    wilaya = json['wilaya'] ?? '';
    best = json['best'] ?? false;
    promo = json['promo'] ?? false;
    photo = json['lien'] ?? '';
    description  = json['description'] ?? '';
    latitude = json['latitude'] ?? 0;
    longitude = json['longitude'] ?? 0;
    location  = json['location'] ?? '';
    //  = json[''] ?? ;
  }
}