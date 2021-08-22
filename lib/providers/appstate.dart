import 'dart:io';
import 'dart:typed_data';

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

  Future<ResModel> saveNewAlumno(
      String text, PictureDetails firmaDetalle, var mifoto) async {
    try {
      if (await pidePermiso(Permission.storage)) {
        List<String> numeros = this._db.getDataUser('numeros') ?? [];
        if (!numeros.contains(text)) {
          numeros.add(text);
          this._db.saveDataUser(numeros, 'numeros');
          Directory dir = await crearDirectorio(text);
          // GUARDAMOS LA FOTO
          File fotoSave = File(dir.path + '/foto_$text.jpg');
          await fotoSave.writeAsBytes(await mifoto.readAsBytes());
          // GUARDAMOS LA FIRMA
          Uint8List data = await firmaDetalle.toPNG();
          File firmaSave = File(dir.path + '/firma_$text.png');
          firmaSave.writeAsBytesSync(data.toList());
          return ResModel(msn: 'Hecho', success: true);
        } else
          return ResModel(
              msn: 'Número de control ya registrado', success: false);
      } else
        return ResModel(
            msn: 'No tenemos los permisos para continuar', success: false);
    } catch (e) {
      return ResModel(msn: e.toString(), success: false);
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

class ResModel {
  ResModel({
    this.msn,
    this.success,
  });

  String msn;
  bool success;
}
