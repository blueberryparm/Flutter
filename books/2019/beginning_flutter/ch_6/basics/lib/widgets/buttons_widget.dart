import 'package:flutter/material.dart';

class ButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(padding: EdgeInsets.all(16)),
            FlatButton(
              onPressed: () {},
              child: Text('Flag'),
            ),
            Padding(padding: EdgeInsets.all(16)),
            FlatButton(
              color: Colors.lightGreen,
              textColor: Colors.white,
              onPressed: () {},
              child: Icon(Icons.flag),
            ),
          ],
        ),
        Divider(),
        Row(
          children: [
            Padding(padding: EdgeInsets.all(16)),
            RaisedButton(
              onPressed: () {},
              child: Text('Save'),
            ),
            Padding(padding: EdgeInsets.all(16)),
            RaisedButton(
              color: Colors.lightGreen,
              onPressed: () {},
              child: Icon(
                Icons.save,
              ),
            ),
          ],
        ),
        Divider(),
        Row(
          children: [
            Padding(padding: EdgeInsets.all(16)),
            IconButton(
              icon: Icon(Icons.flight),
              onPressed: () {},
            ),
            Padding(padding: EdgeInsets.all(16)),
            IconButton(
              icon: Icon(Icons.flight),
              iconSize: 42,
              color: Colors.lightGreen,
              tooltip: 'Flight',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
