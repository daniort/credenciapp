import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Directory> crearDirectorio(String text) async {
  Directory dir = await getExternalStorageDirectory();
  // Directory dir = await getApplicationDocumentsDirectory();
  //getExternalStorageDirectory();
  print(dir.path);
  print('===');
  String _nPath = "";
  List<String> paths = dir.path.split("/");
  for (int x = 1; x < paths.length; x++) {
    String folder = paths[x];
    if (folder != "Android")
      _nPath += "/" + folder;
    else
      break;
  }
  _nPath = _nPath + "/RegistrosAPP/$text";
  Directory nuevoDir = Directory(_nPath);
  if (await nuevoDir.exists() == false) await nuevoDir.create(recursive: true);
  return nuevoDir;
}

Future<Directory> getDirectorio(String text) async {
  Directory dir = await getExternalStorageDirectory();
  print(dir.path);
  print('===');
  String _nPath = "";
  List<String> paths = dir.path.split("/");
  for (int x = 1; x < paths.length; x++) {
    String folder = paths[x];
    if (folder != "Android")
      _nPath += "/" + folder;
    else
      break;
  }
  _nPath = _nPath + "/RegistrosAPP/$text";
  return Directory(_nPath);
}

snack(String label, Color col, GlobalKey<ScaffoldState> key) {
  return key.currentState.showSnackBar(SnackBar(
    content: Text(label),
    backgroundColor: col,
    duration: Duration(seconds: 4),
    action: SnackBarAction(
      label: 'X',
      textColor: Colors.white,
      onPressed: () {
        key.currentState.hideCurrentSnackBar();
      },
    ),
  ));
}

Center spinner() {
  return Center(
    child: SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: Colors.grey[800],
        strokeWidth: 1,
      ),
    ),
  );
}

Future<bool> pidePermiso(Permission permiso) async {
  print(permiso);
  bool autori = await permiso.isGranted;
  print(autori);

  if (autori) {
    return true;
  } else {
    var result = await permiso.request();
    if (result == PermissionStatus.granted)
      return true;
    else
      return false;
  }
}
