import 'dart:async';

enum CounterAction { Increment, Decrement, Reset }

class CounterBloc {
  int _counter;
  final StreamController<CounterAction> _eventStreamController =
      StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => _eventStreamController.sink;
  Stream<CounterAction> get _eventStream => _eventStreamController.stream;

  final StreamController<int> _counterStreamController =
      StreamController<int>();
  StreamSink<int> get _counterSink => _counterStreamController.sink;
  Stream<int> get counterStream => _counterStreamController.stream;

  CounterBloc() {
    _counter = 0;
    _eventStream.listen((event) {
      switch (event) {
        case CounterAction.Increment:
          _counter++;
          break;
        case CounterAction.Decrement:
          _counter--;
          break;
        default:
          _counter = 0;
      }
      _counterSink.add(_counter);
    });
  }

  void dispose() {
    _eventStreamController.close();
    _counterStreamController.close();
  }
}
