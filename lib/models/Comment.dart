class Comment {
  String? id;
  String? comment;
  String? userID;
  String? salonID;
  String? name;
  double? rate;

  Comment(this.id, this.comment, this.userID, this.salonID,this.rate, this.name);

  Comment.fromJson(Map<dynamic, dynamic> json){
    comment = json['comment'] ?? '';
    userID = json['userID'] ?? '';
    salonID = json['salonID'] ?? '';
    rate = json['rate'] == null ? 5.0 : json['rate'].toDouble();
    name = json['name'] ?? '';
  }

  Map<dynamic, dynamic> toJson() => {
    "comment" : comment,
    "userID" : userID,
    "salonID" : salonID,
    "rate" : rate,
    'name': name,
  };
}