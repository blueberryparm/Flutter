import 'package:flutter/material.dart';

class About extends StatelessWidget {
  static const routeName = 'about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('About Page'),
        ),
      ),
    );
  }
}
