import 'package:flutter/material.dart';
import '../blocs/counter_bloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _counterBloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter Bloc'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
              initialData: 0,
              stream: _counterBloc.counterStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) => Text(
                '${snapshot.data}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            tooltip: 'Increment',
            onPressed: () =>
                _counterBloc.eventSink.add(CounterAction.Increment),
            child: Icon(Icons.add),
          ),
          FloatingActionButton(
            tooltip: 'Decrement',
            onPressed: () =>
                _counterBloc.eventSink.add(CounterAction.Decrement),
            child: Icon(Icons.remove),
          ),
          FloatingActionButton(
            tooltip: 'Reset',
            onPressed: () => _counterBloc.eventSink.add(CounterAction.Reset),
            child: Icon(Icons.loop),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _counterBloc.dispose();
  }
}
