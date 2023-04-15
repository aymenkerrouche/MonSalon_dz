// ignore_for_file: file_names

class Team {
  String? salonID;
  String? userID;
  String? name;

  Team(this.name, this.salonID, this.userID);

  Team.fromJson(Map<String, dynamic> json){
    salonID= json['salonID'] ?? '';
    userID= json['userID'] ?? '';
    name= json['user'] ?? '';
  }

  Map<String, dynamic> toJson() => {
    "salonID": salonID,
    "userID": userID,
    "user" : name
  };
}