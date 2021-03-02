import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Measures Converter',
      home: MeasuresConverter(),
    );
  }
}

class MeasuresConverter extends StatefulWidget {
  @override
  _MeasuresConverterState createState() => _MeasuresConverterState();
}

class _MeasuresConverterState extends State<MeasuresConverter> {
  double _numberFrom = 0;
  String _startMeasure;
  String _convertedMeasure;
  double _result = 0;
  String _resultMessage = '';

  @override
  Widget build(BuildContext context) {
    double sizeX = MediaQuery.of(context).size.width;
    double sizeY = MediaQuery.of(context).size.height;
    final TextStyle inputStyle = TextStyle(
      fontSize: 20,
      color: Colors.blue[900],
    );
    final TextStyle labelStyle = TextStyle(
      fontSize: 24,
      color: Colors.grey[700],
    );

    final spacer = Padding(padding: EdgeInsets.only(bottom: sizeY / 40));
    final List<String> _measures = [
      'meters',
      'kilometers',
      'grams',
      'kilograms',
      'feet',
      'miles',
      'pounds (lbs)',
      'ounces',
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Measures Converter'),
      ),
      body: Container(
        width: sizeX,
        padding: EdgeInsets.all(sizeX / 20),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Text(
              'Value',
              style: labelStyle,
            ),
            spacer,
            TextField(
              style: inputStyle,
              decoration: InputDecoration(
                hintText: "Please insert the measure to be converted",
              ),
              onChanged: (text) =>
                  setState(() => _numberFrom = double.parse(text)),
            ),
            spacer,
            Text(
              'From',
              style: labelStyle,
            ),
            spacer,
            DropdownButton(
              isExpanded: true,
              style: inputStyle,
              value: _startMeasure,
              items: _measures.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: inputStyle,
                  ),
                );
              }).toList(),
              onChanged: (value) => onStartMeasureChanged(value),
            ),
            spacer,
            Text(
              'To',
              style: labelStyle,
            ),
            spacer,
            DropdownButton(
              isExpanded: true,
              style: inputStyle,
              value: _convertedMeasure,
              items: _measures.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: inputStyle,
                  ),
                );
              }).toList(),
              onChanged: (value) => onConvertedMeasureChanged(value),
            ),
            spacer,
            RaisedButton(
              child: Text('Convert', style: inputStyle),
              onPressed: convert,
            ),
            spacer,
            Text(
              _resultMessage,
              style: labelStyle,
            )
          ],
        )),
      ),
    );
  }

  void onStartMeasureChanged(String value) =>
      setState(() => _startMeasure = value);

  void onConvertedMeasureChanged(String value) =>
      setState(() => _convertedMeasure = value);

  void convert() {
    if (_startMeasure.isEmpty ||
        _convertedMeasure.isEmpty ||
        _numberFrom == 0) {
      return;
    }
    Conversion c = Conversion();
    double result = c.convert(_numberFrom, _startMeasure, _convertedMeasure);
    setState(() {
      _result = result;
      if (result == 0) {
        _resultMessage = 'This conversion cannot be performed';
      } else {
        _resultMessage =
            '${_numberFrom.toString()} $_startMeasure are ${_result.toString()} $_convertedMeasure';
      }
    });
  }
}

class Conversion {
  //helps transform the strings in numbers for the List
  final int w = 8;
  var formulas;
  Map<String, int> measures = {
    'meters': 0,
    'kilometers': 1,
    'grams': 2,
    'kilograms': 3,
    'feet': 4,
    'miles': 5,
    'pounds (lbs)': 6,
    'ounces': 7,
  };
  //builds the list containing the formulas
  //List<List<double>> formulas;
  Conversion() {
    formulas = {
      '0': [1, 0.001, 0, 0, 3.28084, 0.000621371, 0, 0],
      '1': [1000, 1, 0, 0, 3280.84, 0.621371, 0, 0],
      '2': [0, 0, 1, 0.0001, 0, 0, 0.00220462, 0.035274],
      '3': [0, 0, 1000, 1, 0, 0, 2.20462, 35.274],
      '4': [0.3048, 0.0003048, 0, 0, 1, 0.000189394, 0, 0],
      '5': [1609.34, 1.60934, 0, 0, 5280, 1, 0, 0],
      '6': [0, 0, 453.592, 0.453592, 0, 0, 1, 16],
      '7': [0, 0, 28.3495, 0.0283495, 3.28084, 0, 0.0625, 1],
    };
  }

  double convert(double value, String from, String to) {
    int nFrom = measures[from];
    int nTo = measures[to];
    var multiplier = formulas[nFrom.toString()][nTo];
    return value * multiplier;
  }
}
