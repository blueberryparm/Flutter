import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './utils/themes/app_theme.dart';
import './screens/favors_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        //theme: lightCupertinoTheme,
        home: FavorsPage(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friend Favors',
      theme: lightTheme,
      home: FavorsPage(),
    );
  }
}
