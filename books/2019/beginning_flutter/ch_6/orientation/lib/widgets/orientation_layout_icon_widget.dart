import 'package:flutter/material.dart';

class OrientationLayoutIconsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.school,
          size: 48,
        ),
        if (_orientation == Orientation.landscape)
          Icon(
            Icons.brush,
            size: 48,
          ),
      ],
    );
  }
}
