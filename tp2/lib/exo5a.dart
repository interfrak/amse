import 'package:flutter/material.dart';

class Plateau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Plateau fixe'),
          centerTitle: true,
        ),
        body: Center(
            child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            var indice = index + 1;
            return Container(
              child: Card(
                color: Colors.blue,
                child: Text('Tile$indice'),
              ),
            );
          }),
        )));
  }
}
