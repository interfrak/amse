import 'package:flutter/material.dart';

class Tile {
  String imageURL;
  Alignment alignment;
  int nb;

  Tile({this.imageURL, this.alignment, this.nb});

  Widget croppedImageTile() {
    return FittedBox(
      fit: BoxFit.fill,
      child: ClipRect(
        child: Container(
          child: Align(
            alignment: this.alignment,
            widthFactor: 1 / nb,
            heightFactor: 1 / nb,
            child: Image.network(this.imageURL),
          ),
        ),
      ),
    );
  }
}

class PlateauImage extends StatelessWidget {
  final int nbTuileLigne = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Plateau fixe image'),
          centerTitle: true,
        ),
        body: Center(
            child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: nbTuileLigne,
          children: List.generate(nbTuileLigne * nbTuileLigne, (index) {
            List<double> l = generationCoordonnee(index, nbTuileLigne);
            Tile tile = new Tile(
                imageURL: 'https://picsum.photos/256',
                alignment: Alignment(l.elementAt(0), l.elementAt(1)),
                nb: nbTuileLigne);
            return SizedBox(
                width: 150.0,
                height: 150.0,
                child: Container(
                    margin: EdgeInsets.all(5.0),
                    child: this.createTileWidgetFrom(tile)));
          }),
        )));
  }

  Widget createTileWidgetFrom(Tile tile) {
    return InkWell(
      child: tile.croppedImageTile(),
      onTap: () {
        print("tapped on tile");
      },
    );
  }

  List<double> generationCoordonnee(int index, int nbLigne) {
    int i;
    int j;
    i = (index / nbLigne).floor();
    j = index - i * nbLigne;

    double intervalle = 2 / (nbLigne - 1);
    double x = -1 + j * intervalle;
    double y = -1 + i * intervalle;

    List<double> l = [x, y];
    return l;
  }
}
