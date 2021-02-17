import 'package:flutter/material.dart';

class StackWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image(
          image: AssetImage(
            'assets/images/tree.jpg',
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: CircleAvatar(
            radius: 48,
            backgroundImage: AssetImage(
              'assets/images/lion.jpg',
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          right: 15,
          child: Text(
            'Lion',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white30,
            ),
          ),
        ),
      ],
    );
  }
}
