import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logs/data/db.dart';
import 'package:logs/data/widgets.dart';
import 'package:painter/painter.dart';
import 'package:permission_handler/permission_handler.dart';

class AppState with ChangeNotifier {
  final _db = new DataBase();

  AppState() {
    appState();
  }

  void appState() async {
    this._db.initDataBase();
    // await pidePermiso(Permission.camera);
    // await pidePermiso(Permission.storage);
    Permission.camera.request().isGranted;
    Permission.storage.request().isGranted;
  }

  Future<bool> saveNewAlumno(
      String text, PictureDetails firmaDetalle, XFile mifoto) async {
    try {
      if (await pidePermiso(Permission.storage)) {
        Directory dir = await crearDirectorio(text);
        // GUARDAMOS LA FOTO
        File fotoSave = File(dir.path + '/foto_$text.jpg');
        await fotoSave.writeAsBytes(await mifoto.readAsBytes());
        // GUARDAMOS LA FIRMA
        Uint8List data = await firmaDetalle.toPNG();
        File firmaSave = File(dir.path + '/firma_$text.png');
        firmaSave.writeAsBytesSync(data.toList());

        List<String> numeros = this._db.getDataUser('numeros') ?? [];
        numeros.add(text);
        this._db.saveDataUser(numeros, 'numeros');
      } else {
        print(await pidePermiso(Permission.storage));
        print('NO NOS DIERON PERMISO :(');
      }
      return true;
    } catch (e) {
      print('ERROR  EN SAVE NEW ALUMNO ');
      print(e);
      return false;
    }
  }

  void deleteAlumno(String text) async {
    try {
      // ELIMINAR DE HIVE
      List<String> numeros = this._db.getDataUser('numeros') ?? [];
      numeros.remove(text);
      this._db.saveDataUser(numeros, 'numeros');
      // ELIMINAR CARPETA
      Directory dir = await getDirectorio(text);
      dir.delete(recursive: true);
    } catch (e) {
      print('ERROR  EN DELETE ALUMNO ');
      print(e);
      print(e);
    }
  }

  List getAlumnos() => this._db.getDataUser('numeros') ?? [];
}
