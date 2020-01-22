import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

import './Picture.dart';
import './Button.dart';
import './FinishPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  List<dynamic> classmates = [];
  var indexer = 0;
  List chosenIndexers = [];
  var corrects = 0;
  var tries = 0;

  var maxRequired = 20;
  var countdownTimeRequired = 10;

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  var flipped = false;

  String path;

  //String path;

  Duration timerDuration;
  RestartableTimer timer;

  Future getDir() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    setState(() {
      path = appDir.path;
    });
  }

  Future parseClassmates() async {
    print("init");
    String content = await rootBundle.loadString("data/classmates.json");
    List collection = json.decode(content);
    setState(() {
      classmates = collection;
    });
  }

  void refreshJsonList(newJsonList) {
    setState(() {
      classmates = classmates + newJsonList;
      print(classmates[classmates.length - 1]);
    });
  }

  void count() {
    setState(() {
      timerDuration = new Duration(seconds: countdownTimeRequired);
      timer = new RestartableTimer(timerDuration, IDontKnowThis);
    });
  }

  void initState() {
    getDir();
    super.initState();
    parseClassmates();
    count();
  }

  void IKnowThis() {
    setState(() {
      timer.reset();
      corrects = corrects + 1;
      tries = tries + 1;
      //classmates.removeAt(indexer);
      chosenIndexers.add(indexer);
      print("have chosen indexers: $chosenIndexers");

      var rng = new Random();
      indexer = rng.nextInt(classmates.length);
      while (chosenIndexers.contains(indexer)) {
        indexer = rng.nextInt(classmates.length);
        print("rechosen $indexer");
      }
      print("found good indexer $indexer");

      print(classmates.length);
      print(indexer);
    });
  }

  void IDontKnowThis() {
    setState(() {
      if (!flipped) {
        timer.reset();
        cardKey.currentState.toggleCard();
        flipped = true;
      } else if (flipped) {
        timer.reset();
        corrects = corrects + 0;
        tries = tries + 1;

        var rng = new Random();
        indexer = rng.nextInt(classmates.length);
        while (chosenIndexers.contains(indexer)) {
          indexer = rng.nextInt(classmates.length);
          print("rechosen $indexer");
        }
        print("found good indexer $indexer");

        cardKey.currentState.toggleCard();
        flipped = false;
      }
    });
  }

  void restart() {
    print("restart");

    setState(() {
      timer.reset();
      corrects = 0;
      tries = 0;
      chosenIndexers = [];
      print("restart finished");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Who is Who?'),
          backgroundColor: Colors.indigo,
        ),
        body: tries < maxRequired
            ? Container(
                width: double.infinity,
                child: Column(
                  children: <Widget>[
                    FlipCard(
                      key: cardKey,
                      flipOnTouch: false,
                      front: Container(
                        width: double.infinity,
                        height: 500,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Colors.indigo,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Picture(classmates[indexer]['img']),
                            Instruction(corrects, maxRequired),
                            Button(IKnowThis, "I know this!"),
                          ],
                        ),
                      ),
                      back: Container(
                        width: double.infinity,
                        height: 500,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Colors.indigo,
                        ),
                        child: Center(
                          child: flipped
                              ? ShowAnswer(classmates[indexer]['name'])
                              : Text(
                                  "Prepare !!!",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    !flipped
                        ? Button(IDontKnowThis, "I give up.")
                        : Button(IDontKnowThis, "Next!")
                  ],
                ),
              )
            : FinishPage(
                corrects,
                maxRequired,
                path,
                refreshJsonList,
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: restart,
          tooltip: 'restart',
          child: Icon(Icons.restore),
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }
}
