import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../shared/authentication.dart';
import 'login_screen.dart';
import 'event_screen.dart';

class LaunchScreen extends StatefulWidget {
  @override
  _LaunchScreenState createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MaterialPageRoute route;
      Authentication auth = Authentication();
      try {
        User user = auth.getUser();
        if (user != null)
          route =
              MaterialPageRoute(builder: (context) => EventScreen(user.uid));
        else
          route = MaterialPageRoute(builder: (context) => LoginScreen());
        Navigator.pushReplacement(context, route);
      } catch (err) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
