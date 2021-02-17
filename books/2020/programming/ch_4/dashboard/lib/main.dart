import 'dart:async';

import 'package:flutter/material.dart';
import './pages/home.dart';

void main() => runApp(BatteryApp());

class BatteryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Battery and Connectivity Status',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(
        title: 'Dashboard',
      ),
    );
  }
}
