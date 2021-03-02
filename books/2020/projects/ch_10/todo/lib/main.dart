import 'package:flutter/material.dart';
import './screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todos BloC',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Home(),
    );
  }
}