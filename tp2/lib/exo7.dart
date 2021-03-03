import 'package:flutter/material.dart';
import 'dart:math';
import 'Noeud.dart';
import 'Solveur.dart';
import 'Grille.dart';

class Tile {
  String titre;
  bool estVide;
  int numero;
  Color couleur;
  String imageURL;
  Alignment alignment;
  int nb;
  int numVerif;

  Tile(this.titre, this.estVide, this.numero, this.imageURL, this.nb,
      this.alignment, this.numVerif);
}

// ==============
// Widgets
// ==============

class TileWidget extends StatelessWidget {
  final Tile tile;

  TileWidget(this.tile);

  @override
  Widget build(BuildContext context) {
    return this.titreBox();
  }

  Widget titreBox() {
    return Container(child: croppedImageTile());
  }

  Widget croppedImageTile() {
    if (!tile.estVide) {
      return FittedBox(
        fit: BoxFit.fill,
        child: ClipRect(
          child: Container(
            child: Align(
              alignment: tile.alignment,
              widthFactor: 1 / tile.nb,
              heightFactor: 1 / tile.nb,
              child: Image.network(url),
            ),
          ),
        ),
      );
    } else {
      return Container(
        color: Colors.white,
      );
    }
  }
}

List<Tile> listeTile = [];
String url = 'https://picsum.photos/512';

class Taquin extends StatefulWidget {
  Taquin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TaquinState createState() => TaquinState();
}

class TaquinState extends State<Taquin> {
  int nbTuileLigne;
  int tileVide;
  int nbMelange;

  Icon playIcon;
  bool play;

  int nbCoup;
  List<int> listeCoup = [];

  @override
  void initState() {
    listeTile.clear();
    listeCoup.clear();

    nbTuileLigne = 3;

    nbMelange = 10;

    playIcon = Icon(Icons.play_arrow);
    play = false;

    nbCoup = 0;

    initListeTile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Taquin'),
        centerTitle: true,
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                icon: Icon(Icons.restore),
                onPressed: () {
                  setState(() {
                    if (listeCoup.isNotEmpty) {
                      int oldPos = listeCoup.removeLast();
                      retourEnArierre(oldPos, tileVide);
                      nbCoup--;
                    }
                  });
                }),
            Container(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (nbMelange > 0) {
                            nbMelange--;
                          }
                        });
                      }),
                  Text(
                    '$nbMelange',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          nbMelange++;
                        });
                      })
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '$nbCoup',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: nbTuileLigne,
          children: List.generate(nbTuileLigne * nbTuileLigne, (index) {
            return SizedBox(
                width: 150.0,
                height: 150.0,
                child: Container(
                    margin: EdgeInsets.all(2.0),
                    child: this.createTileWidgetFrom(listeTile[index])));
          }),
        ),
        Container(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (!play) {
                        setState(() {
                          if (nbTuileLigne > 3) {
                            nbTuileLigne--;
                            listeTile.clear();
                            initListeTile();
                            nbCoup = 0;
                          }
                        });
                      }
                    }),
                IconButton(
                    icon: playIcon,
                    onPressed: () {
                      setState(() {
                        if (!play) {
                          melangerTaquin(nbMelange, nbTuileLigne);
                          playIcon = Icon(Icons.stop);
                          play = true;
                          //nombreCoupGagnant();
                          nbCoup = 0;
                        } else {
                          playIcon = Icon(Icons.play_arrow);
                          play = false;
                        }
                      });
                    }),
                IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (!play) {
                        setState(() {
                          if (nbTuileLigne < 8) {
                            nbTuileLigne++;
                            listeTile.clear();
                            listeCoup.clear();
                            initListeTile();
                            nbCoup = 0;
                          }
                        });
                      }
                    })
              ],
            ))
      ]),
    );
  }

  Widget createTileWidgetFrom(Tile tile) {
    Widget w = TileWidget(tile);
    if (estAdjacent(tile)) {
      return InkWell(
        child: w,
        onTap: () {
          if (play) {
            int j = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[0];
            int i = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[1];
            int jV = generationIndice(tileVide, nbTuileLigne)[0];
            int iV = generationIndice(tileVide, nbTuileLigne)[1];
            if ((i == iV - 1 && j == jV) || (i == iV + 1 && j == jV)) {
              setState(() {
                int newtileVide = listeTile.indexOf(tile);
                listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
                listeCoup.add(tileVide);
                tileVide = newtileVide;
                nbCoup++;
              });
            } else if ((j == jV + 1 && i == iV)) {
              setState(() {
                int newtileVide = listeTile.indexOf(tile);
                listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
                listeTile.insert(newtileVide, listeTile.removeAt(tileVide + 1));
                listeCoup.add(tileVide);
                tileVide = newtileVide;
                nbCoup++;
              });
            } else if ((j == jV - 1 && i == iV)) {
              setState(() {
                int newtileVide = listeTile.indexOf(tile);
                listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
                listeTile.insert(newtileVide, listeTile.removeAt(tileVide - 1));
                listeCoup.add(tileVide);
                tileVide = newtileVide;
                nbCoup++;
              });
            }
            victoire();
          }
        },
      );
    }
    return w;
  }

  void initListeTile() {
    Random r = Random();
    tileVide = r.nextInt(nbTuileLigne * nbTuileLigne);
    for (int i = 0; i < nbTuileLigne * nbTuileLigne; i++) {
      if (i == tileVide) {
        listeTile.add(Tile(
            'Vide0', true, tileVide, url, nbTuileLigne, Alignment(0, 0), 0));
      } else {
        List l = generationCoordonnee(i, nbTuileLigne);
        listeTile.add(Tile('Tile$i', false, i, url, nbTuileLigne,
            Alignment(l.elementAt(0), l.elementAt(1)), i + 1));
      }
    }
    for (Tile t in listeTile) {
      int num = t.numVerif;
      int n = t.numero;
      print('numero $n');
      print('numVerif $num ');
      print('');
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

  void melangerTaquin(int nombreMelange, int nbLigne) {
    print('initialVide $tileVide');
    for (int k = 0; k < nombreMelange; k++) {
      int i = generationIndice(tileVide, nbLigne)[0];
      int j = generationIndice(tileVide, nbLigne)[1];
      deplacementAleatoire(determinationPosition(i, j, nbLigne), i, j, nbLigne);
    }
    for (Tile t in listeTile) {
      int num = t.numVerif;
      int n = t.numero;
      print('numero $n');
      print('numVerif $num ');
      print('');
    }
  }

  PositionTile determinationPosition(int i, int j, int nbLigne) {
    if (i == 0 && j == 0) {
      return PositionTile.coinHautGauche;
    } else if (i == 0 && j == (nbLigne - 1)) {
      return PositionTile.coinHautDroit;
    } else if (j == 0 && i == (nbLigne - 1)) {
      return PositionTile.coinBasGauche;
    } else if (j == (nbLigne - 1) && i == (nbLigne - 1)) {
      return PositionTile.coinBasDroit;
    } else if (j == 0 && i != 0 && i != (nbLigne - 1)) {
      return PositionTile.bordGauche;
    } else if (j == (nbLigne - 1) && i != 0 && i != (nbLigne - 1)) {
      return PositionTile.bordDroit;
    } else if (i == 0 && j != 0 && j != (nbLigne - 1)) {
      return PositionTile.bordHaut;
    } else if (i == (nbLigne - 1) && j != 0 && j != (nbLigne - 1)) {
      return PositionTile.bordBas;
    } else {
      return PositionTile.centre;
    }
  }

  void deplacementAleatoire(PositionTile position, int i, int j, int nbLigne) {
    Random random = new Random();
    switch (position) {
      case PositionTile.coinHautGauche:
        int val = random.nextInt(2);
        switch (val) {
          case 0:
            mouvementDroit(i, j, nbLigne);
            break;
          case 1:
            mouvementBas(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.coinHautDroit:
        int val = random.nextInt(2);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementBas(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.coinBasGauche:
        int val = random.nextInt(2);
        switch (val) {
          case 0:
            mouvementDroit(i, j, nbLigne);
            break;
          case 1:
            mouvementHaut(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.coinBasDroit:
        int val = random.nextInt(2);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementHaut(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.bordHaut:
        int val = random.nextInt(3);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementDroit(i, j, nbLigne);
            break;
          case 2:
            mouvementBas(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.bordBas:
        int val = random.nextInt(3);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementDroit(i, j, nbLigne);
            break;
          case 2:
            mouvementHaut(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.bordGauche:
        int val = random.nextInt(3);
        switch (val) {
          case 0:
            mouvementDroit(i, j, nbLigne);
            break;
          case 1:
            mouvementHaut(i, j, nbLigne);
            break;
          case 2:
            mouvementBas(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.bordDroit:
        int val = random.nextInt(3);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementHaut(i, j, nbLigne);
            break;
          case 2:
            mouvementBas(i, j, nbLigne);
            break;
          default:
        }
        break;
      case PositionTile.centre:
        int val = random.nextInt(4);
        switch (val) {
          case 0:
            mouvementGauche(i, j, nbLigne);
            break;
          case 1:
            mouvementHaut(i, j, nbLigne);
            break;
          case 2:
            mouvementBas(i, j, nbLigne);
            break;
          case 3:
            mouvementHaut(i, j, nbLigne);
            break;
          default:
        }
        break;
      default:
    }
  }

  void mouvementDroit(int i, int j, int nbLigne) {
    int newtileVide = j + 1 + i * nbLigne;
    listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
    tileVide = newtileVide;
  }

  void mouvementGauche(int i, int j, int nbLigne) {
    int newtileVide = j - 1 + i * nbLigne;
    listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
    tileVide = newtileVide;
  }

  void mouvementBas(int i, int j, int nbLigne) {
    int newtileVide = j + (i + 1) * nbLigne;
    listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
    listeTile.insert(newtileVide, listeTile.removeAt(tileVide + 1));
    tileVide = newtileVide;
  }

  void mouvementHaut(int i, int j, int nbLigne) {
    int newtileVide = j + (i - 1) * nbLigne;
    listeTile.insert(tileVide, listeTile.removeAt(newtileVide));
    listeTile.insert(newtileVide, listeTile.removeAt(tileVide - 1));
    tileVide = newtileVide;
  }

  bool estAdjacent(Tile tile) {
    int j = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[0];
    int i = generationIndice(listeTile.indexOf(tile), nbTuileLigne)[1];
    int jV = generationIndice(tileVide, nbTuileLigne)[0];
    int iV = generationIndice(tileVide, nbTuileLigne)[1];
    if ((i == iV - 1 && j == jV) ||
        (i == iV + 1 && j == jV) ||
        (j == jV + 1 && i == iV) ||
        (j == jV - 1 && i == iV)) {
      return true;
    } else {
      return false;
    }
  }

  bool victoire() {
    for (int i = 0; i < listeTile.length; i++) {
      if (listeTile.elementAt(i).numero != i) {
        return false;
      }
    }
    _showMyDialog();
    return true;
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Victoire'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Vous avez gagné!'),
                Text('Voulez-vous rejouer?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Non'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  playIcon = Icon(Icons.play_arrow);
                  play = false;
                });
              },
            ),
            TextButton(
              child: Text('Oui'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  melangerTaquin(nbMelange, nbTuileLigne);
                  playIcon = Icon(Icons.stop);
                  play = true;
                  nbCoup = 0;
                });
              },
            ),
          ],
        );
      },
    );
  }

  void retourEnArierre(int oldPos, int newPos) {
    PositionRelative pos = positionRelative(oldPos, newPos);
    int i = generationIndice(oldPos, nbTuileLigne)[0];
    int j = generationIndice(oldPos, nbTuileLigne)[1];
    switch (pos) {
      case PositionRelative.haut:
        mouvementHautPrime(i, j, nbTuileLigne, oldPos, newPos);
        break;
      case PositionRelative.bas:
        mouvementBasPrime(i, j, nbTuileLigne, oldPos, newPos);
        break;
      case PositionRelative.gauche:
        mouvementGauchePrime(i, j, nbTuileLigne, oldPos, newPos);
        break;
      case PositionRelative.droite:
        mouvementDroitPrime(i, j, nbTuileLigne, oldPos, newPos);
        break;
      default:
    }
  }

  void mouvementDroitPrime(int i, int j, int nbLigne, int oldPos, int newPos) {
    listeTile.insert(newPos, listeTile.removeAt(oldPos));
    tileVide = oldPos;
  }

  void mouvementGauchePrime(int i, int j, int nbLigne, int oldPos, int newPos) {
    listeTile.insert(newPos, listeTile.removeAt(oldPos));
    tileVide = oldPos;
  }

  void mouvementBasPrime(int i, int j, int nbLigne, int oldPos, int newPos) {
    listeTile.insert(newPos, listeTile.removeAt(oldPos));
    listeTile.insert(oldPos, listeTile.removeAt(newPos + 1));
    tileVide = oldPos;
  }

  void mouvementHautPrime(int i, int j, int nbLigne, int oldPos, int newPos) {
    listeTile.insert(newPos, listeTile.removeAt(oldPos));
    listeTile.insert(oldPos, listeTile.removeAt(newPos - 1));
    tileVide = oldPos;
  }

  PositionRelative positionRelative(int oldPos, int newPos) {
    int oldi = generationIndice(oldPos, nbTuileLigne)[0];
    int oldj = generationIndice(oldPos, nbTuileLigne)[1];
    int newi = generationIndice(newPos, nbTuileLigne)[0];
    int newj = generationIndice(newPos, nbTuileLigne)[1];

    if (oldi > newi) {
      return PositionRelative.bas;
    } else if (oldi < newi) {
      return PositionRelative.haut;
    } else if (oldj > newj) {
      return PositionRelative.droite;
    } else {
      return PositionRelative.gauche;
    }
  }

  Future<void> nombreCoupGagnant() async {
    List<List<int>> g = List.generate(nbTuileLigne, (i) => List(nbTuileLigne));
    for (int i = 0; i < listeTile.length; i++) {
      List<int> l = generationIndice(i, nbTuileLigne);
      g[l[0]][l[1]] = listeTile.elementAt(i).numVerif;
      int num = listeTile.elementAt(i).numVerif;
      int n = listeTile.elementAt(i).numero;
      print('numero $n');
      print('numVerif $num ');
    }
    Grille grille = new Grille(g);
    print(grille.toString());
    for (Tile t in listeTile) {
      print(t.numVerif);
    }
    Solveur solver = new Solveur();
    print("solveur");
    Noeud astarNoeud = solver.algoAstar(grille);
    print('noeud');
    int nbCoupGagant = astarNoeud.Successeurs().length;
    print('nbCoupGagnat $nbCoupGagant');

    for (Grille deux in solver.cheminComplet(astarNoeud)) {
      print(deux.toString());
      print('');
    }
    return nbCoupGagant;
  }
}

enum PositionTile {
  centre,
  coinHautGauche,
  coinHautDroit,
  coinBasGauche,
  coinBasDroit,
  bordGauche,
  bordDroit,
  bordHaut,
  bordBas
}

enum PositionRelative { haut, bas, gauche, droite }
