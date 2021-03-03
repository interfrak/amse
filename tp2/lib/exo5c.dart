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

class PlateauDimension extends StatefulWidget {
  PlateauDimension({Key key, this.title}) : super(key: key);

  final String title;

  @override
  PlateauImageDimensionState createState() => PlateauImageDimensionState();
}

class PlateauImageDimensionState extends State<PlateauDimension> {
  int nbTuileLigne = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Plateau fixe image'),
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GridView.count(
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
                          margin: EdgeInsets.all(2.5),
                          child: this.createTileWidgetFrom(tile)));
                }),
              ),
              Slider(
                min: 2.0,
                max: 15,
                value: nbTuileLigne.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    nbTuileLigne = value.floor();
                  });
                },
              )
            ]));
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
