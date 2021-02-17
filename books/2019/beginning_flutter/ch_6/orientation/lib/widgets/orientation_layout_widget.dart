import 'package:flutter/material.dart';

class OrientationLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    return Container(
      alignment: Alignment.center,
      color: _orientation == Orientation.portrait
          ? Colors.yellow
          : Colors.lightGreen,
      height: 100,
      width: _orientation == Orientation.portrait ? 100 : 200,
      child: Text(
        _orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
      ),
    );
  }
}
