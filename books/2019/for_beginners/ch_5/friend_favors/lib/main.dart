import 'package:flutter/material.dart';
import './screens/favors_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friend Favors',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FavorsPage(),
    );
  }
}
