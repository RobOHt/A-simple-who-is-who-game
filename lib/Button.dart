import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function doIKnowThis;
  final String choice;

  Button(this.doIKnowThis, this.choice);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.indigo,
      ),
      child: 
      choice == "I give up."
      ? RaisedButton(
        child: Text(choice),
        onPressed: doIKnowThis,
        color: Colors.deepOrange[300],
      )
      : RaisedButton(
        child: Text(choice),
        onPressed: doIKnowThis,
        color: Colors.green[300],
      ),
    );
  }
}
