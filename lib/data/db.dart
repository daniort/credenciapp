// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:umbral/models/models.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class DataBase {
  DataBase() {
    initDataBase();
  }
  Box _boxData;

  Future<void> close() async {
    await Hive.close();
  }

  Box get mybox => this._boxData;

  dynamic getDataUser(String index) => this._boxData.get(index);

  Future<void> initDataBase() async {
    Directory _document = await getTemporaryDirectory();
    Hive.init(_document.path);
    this._boxData = await Hive.openBox('data');
  }

  void guardarNuevoNumero(String numControl) {
    try {
      List<String> numeros = this._boxData.get('numeros') ?? [];
      numeros.add(numControl);
      this._boxData.put('numeros', numeros);
    } catch (e) {
      print('ERROR ============');
      print(e);
      this._boxData.put('numeros', [numControl]);
    }
  }

  void eliminarNuevoNumero(String numControl) {
    List<String> _numeros = this._boxData.get('numeros') ?? [];
    _numeros.remove(numControl);
    this._boxData.put('numeros', _numeros);
  }
}
