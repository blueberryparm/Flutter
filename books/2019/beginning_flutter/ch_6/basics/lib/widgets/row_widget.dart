import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            Text('Row 1'),
            Padding(padding: EdgeInsets.all(16)),
            Text('Row 2'),
            Padding(padding: EdgeInsets.all(16)),
            Text('Row 3'),
          ],
        ),
      ],
    );
  }
}
