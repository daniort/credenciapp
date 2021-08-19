import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_listener/hive_listener.dart';
import 'package:logs/data/db.dart';

class HistorialPage extends StatefulWidget {
  @override
  _HistorialPageState createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  final db = new DataBase();
  Size size;
  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de registros'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
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
                  child: ListView(
                    children: [
                      for (var a in numeros)
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          color: Colors.grey[200],
                          child: ExpansionTile(
                            title: Text(a ?? ''),
                            leading:
                                Icon(Icons.remove_red_eye, color: Colors.grey),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                this.db.eliminarNuevoNumero(a);
                              },
                            ),
                            // children: [
                            //   Text('su foto'),
                            //   Text('su firma'),
                            // ],
                          ),
                        )
                    ],
                  ),
                ),
                Container(
                  width: this.size.width,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
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
}

//  Column(
//         children: [
//           Expanded(
//             child: ListView(
//               children: [
//                 for (int a in [1, 2, 3])
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     color: Colors.grey[200],
//                     child: ExpansionTile(
//                       title: Text('14620181'),
//                       leading: Icon(Icons.remove_red_eye, color: Colors.grey),
//                       trailing: Icon(Icons.delete, color: Colors.red),
//                       children: [
//                         Text('su foto'),
//                         Text('su firma'),
//                       ],
//                     ),
//                   )
//               ],
//             ),
//           ),
//           Container(
//             width: this.size.width,
//             padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
//             color: Colors.grey[300],
//             child: Text(
//               '513 Registros totales',
//               textAlign: TextAlign.right,
//             ),
//           ),
//         ],
//       ),
