import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/rendering.dart';

List<Widget> listeMedia = [];
PageController _controller;
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
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          height: 80,
          child: Center(
              child: Row(
            children: <Widget>[
              Icon(Icons.movie),
              Text('Entry A'),
            ],
          )),
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          height: 80,
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          height: 80,
          child: const Center(child: Text('Entry C')),
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          height: 80,
          child: const Center(child: Text('Entry D')),
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          height: 80,
          child: const Center(child: Text('Entry E')),
        ),
        Container(
          padding: EdgeInsets.only(right: 20),
          height: 80,
          child: const Center(child: Text('Entry F')),
        ),
      ],
    );
  }

  Widget widgerCentral;

  Widget bodyContainer() {
    //Color selectedColor = tabItems[selectedPos].circleColor;

    switch (selectedPos) {
      case 0:
        widgerCentral = Icon(Icons.home);
        break;
      case 1:
        widgerCentral = widgetMedia();
        break;
      case 2:
        widgerCentral = Icon(Icons.more_horiz);
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
          print(_navigationController.value);
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _navigationController.dispose();
    _controller?.dispose();
  }

  Widget widgetMedia() {
    print("taille $listeMedia.length");
    return new PageView(
      controller: _controller,
      children: listeMedia,
    );
  }

  GridView grille = new GridView.count(
    padding: EdgeInsets.all(10),
    scrollDirection: Axis.vertical,
    crossAxisCount: 2,
    children: [
      new IconeMedia(source: "images/film.png", liste: listeMedia),
      new IconeMedia(source: "images/Media/bd.jpg", liste: listeMedia),
      new IconeMedia(source: "images/Media/livres.jpg", liste: listeMedia),
      new IconeMedia(source: "images/Media/series.jpg", liste: listeMedia),
      new IconeMedia(source: "images/Media/journaux.jpg", liste: listeMedia),
      new IconeMedia(source: "images/Media/sport.jpg", liste: listeMedia),
    ],
  );

  void ajoutListe(Widget w) {
    listeMedia.add(w);
    /*if (_controller != null)
      _controller.animateToPage(
        1,
        curve: Curves.easeIn,
        duration: Duration(seconds: 1),
      );*/
  }

  /*callback() {
    setState(() {
      listeMedia.add(Container(
        color: Colors.blue,
      ));
    });
  }*/

  void allerA(int page) {
    _controller.animateToPage(
      page,
      curve: Curves.easeIn,
      duration: Duration(seconds: 1),
    );
  }
}

class IconeMedia extends InkWell {
  final Media media = null;

  IconeMedia(
      {Key key, String source, List<Widget> liste, CallbackHandle handle})
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
            liste.add(Container(
              color: Colors.blue,
            ));
            _controller.animateToPage(1,
                curve: Curves.easeIn, duration: Duration(seconds: 1));
          },
        );
}

enum Media { film, bd, series, sport, journaux, radio }
