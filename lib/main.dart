import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:async/async.dart';

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

class _MyAppState extends State<MyApp> {
  var classmates = [];
  var indexer = 0;
  var corrects = 0;
  var tries = 0;

  var maxRequired = 20;
  var countdownTimeRequired = 10;

  Duration timerDuration;
  RestartableTimer timer;

  Future parseClassmates() async {
    print("init");
    String content = await rootBundle.loadString("data/classmates.json");
    List collection = json.decode(content);
    setState(() {
      classmates = collection;
    });
  }

  void count() {
    setState(() {
      timerDuration = new Duration(seconds: countdownTimeRequired);
      timer = new RestartableTimer(timerDuration, IDontKnowThis);
    });
  }

  void initState() {
    parseClassmates();
    count();
    super.initState();
  }

  void IKnowThis() {
    setState(() {
      timer.reset();
      corrects = corrects + 1;
      tries = tries + 1;
      classmates.removeAt(indexer);

      var rng = new Random();
      indexer = rng.nextInt(classmates.length);
      //print(indexer);
      //print(classmates.length);
    });
  }

  void IDontKnowThis() {
    setState(() {
      timer.reset();
      corrects = corrects + 0;
      tries = tries + 1;

      var rng = new Random();
      indexer = rng.nextInt(classmates.length);
      //print(indexer);
      //print(classmates.length);
    });
  }

  void restart() {
    print("restart");
    parseClassmates();
    setState(() {
      timer.reset();
      corrects = 0;
      tries = 0;
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
                  children: [
                    Container(
                        width: double.infinity,
                        height: 500,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          color: Colors.indigo,
                        ),
                        child: Column(
                          children: [
                            Picture(classmates[indexer]['img']),
                            Instruction(corrects, maxRequired),
                            Button(IKnowThis, "I know this!"),
                          ],
                        )),
                    Button(IDontKnowThis, "I give up."),
                  ],
                ),
              )
            : FinishPage(corrects, maxRequired),
        floatingActionButton: FloatingActionButton(
          onPressed: restart,
          tooltip: 'Increment',
          child: Icon(Icons.restore),
          backgroundColor: Colors.indigo,
        ),
      ),
    );
  }
}
