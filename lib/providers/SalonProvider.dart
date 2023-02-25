

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class SalonProvider extends ChangeNotifier {

  List<String> _images = [];
  List<String> get images => _images;

  Future<void> getSalonImages(String id) async {
    try{
      ListResult listResult = await FirebaseStorage.instance.ref().child('salons/$id').listAll();
      listResult.items.forEach((element) async {
        try{
          String image = await FirebaseStorage.instance.ref().child(element.fullPath).getDownloadURL();
          images.add(image);
          notifyListeners();
        }
        catch(ee){}
      });
    }
    catch(e){print(e);}
    notifyListeners();
  }

  clearImages(){
    images.clear();
    notifyListeners();
  }
}