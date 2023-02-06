
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../models/Pub.dart';
import '../utils/constants.dart';

class CategoriesProvider extends ChangeNotifier {

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Pub> _pubs = [];
  List<Pub> get pubs => _pubs;

  String categoriesError = '';
  bool done = false;
  String pubsError = '';
  bool ads = false;

  final storage = FirebaseStorage.instance.ref();

  Future getCategories() async {
    _categories.clear();
    done = false;
    await FirebaseFirestore.instance.collection("categories").orderBy('category').get().then((snapshot){
       for (var element in snapshot.docs) {
          Category data = Category.fromJson(element.data());
          _categories.add(data);
       }
    })
    .catchError((e){
      done = false;
      categoriesError = e.toString();
    });
    notifyListeners();
  }

  Future getPubs() async {

    _pubs.clear();
    ads = false;

    await FirebaseFirestore.instance.collection('pubs').orderBy('index').get().then((snapshot) async {

      for (var element in snapshot.docs) {

        Pub data = Pub.fromJson(element.data());
        data.id = element.id;

        try{
          data.photo = await storage.child('pubs/${element.id}.jpg').getDownloadURL();
        }
        catch(e){
          ads = false;
          data.photo = '';
        }

        _pubs.add(data);

      }
    })
    .catchError((e){
      pubsError = e.toString();
    });

    if(_pubs.isEmpty){
      _pubs.add(localPub);
    }
    notifyListeners();
  }

  Future getCategoriesPhotos() async {
    for( int i=0; i < categories.length ; i++ ) {
      try{
      _categories[i].photo = await storage.child('categories/${_categories[i].category}.jpg').getDownloadURL();
      }
      catch(e){
        categoriesError = e.toString();
      }
    }
    for( int i=0; i < categories.length ; i++ ) {
      if(_categories[i].photo == ''){
        _categories.removeAt(i);
      }
    }
    done = true;
    notifyListeners();
  }
}