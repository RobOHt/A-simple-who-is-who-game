import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  // directory is the path to the intented image for display.
  final String directory;

  Picture(this.directory);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 100,
        maxHeight: 300,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Image.asset(directory),
      ),
    );
  }
}

class Instruction extends StatelessWidget {
  final int corrects;
  final int total;

  Instruction(this.corrects, this.total);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Center(
        child: Text(
          "You have $corrects out of $total corrects",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ShowAnswer extends StatelessWidget {
  final List answer;

  ShowAnswer(this.answer);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: ListView.builder(
        itemCount: answer.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Text(
              answer[index],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
