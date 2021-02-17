import 'package:flutter/material.dart';
import '../models/calculation.dart';
import '../widgets/calculator_button.dart';
import '../utils/divide_by_zero_exception.dart';

class CalculatorHomePage extends StatefulWidget {
  final String title;

  CalculatorHomePage({this.title});

  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _str = '0';
  var _calculation = Calculation();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            calculatorScreen(_str),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: CalculatorButton(
                      color: Colors.black54,
                      title: 'C',
                      onPressed: () => deleteAll(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: CalculatorButton(
                      color: Colors.black87,
                      title: '<-',
                      onPressed: () => deleteOne(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CalculatorButton(
                                title: '7',
                                onPressed: () => add('7'),
                              ),
                              CalculatorButton(
                                title: '8',
                                onPressed: () => add('8'),
                              ),
                              CalculatorButton(
                                title: '9',
                                onPressed: () => add('9'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CalculatorButton(
                                title: '4',
                                onPressed: () => add('4'),
                              ),
                              CalculatorButton(
                                title: '5',
                                onPressed: () => add('5'),
                              ),
                              CalculatorButton(
                                title: '6',
                                onPressed: () => add('6'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CalculatorButton(
                                title: '1',
                                onPressed: () => add('1'),
                              ),
                              CalculatorButton(
                                title: '2',
                                onPressed: () => add('2'),
                              ),
                              CalculatorButton(
                                title: '3',
                                onPressed: () => add('3'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CalculatorButton(
                                title: '0',
                                onPressed: () => add('0'),
                              ),
                              CalculatorButton(
                                title: '.',
                                onPressed: () => add('.'),
                              ),
                              CalculatorButton(
                                color: Colors.blue[50],
                                title: '=',
                                onPressed: () => getResult(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: CalculatorButton(
                            color: Colors.blue[50],
                            title: '/',
                            onPressed: () => add('/'),
                          ),
                        ),
                        Expanded(
                          child: CalculatorButton(
                            color: Colors.blue[50],
                            title: 'x',
                            onPressed: () => add('x'),
                          ),
                        ),
                        Expanded(
                          child: CalculatorButton(
                            color: Colors.blue[50],
                            title: '-',
                            onPressed: () => add('-'),
                          ),
                        ),
                        Expanded(
                          child: CalculatorButton(
                            color: Colors.blue[50],
                            title: '+',
                            onPressed: () => add('+'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget calculatorScreen(String value) => Expanded(
        flex: 2,
        child: Card(
          color: Colors.lightGreen[50],
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              value,
              textScaleFactor: 2,
            ),
          ),
        ),
      );

  void add(String a) {
    setState(() {
      _calculation.add(a);
      _str = _calculation.getString();
    });
  }

  void deleteAll() {
    setState(() {
      _calculation.deleteAll();
      _str = _calculation.getString();
    });
  }

  void deleteOne() {
    setState(() {
      _calculation.deleteOne();
      _str = _calculation.getString();
    });
  }

  void getResult() {
    try {
      _str = _calculation.getResult().toString();
    } on DivideByZeroException {
      _str = 'You must not divide by 0';
    } finally {
      _calculation = Calculation();
    }
  }
}
