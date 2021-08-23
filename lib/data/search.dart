import 'package:flutter/material.dart';
import 'package:logs/pages/item.dart';
import 'package:logs/providers/appstate.dart';
import 'package:provider/provider.dart';

class ArticleSearch extends SearchDelegate<String> {
  final String searchFieldLabel = 'Buscar alumno';
  final TextStyle searchFieldStyle = TextStyle(
    color: Colors.grey[600],
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.backspace),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, 'null');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSingleChildScrollView(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildSingleChildScrollView(context, query);
  }

  Widget buildSingleChildScrollView(BuildContext context, String query) {
    AppState _state = Provider.of<AppState>(context, listen: false);
    if (_state.getAlumnos().isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: [
            for (var x in _state.getAlumnos())
              if (x.contains(query))
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    tileColor: Colors.grey[100],
                    title: Text(x, overflow: TextOverflow.fade, maxLines: 1),
                    trailing: IconButton(
                        onPressed: () {
                          close(context, 'null');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ItemPage(numero: x),
                            ),
                          );
                        },
                        icon: Icon(Icons.remove_red_eye, color: Colors.grey)),
                  ),
                ),
          ],
        ),
      );
    } else
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Icon(Icons.keyboard_arrow_up, color: Colors.grey),
          subtitle: Text(
            'Ingresa un número de control',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
  }
}
