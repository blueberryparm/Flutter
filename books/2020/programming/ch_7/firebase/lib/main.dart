import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './pages/login_page.dart';
import './pages/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(FirebaseAuth.instance.currentUser != null));
}

class MyApp extends StatelessWidget {
  MyApp(this.isSignedIn);

  final bool isSignedIn;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fire Base',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isSignedIn ? ChatPage() : LoginPage(),
    );
  }
}
