import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';
import './utils/themes/app_theme.dart';
import './pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //ca-app-pub-3940256099942544/3419835294
  FirebaseAdMob.instance
      .initialize(appId: 'ca-app-pub-3390734983687453~4199568450');
  // FirebaseAdMob.instance.initialize(
  //   appId: Platform.isAndroid
  //       ? 'ca-app-pub-3390734983687453~4199568450'
  //       : 'ca-app-pub-3390734983687453~5328160759',
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoApp(
        //theme: lightCupertinoTheme,
        home: LoginPage(),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Friend Favors',
      theme: lightTheme,
      home: LoginPage(),
    );
  }
}
