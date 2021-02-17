import 'package:flutter/material.dart';
import './pages/home.dart';
// import './pages/about.dart';
// import './pages/gratitude.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: Home.routeName,
      // routes: {
      //   Home.routeName : (context) => Home(),
      //   About.routeName : (context) => About(),
      //   Gratitude.routeName : (context) => Gratitude(radioGroupValue: -1),
      // },
      home: Home(),
    );
  }
}
