import 'package:flutter/material.dart';
import './pages/calculator_home_page.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.black26,
      ),
      home: CalculatorHomePage(
        title: 'Flutter Calculator',
      ),
    );
  }
}
