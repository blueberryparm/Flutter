import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _gestureDetected = 'No Gesture Detected';
  Color _paintedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gesture & Drag and Drop'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildGestureDetector(),
              Divider(
                height: 44,
                color: Colors.black,
              ),
              _buildDraggable(),
              Divider(
                height: 40,
              ),
              _buildDragTarget(),
              Divider(
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _buildGestureDetector() => GestureDetector(
        onTap: () {
          print('onTap');
          _displayGestureDetected('onTap');
        },
        onDoubleTap: () {
          print('onDoubleTap');
          _displayGestureDetected('onDoubleTap');
        },
        onLongPress: () {
          print('onLongPress');
          _displayGestureDetected('onLongPress');
        },
        onPanUpdate: (DragUpdateDetails details) {
          print('onPanUpdate: $details');
          _displayGestureDetected('onPanUpdate:\n$details');
        },
        // onVerticalDragUpdate: (DragUpdateDetails details) {
        //   print('onVerticalDragUpdate: $details');
        //   _displayGestureDetected('onVerticalDragUpdate\n$details');
        // },
        // onHorizontalDragUpdate: (DragUpdateDetails details) {
        //   print('onHorizontalDragUpdate: $details');
        //   _displayGestureDetected('onHorizontalDragUpdate:\n$details');
        // },
        // onHorizontalDragEnd: (DragEndDetails details) {
        //   print('onHorizontalDragEnd: $details');
        //   if (details.primaryVelocity < 0)
        //     print('Dragging Right to Left: ${details.velocity}');
        //   else if (details.primaryVelocity > 0)
        //     print('Dragging Left to Right ${details.velocity}');
        // },
        child: Container(
          padding: EdgeInsets.all(24),
          width: double.infinity,
          color: Colors.lightGreen.shade100,
          child: Column(
            children: [
              Icon(Icons.access_alarm, size: 98),
              Text('$_gestureDetected'),
            ],
          ),
        ),
      );

  void _displayGestureDetected(String gesture) =>
      setState(() => _gestureDetected = gesture);

  Draggable<int> _buildDraggable() => Draggable(
        child: Column(
          children: [
            Icon(
              Icons.palette,
              color: Colors.deepOrange,
              size: 48,
            ),
            Text('Drag Me below to change color'),
          ],
        ),
        childWhenDragging: Icon(
          Icons.palette,
          color: Colors.grey,
          size: 48,
        ),
        feedback: Icon(
          Icons.brush,
          color: Colors.deepOrange,
          size: 80,
        ),
        data: Colors.deepOrange.value,
      );

  DragTarget<int> _buildDragTarget() => DragTarget<int>(
        onAccept: (colorValue) => _paintedColor = Color(colorValue),
        builder: (BuildContext context, List<dynamic> acceptedData,
                List<dynamic> rejectedData) =>
            acceptedData.isEmpty
                ? Text(
                    'Drag To and see color change',
                    style: TextStyle(color: _paintedColor),
                  )
                : Text(
                    'Painting Color: $acceptedData',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(acceptedData[0]),
                    ),
                  ),
      );
}
