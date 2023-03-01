
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../models/Category.dart';
import '../models/Pub.dart';
import '../models/Salon.dart';
import '../models/Service.dart';
import '../utils/constants.dart';

class CategoriesProvider extends ChangeNotifier {

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Salon> _populars = [];
  List<Salon> get populars => _populars;

  List<Pub> _pubs = [];
  List<Pub> get pubs => _pubs;

  Category _selectedCat = Category('', '', '');
  Category get selectedCat => _selectedCat;

  String categoriesError = '';
  bool done = false;

  String pubsError = '';
  bool ads = false;

  final storage = FirebaseStorage.instance.ref();

  set selectedCat(Category cat){
    _selectedCat = cat;
    notifyListeners();
  }

  Future getCategories() async {
    _categories.clear();
    done = false;
    await FirebaseFirestore.instance.collection("categories").orderBy('category').get().then((snapshot){
       for (var element in snapshot.docs) {
          Category data = Category.fromJson(element.data());
          data.id = element.id;
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









  Future getPopularSalons() async {

    _populars.clear();

    await FirebaseFirestore.instance.collection('salon').where('best', isEqualTo: true).limit(10).get().then((snapshot) async {
      for (var element in snapshot.docs) {
        Salon data = Salon.fromJson(element.data());
        data.id = element.id;
        _populars.add(data);
      }
    })
    .catchError((e){
      pubsError = e.toString();
    });

    if(_populars.isEmpty){
      await FirebaseFirestore.instance.collection('salon').orderBy("rate").limit(5).get().then((snapshot) async {
        for (var element in snapshot.docs) {

          Salon data = Salon.fromJson(element.data());
          data.id = element.id;
          _populars.add(data);

        }
      })
      .catchError((e){
        pubsError = e.toString();
      });
    }

    List<String> listID = [];
    _populars.forEach((element) {
      listID.add(element.id!);
    });

    try{
      await FirebaseFirestore.instance.collection("services")
          .where("salonID", whereIn: listID)
          .get()
          .then((snapshot) async {

        if(snapshot.docs.isNotEmpty){
          for (var element in snapshot.docs) {
            Service service =  Service.fromJson(element.data());
            _populars.where((element) => element.id == service.salonID).first.service.add(service);
          }
        }
      });
    }
    catch(e){print(e);}

    notifyListeners();
  }
}