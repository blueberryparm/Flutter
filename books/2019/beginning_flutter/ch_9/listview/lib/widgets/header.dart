import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final int index;

  HeaderWidget({@required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 120,
      child: Card(
        elevation: 8,
        color: Colors.white,
        //shape: StadiumBorder(),
        // shape: UnderlineInputBorder(
        //   borderSide: BorderSide(color: Colors.deepOrange),
        // ),
        // shape: OutlineInputBorder(
        //   borderSide: BorderSide(color: Colors.deepOrange.withOpacity(0.5)),
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Barista',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 48,
                color: Colors.orange,
              ),
            ),
            Text(
              'Travel Plans',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
