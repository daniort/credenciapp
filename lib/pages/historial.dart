import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:logs/data/search.dart';
import 'package:logs/data/widgets.dart';
import 'package:logs/pages/item.dart';
import 'package:logs/providers/appstate.dart';
import 'package:provider/provider.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  Size size;
  AppState state;
  @override
  Widget build(BuildContext context) {
    this.state = Provider.of<AppState>(context, listen: true);
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de registros'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: ArticleSearch());
            },
          ),
        ],
      ),
      body: HiveListener(
          box: Hive.box('data'),
          builder: (box) {
            List numeros = box.get('numeros') ?? [];
            if (numeros.isEmpty) {
              return Center(
                child: Text(
                  'No hay ningún registro',
                  style: TextStyle(color: Colors.grey),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: numeros.length,
                    itemBuilder: (_, i) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        color: Colors.grey[200],
                        child: ExpansionTile(
                          title: Text(numeros[i] ?? ''),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getFoto(numeros[i]),
                                SizedBox(width: 20),
                                getFirma(numeros[i]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ItemPage(numero: numeros[i]),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.remove_red_eye,
                                            color: Colors.grey),
                                        SizedBox(width: 5),
                                        Text(
                                          'Ver',
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    return showDialog(
                                      context: context,
                                      builder: (context) =>
                                          // dialogDelete(context, numeros[i]),

                                          AlertDialog(
                                              title: Center(
                                                  child: Text(
                                                      'Eliminar Registro')),
                                              actions: <Widget>[
                                                MaterialButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.grey[800]),
                                                  ),
                                                ),
                                                MaterialButton(
                                                  onPressed: () {
                                                    Provider.of<AppState>(
                                                            context,
                                                            listen: false)
                                                        .deleteAlumno(
                                                            numeros[i]);
                                                    Navigator.pop(context);
                                                  },
                                                  color: Colors.blue,
                                                  child: Text(
                                                    'Eliminar',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                              content: Text(
                                                  '¿Estás seguro de eliminar este registro?')),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            color: Colors.red[300]),
                                        SizedBox(width: 5),
                                        Text(
                                          'Eliminar',
                                          style: TextStyle(
                                            color: Colors.red[300],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: this.size.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  color: Colors.grey[300],
                  child: Text(
                    '${numeros.length} Registros totales',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            );
          }),
    );
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
              return Image.file(
                File(snap.data.path + '/foto_$a.jpg'),
                width: this.size.width * 0.25,
              );
            } catch (e) {
              print(e);
              return Text('No encontramos las fotos');
            }
            break;
          default:
            return Text('No encontramos las fotos');
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
                padding: EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: Image.file(
                  File(snap.data.path + '/firma_$a.png'),
                  width: this.size.width * 0.25,
                ),
              );
            } catch (e) {
              print(e);
              return Text('No encontramos las fotos');
            }
            break;
          default:
            return Text('No encontramos las fotos');
        }
      },
    );
  }
}
