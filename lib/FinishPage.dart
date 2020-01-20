import 'package:flutter/material.dart';

class FinishPage extends StatelessWidget {
  final int corrects;
  final int total;
  String rating;

  FinishPage(this.corrects, this.total);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Center(
        child: Text(
          "Congratulations! You have finished this round of testing.\n" 
          "Your got $corrects out of $total corrects!\n",
          style: TextStyle(
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
