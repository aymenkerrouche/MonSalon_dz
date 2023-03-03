class History {
  int? id;
  String? search;
  String? wilaya;
  String? category;
  String? date;
  String? day;
  String? hour;
  int? prix;

  History( this.id, this.search, this.prix,this.wilaya, this.category,this.date,this.day, this.hour);

  History.fromJson(Map<dynamic, dynamic> json){
    id= json['id'] ?? '';
    search = json['search'] ?? '';
    wilaya = json['wilaya'] ?? '';
    category = json['category'] ?? '';
    date = json['date'] ?? '';
    day = json['day'] ?? '';
    hour = json['hour'] ?? '';
    prix = json['prix'] ?? 0;
  }

  Map<dynamic, dynamic> asMap() => {
    "search" : search,
    "wilaya" : wilaya,
    "category" : category,
    "date" : date,
    "day" : day,
    "hour" : hour,
    "prix": prix,
  };
}