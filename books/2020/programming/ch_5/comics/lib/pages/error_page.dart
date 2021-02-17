import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error Page'),
      ),
      body: Column(
        children: [
          Icon(Icons.not_interested),
          Text("The comics you have selected doesn't exist or isn't available"),
        ],
      ),
    );
  }
}
