import 'package:flutter/material.dart';

class RowWidget extends StatelessWidget {
  final int index;

  RowWidget({this.index});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.directions_car,
        color: Colors.lightGreen,
        size: 48,
      ),
      title: Text('Car $index'),
      subtitle: Text('Very Cool'),
      trailing: Icon(
        (index % 3).isEven ? Icons.bookmark_border : Icons.bookmark,
      ),
      onTap: () => print('Tapped on Row $index'),
    );
  }
}
