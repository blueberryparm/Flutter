import 'package:flutter/material.dart';
import 'about.dart';
import 'gratitude.dart';

class Home extends StatefulWidget {
  static const routeName = 'home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _howAreYou = '_';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigator'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _openPageAbout(
              context: context,
              fullScreenDialog: true,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Grateful for: $_howAreYou',
            style: TextStyle(fontSize: 32),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Gratitude',
        onPressed: () => _openPageGratitude(context: context),
        child: Icon(Icons.sentiment_satisfied),
      ),
    );
  }

  void _openPageAbout({BuildContext context, bool fullScreenDialog = false}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) => About(),
      ),
    );
  }

  void _openPageGratitude(
      {BuildContext context, bool fullScreenDialog = false}) async {
    final String _gratitudeResponse = await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: fullScreenDialog,
        builder: (context) => Gratitude(
          radioGroupValue: -1,
        ),
      ),
    );

    _howAreYou = _gratitudeResponse ?? '';
  }
}
