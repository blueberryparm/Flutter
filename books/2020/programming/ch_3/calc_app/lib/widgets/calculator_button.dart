import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;

  CalculatorButton({
    this.title,
    this.onPressed,
    this.color = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: color,
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }
}
