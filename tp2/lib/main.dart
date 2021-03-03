import 'package:tp2/exo5a.dart';
import 'package:tp2/exo7.dart';

import 'exo2.dart';
import 'exo4.dart';
import 'exo5a.dart';
import 'exo5b.dart';
import 'exo5c.dart';
import 'exo6a.dart';
import 'exo6b.dart';
import 'exo6c.dart';

import 'package:flutter/material.dart';

import 'package:tp2/exo2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text("TP2"),
        ),
        body: ListView.builder(
          itemCount: exos.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(exos[index].titre),
                trailing: Icon(Icons.play_arrow_rounded),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: exos[index].buildFunc));
                },
              ),
            );
          },
        ));
  }
}

class Exo {
  final String titre;
  final WidgetBuilder buildFunc;

  const Exo({@required this.titre, @required this.buildFunc});
}

List exos = [
  Exo(titre: 'Exercice 2', buildFunc: (context) => Exo2()),
  Exo(titre: 'Exercice 4', buildFunc: (context) => DisplayTileWidget()),
  Exo(titre: 'Exercice 5a', buildFunc: (context) => Plateau()),
  Exo(titre: 'Exercice 5b', buildFunc: (context) => PlateauImage()),
  Exo(titre: 'Exercice 5c', buildFunc: (context) => PlateauDimension()),
  Exo(titre: 'Exercice 6a', buildFunc: (context) => PositionedTiles()),
  Exo(titre: 'Exercice 6b', buildFunc: (context) => PlateauMobile()),
  Exo(titre: 'Exercice 6c', buildFunc: (context) => PlateauMobilePlus()),
  Exo(titre: 'Taquin', buildFunc: (context) => Taquin()),
];
