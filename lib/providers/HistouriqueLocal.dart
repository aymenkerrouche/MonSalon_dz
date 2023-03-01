import 'package:flutter/material.dart';
import 'package:monsalondz/models/History.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../main.dart';
import '../models/Salon.dart';

class HistoryProvider extends ChangeNotifier {

  List<History> _searchHistory = [];
  List<History> get searchHistory => _searchHistory;

  List<Salon> _salonsHistory = [];
  List<Salon> get salonsHistory => _salonsHistory;

  late Database _localDB ;
  Database get localDB => _localDB;

  bool _exsist = false;
  bool get exsist => _exsist;

  Future<bool> databaseExists(String path) => databaseFactory.databaseExists(path);

  Future<void> setSearchHistory(String search, String wilaya, String category, String date, String jour, String hour) async {

    _searchHistory.clear();
    int count = Sqflite.firstIntValue(await _localDB.rawQuery('SELECT COUNT(*) FROM history')) ?? 0;

    if(search != '' || wilaya != '' || category != '' || date  != '' || jour != '' || hour != ''){

      await _localDB.transaction((txn) async {
        if(count > 8) {
          await txn.rawQuery('Delete FROM history where id IN (Select id from history limit 1)');
          await txn.rawUpdate("UPDATE history SET id = id-1");
        }
        await txn.rawInsert(
          'INSERT INTO history(id,search, wilaya, category, date, day, hour) VALUES(?,?,?,?,?,?,?)',
          [count > 8 ? count : count + 1 , search, wilaya, category, date, jour, hour],
        );
      });

    }
    await loadLocalData();
    notifyListeners();
  }

  deleteHistory(int id) async {
    await _localDB.transaction((txn) async {
      await txn.rawQuery("Delete FROM history where id = '$id'");
      await txn.rawUpdate("UPDATE history SET id = id-1 where id > '$id'");
    });
    await loadLocalData();
    notifyListeners();
  }

  setSalonsHistory(Salon salon) {
    if(_salonsHistory.length > 10){
      _salonsHistory.removeAt(9);
      _salonsHistory.insert(0, salon);
    }
    else{
      _salonsHistory.insert(0, salon);
    }
    notifyListeners();
  }

  // InitDB
  initLocalDB() async {
    if(prefs?.getString('path') != null) {
      _localDB = await createOrOpenLocalDB(prefs?.getString('db_database')).catchError((e){print(e);});
      await loadLocalData();
    }
    else{
      await prefs?.setString('db_database', 'monSalon');
      _localDB = await createOrOpenLocalDB(prefs?.getString('db_database'));
    }
    notifyListeners();
  }

  // Load from DB
  Future<void> loadLocalData() async {
    List<Map> history = await _localDB.rawQuery("SELECT * FROM history ORDER BY id");
    if(history.isNotEmpty){
      _searchHistory.clear();
      for(Map hist in history){
        _searchHistory.add(History.fromJson(hist));
      }
    }
    notifyListeners();
  }


  // Create local DB
  Future<Database> createOrOpenLocalDB(databaseName) async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String path = join(dataDirectory.path, databaseName);
    await prefs?.setString('path', '$path.db');
    _exsist = await databaseExists('$path.db');

    if(exsist == true){
      Database dtb = await openDatabase('$path.db', version: 1);
      notifyListeners();
      return dtb;
    }

    else {
      Database dtb = await openDatabase('$path.db', version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
            'CREATE TABLE salons (id varchar(50) PRIMARY KEY, nom varchar(255), wilaya varchar(50), photo TEXT)');
          await db.execute(
            'CREATE TABLE history (id INTEGER PRIMARY KEY AUTOINCREMENT, search varchar(255), wilaya varchar(50), category varchar(50), date varchar(50), day varchar(20), hour varchar(20))');
        });
      notifyListeners();
      return dtb;
    }
  }
}