import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}




extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String millisecondsText = "";
  GameState gameState = GameState.readyToStart;

  Timer? waitingTimer;
  Timer? stoppableTimer;

hexColor (String colorhexcode) {
  String colornew = "0xff" + colorhexcode;
  colornew = colornew.replaceAll('#', '');
  int colorint = int.parse(colornew);
  return colorint;
}

  Color _buttonColor1 = Colors.green;
  Color _buttonColor2 = Colors.yellow;
  Color _buttonColor3 = Colors.red;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'FF282E3D'.toColor(),
      body: Stack(
        children: [
          Align(
            alignment: const Alignment(0.0, -0.8),
            child: Text(
              "Test your\nreaction speed", // ВЕРХНЯЯ ЧАСТЬ
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),

            ),
          ),


          Align(

            alignment: const Alignment(0, 0.8),
            child: GestureDetector(

              onTap: () => setState(() {
                switch(gameState){
                  case GameState.readyToStart:
                    gameState = GameState.waiting;
                    millisecondsText = "";
                    _startWaitingTimer();
                    break;
                  case GameState.waiting:
                    _buttonColor2;
                    break;
                  case GameState.canBeStopped:
                    gameState = GameState.readyToStart;
                    stoppableTimer?.cancel();
                    break;
                }
              }),
              child: ColoredBox(
                color: Colors.green,  // START подложка
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Center( // СТАРТ
                    child: Text(
                      _getButtonText(),
                      style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center, // ЦЕНТРАЛЬНЫЙ БОКС
            child: ColoredBox(
              color: Color(hexColor("FF6D6D6D")),
              child: SizedBox(
                height: 160,
                width: 300,
                child: Center(
                    child: Text(
                      millisecondsText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText() {
    switch (gameState) {
      case GameState.readyToStart:
        return "START";
      case GameState.waiting:
        return "WAIT";
      case GameState.canBeStopped:
        return "STOP";

    }
  }

  void _startWaitingTimer() {
    final int randomMilliseconds = Random().nextInt(4000) + 1000;

    waitingTimer = Timer(Duration(milliseconds: randomMilliseconds), (){

      setState(() {
      gameState = GameState.canBeStopped;
    });
      _startStoppableTimer();
    });
  }

  @override
  void dispose() {
    waitingTimer?.cancel();
    stoppableTimer?.cancel();
    super.dispose();
  }

  void _startStoppableTimer() {
    stoppableTimer = Timer.periodic(Duration(milliseconds: 16), (timer) {
      setState(() {
        millisecondsText = "${timer.tick * 16} ms";
      });
    });
  }
}

enum GameState { readyToStart, waiting, canBeStopped}