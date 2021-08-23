import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:logs/data/colors.dart';
import 'package:logs/data/widgets.dart';
import 'package:logs/providers/appstate.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatelessWidget {
  String numero;
  ItemPage({@required this.numero});
  Size size;

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(numero),
          actions: [
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  return showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Center(child: Text('Eliminar Registro')),
                          actions: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Provider.of<AppState>(context, listen: false)
                                    .deleteAlumno(numero);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              color: Colors.blue,
                              child: Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          content: Text(
                              '¿Estás seguro de eliminar este registro?')));
                })
          ],
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Foto',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            getFoto(numero),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Text(
                'Firma',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            getFirma(numero),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              color: Colors.grey[300],
              child: FutureBuilder<Directory>(
                future: getDirectorio(numero),
                builder: (_, AsyncSnapshot<Directory> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return Text('Guardados en:  ' + snapshot.data.path);
                  else {
                    return Text('');
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget getFoto(String a) {
    return FutureBuilder(
      future: getDirectorio(a),
      builder: (_, AsyncSnapshot<Directory> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return spinner();
          case ConnectionState.done:
            try {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  // border: Border.all(color: second, width: 2),
                ),
                child: Image.file(
                  File(snap.data.path + '/foto_$a.jpg'),
                  scale: 0.5,
                ),
              );
            } catch (e) {
              print(e);
              return Text('No encontramos la foto');
            }
            break;
          default:
            return Text('No encontramos la foto');
        }
      },
    );
  }

  Widget getFirma(String a) {
    return FutureBuilder(
      future: getDirectorio(a),
      builder: (_, AsyncSnapshot<Directory> snap) {
        switch (snap.connectionState) {
          case ConnectionState.waiting:
            return spinner();
          case ConnectionState.done:
            try {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  // border: Border.all(color: second, width: 2),
                ),
                child: Image.file(
                  File(snap.data.path + '/firma_$a.png'),
                  scale: 0.5,
                ),
              );
            } catch (e) {
              print(e);
              return Text('No encontramos la firma');
            }
            break;
          default:
            return Text('No encontramos la firma');
        }
      },
    );
  }
}
