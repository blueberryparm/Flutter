import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Widget Tree',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Widget Tree'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1
                  _buildHorizontalRow(),
                  // 2
                  Padding(padding: EdgeInsets.all(16)),
                  // 3
                  _buildRowAndColumn(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRowAndColumn() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              color: Colors.yellow,
              height: 60,
              width: 60,
            ),
            Padding(padding: EdgeInsets.all(16)),
            Container(
              color: Colors.amber,
              height: 40,
              width: 40,
            ),
            Padding(padding: EdgeInsets.all(16)),
            Container(
              color: Colors.brown,
              height: 20,
              width: 20,
            ),
            Divider(),
            _buildRowAndStack(),
            Divider(),
            Text('End of the Line'),
          ],
        ),
      ],
    );
  }

  Row _buildRowAndStack() {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: Colors.lightGreen,
          radius: 100,
          child: Stack(
            children: [
              Container(
                color: Colors.yellow,
                height: 100,
                width: 100,
              ),
              Container(
                color: Colors.amber,
                height: 60,
                width: 60,
              ),
              Container(
                color: Colors.brown,
                height: 40,
                width: 40,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row _buildHorizontalRow() {
    return Row(
      children: [
        Container(
          color: Colors.yellow,
          height: 40,
          width: 40,
        ),
        Padding(padding: EdgeInsets.all(16)),
        Expanded(
          child: Container(
            color: Colors.amber,
            height: 40,
            width: 40,
          ),
        ),
        Padding(padding: EdgeInsets.all(16)),
        Container(
          color: Colors.brown,
          height: 40,
          width: 40,
        ),
      ],
    );
  }
}
