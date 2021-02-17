import 'package:flutter/material.dart';

class CounterActionButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;

  CounterActionButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }
}
