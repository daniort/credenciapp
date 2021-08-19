import 'package:flutter/material.dart';
import 'package:logs/data/db.dart';

class AppState with ChangeNotifier {
  final _db = new DataBase();

  AppState() {
    appState();
  }

  void appState() async {
    this._db.initDataBase();
  }
}
