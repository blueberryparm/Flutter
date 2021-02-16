import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:battery/battery.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(title: 'Flutter Platform Channel API'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Battery _battery = Battery();

  BatteryState _batteryState;
  StreamSubscription<BatteryState> _batteryStateSubscription;
  String _batteryLevel = 'Battery Levels are Unknown';

  @override
  void initState() {
    super.initState();
    _batteryStateSubscription = _battery.onBatteryStateChanged.listen(
      (BatteryState state) {
        setState(() => _batteryState = state);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_batteryState'),
            Text('Click the button to know your phone battery levels'),
            RaisedButton(
              padding: EdgeInsets.all(0),
              textColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[Colors.red, Colors.green, Colors.brown],
                  ),
                ),
                child: Text('Get Phone Battery Level'),
              ),
              onPressed: _getPhoneBatteryLevel,
            ),
            Text(_batteryLevel),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_batteryStateSubscription != null) {
      _batteryStateSubscription.cancel();
    }
  }

  Future<void> _getPhoneBatteryLevel() async {
    try {
      final int batteryLevel = await _battery.batteryLevel;
      _batteryLevel = 'Battery level at $batteryLevel % .';
    } on PlatformException catch (e) {
      _batteryLevel = 'Failed to get battery level: ${e.message}';
    }

    setState(() => _batteryLevel = _batteryLevel);
  }
}
