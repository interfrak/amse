import 'package:flutter/material.dart';

class Tile {
  String titre;
  bool estVide;
  int numero;
  Color couleur;

  Tile(this.titre, this.estVide, this.numero) {
    if (estVide) {
      couleur = Colors.grey;
    } else {
      couleur = Colors.blue;
    }
  }

  void setVide() {
    this.estVide = true;
  }

  void notVide() {
    this.estVide = false;
  }
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;
  final Color couleur;

  TileWidget(this.tile, this.couleur);

  @override
  Widget build(BuildContext context) {
    return this.titreBox();
  }

  Widget titreBox() {
    return Container(color: couleur, child: Text(tile.titre));
  }
}

List<Tile> listeTile = [];

class PlateauMobile extends StatefulWidget {
  PlateauMobile({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PlateauMobileState createState() => PlateauMobileState();
}

class PlateauMobileState extends State<PlateauMobile> {
  int nbTuileLigne;
  int tileVide;

  @override
  void initState() {
    nbTuileLigne = 4;
    initListeTile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plateau Mobile'),
        centerTitle: true,
      ),
      body: Center(
          child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: nbTuileLigne,
        children: List.generate(nbTuileLigne * nbTuileLigne, (index) {
          return SizedBox(
              width: 150.0,
              height: 150.0,
              child: Container(
                  margin: EdgeInsets.all(5.0),
                  child: this.createTileWidgetFrom(listeTile[index])));
        }),
      )),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: TileWidget(tile, tile.couleur),
      onTap: () {
        int j = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[0];
        int i = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[1];
        int jV = generationIndice(tileVide, nbTuileLigne)[0];
        int iV = generationIndice(tileVide, nbTuileLigne)[1];
        if ((i == iV - 1 && j == jV) || (i == iV + 1 && j == jV)) {
          setState(() {
            int newtileVide = listeTile.indexOf(tile);
            tile.setVide();
            listeTile.elementAt(tileVide).notVide();
            print('TileVide: $tileVide');
            print('TileTap: $newtileVide');
            print(listeTile.toString());
            listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
            tileVide = newtileVide;
          });
        } else if ((j == jV + 1 && i == iV)) {
          setState(() {
            int newtileVide = listeTile.indexOf(tile);
            tile.setVide();
            listeTile.elementAt(tileVide).notVide();
            print('TileVide: $tileVide');
            print('TileTap: $newtileVide');
            print(listeTile.toString());
            listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
            listeTile.insert(newtileVide, listeTile.removeAt(tileVide + 1));
            tileVide = newtileVide;
          });
        } else if ((j == jV - 1 && i == iV)) {
          setState(() {
            int newtileVide = listeTile.indexOf(tile);
            tile.setVide();
            listeTile.elementAt(tileVide).notVide();
            print('TileVide: $tileVide');
            print('TileTap: $newtileVide');
            print(listeTile.toString());
            listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
            listeTile.insert(newtileVide, listeTile.removeAt(tileVide - 1));
            tileVide = newtileVide;
          });
        }
      },
    );
  }

  void initListeTile() {
    listeTile.add(Tile('Vide0', true, 0));
    tileVide = 0;
    for (int i = 1; i < nbTuileLigne * nbTuileLigne; i++) {
      listeTile.add(Tile('Tile$i', false, i));
    }
  }

  List<int> generationIndice(int index, int nbLigne) {
    int i;
    int j;
    i = (index / nbLigne).floor();
    j = index - i * nbLigne;

    List<int> l = [i, j];
    return l;
  }
}
