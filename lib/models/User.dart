// ignore_for_file: file_names

class User {
  late String id;
  late String userName;
  late double userPassword;
  late int phone;
  late String email;

  User(this.id, this.userName, this.userPassword, this.phone, this.email);

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    userPassword = json['userPassword'];
    phone = json['phone'];
    email = json['email'];
  }
}
