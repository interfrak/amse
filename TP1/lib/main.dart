import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Media',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Media'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedPos = 0;
  int selectedMedia = 0;

  static List<Widget> listeMedia = [];
  static PageController _controller;

  //Liste des ouevres favorites
  static List<String> listeFav = [];

  double bottomNavBarHeight = 60;

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.movie, "Media", Colors.grey,
        labelStyle:
            TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
    new TabItem(Icons.more_horiz, "About", Colors.red),
  ]);

  CircularBottomNavigationController _navigationController;

  @override
  void initState() {
    super.initState();
    _navigationController = new CircularBottomNavigationController(selectedPos);

    ajoutListe(grille);
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Image(
            image: new AssetImage('images/top10.png'),
            fit: BoxFit.cover,
            width: 60,
          ),
          Container(
            child: nouveaute(),
            height: 80,
            padding: EdgeInsets.only(top: 20),
          ),
          Padding(
            child: bodyContainer(),
            padding: EdgeInsets.only(top: 80, bottom: bottomNavBarHeight),
          ),
          Align(alignment: Alignment.bottomCenter, child: bottomNav())
        ],
      ),
    );
  }

  Widget nouveaute() {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[
        for (int i = 0; i < 10; i++)
          Container(
            padding: EdgeInsets.only(left: 10, right: 20),
            height: 80,
            child: Center(
                child: Row(
              children: <Widget>[
                Icon(Icons.movie),
                Text(selectionHasard()),
              ],
            )),
          ),
      ],
    );
  }

  Widget widgerCentral;

  Widget bodyContainer() {
    switch (selectedPos) {
      case 0:
        widgerCentral = new Favoris();
        reset();
        break;
      case 1:
        widgerCentral = widgetMedia();
        reset();
        break;
      case 2:
        int taille = listeFav.length;
        widgerCentral = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 40),
              child: Text(
                "Développé par Corentin P",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 30, bottom: 10),
                child: Text(
                  "Statistique",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                )),
            Container(
                child: Text(
              "Nombre de favoris : $taille ",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
            ListTile(
              title: Text(
                "Reset Favoris",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.done),
              onTap: () {
                listeFav.clear();
              },
            )
          ],
        );
        reset();
        break;
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.red])),
        width: double.infinity,
        height: double.infinity,
        child: Center(child: widgerCentral),
      ),
    );
  }

  Widget bottomNav() {
    return CircularBottomNavigation(
      tabItems,
      controller: _navigationController,
      barHeight: bottomNavBarHeight,
      barBackgroundColor: Colors.white,
      animationDuration: Duration(milliseconds: 300),
      selectedCallback: (int selectedPos) {
        setState(() {
          this.selectedPos = selectedPos;
        });
      },
    );
  }

  Widget widgetMedia() {
    return new PageView.builder(
      controller: _controller,
      itemBuilder: (context, position) {
        return listeMedia.elementAt(position);
      },
      itemCount: 9,
    );
  }

  GridView grille = new GridView.count(
    padding: EdgeInsets.all(10),
    scrollDirection: Axis.vertical,
    crossAxisCount: 2,
    children: [
      new IconeMedia(
        source: "images/film.png",
        liste: listeMedia,
        media: Media.film,
      ),
      new IconeMedia(
        source: "images/Media/bd.jpg",
        liste: listeMedia,
        media: Media.bd,
      ),
      new IconeMedia(
          source: "images/Media/livres.jpg",
          liste: listeMedia,
          media: Media.livres),
      new IconeMedia(
          source: "images/Media/series.jpg",
          liste: listeMedia,
          media: Media.series),
      new IconeMedia(
          source: "images/Media/journaux.jpg",
          liste: listeMedia,
          media: Media.journaux),
      new IconeMedia(
          source: "images/Media/sport.jpg",
          liste: listeMedia,
          media: Media.sport),
    ],
  );

  void ajoutListe(Widget w) {
    listeMedia.add(w);
  }

  static void reset() {
    if (listeMedia.length > 1) {
      listeMedia.removeRange(1, listeMedia.length);
    }
  }

  String selectionHasard() {
    var hsdMedia = new Random();
    int indice = hsdMedia.nextInt(3);
    int i = hsdMedia.nextInt(8);
    switch (indice) {
      case 0:
        return Film._titres[i];
        break;
      case 1:
        return BD._titres[i];
        break;
      case 2:
        return Journaux._titres[i];
        break;

      default:
    }
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
    _controller?.dispose();
  }
}

class IconeMedia extends InkWell {
  Media media;

  IconeMedia(
      {Key key, String source, List<Widget> liste, List l, Media this.media})
      : super(
          child: Card(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(source),
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          onTap: () {
            if (liste.length > 1) {
              liste.removeRange(1, liste.length);
            }
            switch (media) {
              case Media.film:
                Film.ajouterFilm(liste);
                break;
              case Media.bd:
                BD.ajouterFilm(liste);
                break;
              case Media.series:
                // TODO: Handle this case.
                break;
              case Media.sport:
                // TODO: Handle this case.
                break;
              case Media.journaux:
                Journaux.ajouterFilm(liste);
                break;
              case Media.livres:
                // TODO: Handle this case.
                break;
            }
            _MyHomePageState._controller.animateToPage(1,
                curve: Curves.easeIn, duration: Duration(seconds: 1));
          },
        );
}

class Film extends Ink {
  String titre;
  String dateSortie;
  String acteurs;
  String prix;
  String realisateur;
  String genre;
  bool isFavarotie;

  Film(
      {Key key,
      String titre,
      String dateSortie,
      String acteurs,
      String prix,
      String realisateur,
      String genre,
      String source,
      this.isFavarotie = false})
      : super(
          child: Card(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(source),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(titre,
                    style: TextStyle(color: Colors.white, fontSize: 45)),
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    "Date de sortie : $dateSortie",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "Acteurs : $acteurs",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text("Réalisateur : $realisateur",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text("Genre : $genre",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.favorite)),
                            onTap: () {
                              if (_MyHomePageState.listeFav.indexOf(titre) ==
                                  -1) {
                                _MyHomePageState.listeFav.add(titre);
                              } else {
                                _MyHomePageState.listeFav.remove(titre);
                              }
                              print(_MyHomePageState.listeFav.toString());
                            },
                          ),
                        ),
                      ),
                    ])
              ],
            ),
          )),
        );

  String getName() {
    return this.titre;
  }

  static var _titres = [
    "Casino Royale",
    "E.T.",
    "Hibernatus",
    "Le loup de Wall Street",
    "Le pyjama rayé",
    "OSS 117",
    "Star Wars",
    "Au nom de la Rose"
  ];

  static void ajouterFilm(List<Widget> liste) {
    var _annee = [
      "2006",
      "1982",
      "1969",
      "2013",
      "2008",
      "2010",
      "2005",
      "1986"
    ];

    var _acteurs = [
      "Daniel Graig/ Eva Green",
      "Henry Thomas",
      "Louis de Funès",
      "Leonardo DiCaprio/ Margot Robbie",
      "Asa Butterfield",
      "Louise Monot/ Jean Dujardin",
      "McGregor/ Christensen / Portman",
      "Sean Connery"
    ];

    var _realisateur = [
      "Martin Campbell",
      "Steven Spielberg",
      "Edouard Delerue",
      "Martin Scorsese",
      "Mark Herman",
      "Michel Hazanavicius",
      "George Lucas",
      "Jean-Jacques Annaud"
    ];

    var _genre = [
      "Action",
      "Aventure",
      "Comédie",
      "Drame",
      "Drame",
      "Comédie",
      "Aventure",
      "Film à énigme"
    ];

    var _source = [
      "images/Film/casino_royale.jpg",
      "images/Film/E_T.jpg",
      "images/Film/hibernatus.jpg",
      "images/Film/le_loup_de_wallstreet.png",
      "images/Film/le_pyjama_raye.jpg",
      "images/Film/oss117_2.jpg",
      "images/Film/star_wars_3.jpg",
      "images/Film/au_nom_de_la_rose.jpg"
    ];

    for (int i = 0; i < 8; i++) {
      liste.add(new Film(
        titre: _titres[i],
        dateSortie: _annee[i],
        acteurs: _acteurs[i],
        realisateur: _realisateur[i],
        genre: _genre[i],
        source: _source[i],
      ));
    }
  }
}

class BD extends Ink {
  String titre;
  String auteur;
  String genre;

  BD({Key key, String titre, String auteur, String genre, String source})
      : super(
          child: Card(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(source),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titre,
                    style: TextStyle(color: Colors.white, fontSize: 45)),
                Container(
                  padding: EdgeInsets.only(top: 50, bottom: 10),
                  child: Text(
                    "Auteur : $auteur",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text("Genre : $genre",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                ),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.favorite)),
                            onTap: () {
                              if (_MyHomePageState.listeFav.indexOf(titre) ==
                                  -1) {
                                _MyHomePageState.listeFav.add(titre);
                              } else {
                                _MyHomePageState.listeFav.remove(titre);
                              }
                            },
                          ),
                        ),
                      ),
                    ])
              ],
            ),
          )),
        );

  static var _titres = [
    "Astérix et Obélix",
    "Gaston Lagaffe",
    "L'Ambulance 13",
    "Le Scorpion",
    "Le Temple du Soleil",
    "Le Vol du Corbeau",
    "Lucky Luke",
    "Magasin Général"
  ];

  static void ajouterFilm(List<Widget> liste) {
    var _auteurs = [
      "Uderzo/ Goscinny",
      "André Franquin",
      "Patrice Ordas/ Patrick Cothias",
      "Enrico Marini/ Stephen Desberg",
      "Hergé",
      "Jean-Pierre Gibrat",
      "Morris",
      "Régis Loisel/ Jean-Louis Tripp"
    ];

    var _genre = [
      "Aventure",
      "Humour",
      "Roman graphique",
      "Aventure",
      "Aventure",
      "Roman graphique",
      "Aventure",
      "Chronique sociale"
    ];

    var _source = [
      "images/bd/asterix_et_obelix.jpg",
      "images/bd/gaston.jpg",
      "images/bd/l_ambulance_13.jpg",
      "images/bd/le_scorpion.jpg",
      "images/bd/le_temple_du_soleil.jpg",
      "images/bd/le_vol_du_corbeau.jpg",
      "images/bd/lucky_luke.jpg",
      "images/bd/magasin_général.jpg"
    ];

    for (int i = 0; i < 8; i++) {
      liste.add(new BD(
        titre: _titres[i],
        auteur: _auteurs[i],
        genre: _genre[i],
        source: _source[i],
      ));
    }
  }
}

class Journaux extends Ink {
  String titre;

  Journaux({Key key, String titre, String source})
      : super(
          child: Card(
              child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(source),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.6), BlendMode.dstATop)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(titre,
                    style: TextStyle(color: Colors.black, fontSize: 45)),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ClipOval(
                        child: Material(
                          color: Colors.blue, // button color
                          child: InkWell(
                            splashColor: Colors.red, // inkwell color
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: Icon(Icons.favorite)),
                            onTap: () {
                              if (_MyHomePageState.listeFav.indexOf(titre) ==
                                  -1) {
                                _MyHomePageState.listeFav.add(titre);
                              } else {
                                _MyHomePageState.listeFav.remove(titre);
                              }
                            },
                          ),
                        ),
                      ),
                    ])
              ],
            ),
          )),
        );

  static var _titres = [
    "Le Monde",
    "Courrier International",
    "Marianne",
    "Liberation",
    "L'Obs",
    "Le Point",
    "Le Figaro",
    "L'Express"
  ];

  static void ajouterFilm(List<Widget> liste) {
    var _source = [
      "images/journaux/le_monde.jpg",
      "images/journaux/courrier_international.jpg",
      "images/journaux/marianne.jpg",
      "images/journaux/liberation.jpg",
      "images/journaux/l_obs.jpg",
      "images/journaux/le_point.jpg",
      "images/journaux/le_figaro.png",
      "images/journaux/l_express.jpg"
    ];

    for (int i = 0; i < 8; i++) {
      liste.add(new Journaux(
        titre: _titres[i],
        source: _source[i],
      ));
    }
  }
}

class Favoris extends Column {
  Favoris({
    Key key,
  }) : super(children: [
          Container(
              padding: EdgeInsets.only(top: 30),
              child: new Text(
                "Liste des Favoris",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              )),
          Expanded(child: new ListeFavoris())
        ]);
}

class ListeFavoris extends ListView {
  ListeFavoris({
    Key key,
  }) : super(children: [
          for (String titre in _MyHomePageState.listeFav)
            ListTile(
              title: Text(
                titre,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.favorite),
              onTap: () {
                if (_MyHomePageState.listeFav.indexOf(titre) == -1) {
                  _MyHomePageState.listeFav.add(titre);
                } else {
                  _MyHomePageState.listeFav.remove(titre);
                }
              },
            ),
        ]);
}

enum Media { film, bd, series, sport, journaux, livres }
