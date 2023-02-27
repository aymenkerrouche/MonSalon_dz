class Service {
  String? id;
  String? service;
  String? category;
  String? categoryID;
  String? salonID;

  Service(this.id,this.service,this.category,this.categoryID,this.salonID);

  Service.fromJson(Map<String, dynamic> json){
    category = json['category'] ?? '';
    service = json['service'] ?? '';
    categoryID= json['categoryID'] ?? '';
    salonID= json['salonID'] ?? '';
  }
}