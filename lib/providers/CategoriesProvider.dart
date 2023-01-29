
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../services/Storage.dart';

class CategoriesProvider extends ChangeNotifier {

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  String categoriesError = '';
  bool done = false;

  Future getCategories() async {
    _categories.clear();
    await FirebaseFirestore.instance.collection("categories").orderBy('category').get().then((snapshot){
       for (var element in snapshot.docs) {
          Category data = Category.fromJson(element.data());
          _categories.add(data);
       }
    })
    .catchError((e){
      categoriesError = e.toString();
    });
    notifyListeners();
  }

  Future getCategoriesPhotos() async {
    for( int i=0; i < categories.length ; i++ ){
      _categories[i].photo = await downLoadURL(_categories[i].category);
    }
    done = true;
    notifyListeners();
  }
}