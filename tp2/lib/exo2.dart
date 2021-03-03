import 'dart:math';
import 'package:flutter/material.dart';

class Exo2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Exercice 2');
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentSliderValueX = 0;
  double _currentSliderValueZ = 0;
  bool checkBoxValue = false;
  double valMirror = 0;
  double _currentSliderValueS = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(children: [
          Container(
              padding: EdgeInsets.only(top: 30, bottom: 20),
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(color: Colors.white),
              child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.diagonal3Values(_currentSliderValueS,
                      _currentSliderValueS, _currentSliderValueS),
                  child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(valMirror),
                      child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationZ(
                              (_currentSliderValueZ) * pi / 2),
                          child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(
                                  (_currentSliderValueX) * pi / 2),
                              child: Image(
                                image:
                                    NetworkImage('https://picsum.photos/256'),
                              )))))),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text("Rotate X: "),
                  Expanded(
                      child: Slider(
                    value: _currentSliderValueX,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValueX = value;
                      });
                    },
                  ))
                ],
              )),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text("Rotate Z: "),
                  Expanded(
                      child: Slider(
                    value: _currentSliderValueZ,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValueZ = value;
                      });
                    },
                  ))
                ],
              )),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text("Mirror: "),
                  Checkbox(
                      value: checkBoxValue,
                      activeColor: Colors.green,
                      onChanged: (bool newValue) {
                        setState(() {
                          checkBoxValue = newValue;
                          if (checkBoxValue == true) {
                            valMirror = pi;
                          } else {
                            valMirror = 0;
                          }
                        });
                      })
                ],
              )),
          Container(
              padding: EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Text("Scale: "),
                  Expanded(
                      child: Slider(
                    value: _currentSliderValueS,
                    onChanged: (double value) {
                      setState(() {
                        _currentSliderValueS = value;
                      });
                    },
                  ))
                ],
              ))
        ]));
  }
}
