import 'package:firebase_storage/firebase_storage.dart';

final storage = FirebaseStorage.instance.ref();

Future<String> downLoadURL(String imageName) async {
  String downloadURL = await storage.child('categories/$imageName.jpg').getDownloadURL();
  return downloadURL;
}