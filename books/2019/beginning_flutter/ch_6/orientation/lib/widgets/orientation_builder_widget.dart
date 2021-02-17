import 'package:flutter/material.dart';

class OrientationBuilderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Container(
          alignment: Alignment.center,
          height: 100,
          width: orientation == Orientation.portrait ? 100 : 200,
          color: orientation == Orientation.portrait
              ? Colors.yellow
              : Colors.lightGreen,
          child: Text(
            orientation == Orientation.portrait ? 'Portrait' : 'Landscape',
          ),
        );
      },
    );
  }
}
