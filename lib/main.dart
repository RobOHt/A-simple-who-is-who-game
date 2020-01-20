import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  var classmates = const [];
  var indexer = 0;
  var corrects = 0;

  Future parseClassmates() async {
    String content = await rootBundle.loadString("data/classmates.json");
    List collection = json.decode(content);
    setState(() {
      classmates = collection;
    });
  }

  void initState() {
    parseClassmates();
    super.initState();
    print(classmates);
  }

  void IKnowThis() {
    setState(() {
      indexer = indexer + 1;
      corrects = corrects + 1;
    });
  }

  void IDontKnowThis() {
    setState(() {
      indexer = indexer + 1;
      corrects = corrects + 0;
    });
  }

  void restart() {
    setState(() {
      indexer = 0;
      corrects = 0;
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
        body: indexer < classmates.length
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
                            Instruction(corrects, classmates.length),
                            Button(IKnowThis, "I know this!"),
                          ],
                        )),
                    Button(IDontKnowThis, "I give up."),
                  ],
                ),
              )
            : FinishPage(corrects, classmates.length),
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
