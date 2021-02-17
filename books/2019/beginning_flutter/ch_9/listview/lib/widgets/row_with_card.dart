import 'package:flutter/material.dart';

class RowWithCardWidget extends StatelessWidget {
  final int index;

  RowWithCardWidget({@required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.flight,
          color: Colors.lightBlue,
          size: 48,
        ),
        title: Text('Airplane $index'),
        subtitle: Text('Very Cool'),
        trailing: Text(
          '${index * 7}%',
          style: TextStyle(color: Colors.lightBlue),
        ),
        onTap: () => print('Tapped on Row $index'),
      ),
    );
  }
}
