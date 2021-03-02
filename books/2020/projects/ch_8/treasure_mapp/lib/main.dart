import 'package:flutter/material.dart';
import './screens/main_map.dart';

void main() => runApp(TreasureMapApp());

class TreasureMapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Treasure Mapp',
      home: MainMap(),
    );
  }
}
