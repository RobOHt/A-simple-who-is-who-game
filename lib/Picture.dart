import 'package:flutter/material.dart';

class Picture extends StatelessWidget {
  final String directory;

  Picture(this.directory);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        image: DecorationImage(
          image: AssetImage(directory),
          //fit: BoxFit.fill,
        ),
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
