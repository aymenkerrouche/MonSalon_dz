// ignore_for_file: file_names

class Hours {
  String? id;
  Map<String, dynamic>? dimanche;
  Map<String, dynamic>? lundi;
  Map<String, dynamic>? mardi;
  Map<String, dynamic>? mercredi;
  Map<String, dynamic>? jeudi;
  Map<String, dynamic>? vendredi;
  Map<String, dynamic>? samedi;
  

  Hours(this.dimanche, this.lundi, this.mardi, this.mercredi,this.jeudi,this.vendredi, this.id, this.samedi,);

  Hours.fromJson(Map<String, dynamic> json){
    id= json['salonID'] ?? '';
    dimanche = json['dimanche'] ?? {};
    lundi = json['lundi'] ?? {};
    mardi = json['mardi'] ?? {};
    mercredi = json['mercredi'] ?? {};
    jeudi = json['jeudi'] ?? {};
    vendredi  = json['vendredi'] ?? {};
    samedi  = json['samedi'] ?? {};
  }
}