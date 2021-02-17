import 'package:flutter/material.dart';
import '../widgets/counter_action_button.dart';

enum CounterAction { Increment, Decrement, Reset }

class CounterPage extends StatefulWidget {
  CounterPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _counter;

  @override
  void initState() {
    _counter = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 200,
                width: 200,
                //margin: EdgeInsets.only(bottom: 100.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: FlutterLogo(),
              ),
              Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: TextStyle(fontSize: 30),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CounterActionButton(
                    title: 'Decrement',
                    color: Colors.red,
                    onPressed: () => counterAction(CounterAction.Decrement),
                  ),
                  CounterActionButton(
                    title: 'Increment',
                    color: Colors.green,
                    onPressed: () => counterAction(CounterAction.Increment),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Reset Counter',
        child: Icon(Icons.refresh),
        onPressed: () => counterAction(CounterAction.Reset),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void counterAction(CounterAction action) {
    switch (action) {
      case CounterAction.Increment:
        _counter++;
        break;
      case CounterAction.Decrement:
        _counter--;
        break;
      case CounterAction.Reset:
        _counter = 0;
        break;
    }
    setState(() => _counter = _counter);
  }
}
