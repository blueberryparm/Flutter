import 'package:flutter/material.dart';

class AnimatedContainerWidget extends StatefulWidget {
  @override
  _AnimatedContainerWidgetState createState() =>
      _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> {
  double _height = 100;
  double _width = 100;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          height: _height,
          width: _width,
          color: Colors.amber,
          child: FlatButton(
            child: Text('Tap to\nGrow Width\n$_width'),
            onPressed: _increaseWidth,
          ),
        ),
      ],
    );
  }

  void _increaseWidth() {
    setState(() {
      _width = _width >= 320 ? 100 : _width += 50;
    });
  }
}
