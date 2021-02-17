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
                  RowWidget(),
                  // 2
                  Padding(padding: EdgeInsets.all(16)),
                  // 3
                  RowAndColumnWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RowAndColumnWidget extends StatelessWidget {
  const RowAndColumnWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            RowAndStackWidget(),
            Divider(),
            Text('End of the Line'),
          ],
        ),
      ],
    );
  }
}

class RowAndStackWidget extends StatelessWidget {
  const RowAndStackWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class RowWidget extends StatelessWidget {
  const RowWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('RowWidget');
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
