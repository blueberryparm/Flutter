import 'package:flutter/material.dart';

class AnimatedOpacityWidget extends StatefulWidget {
  @override
  _AnimatedOpacityWidgetState createState() => _AnimatedOpacityWidgetState();
}

class _AnimatedOpacityWidgetState extends State<AnimatedOpacityWidget> {
  double _opacity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedOpacity(
          opacity: _opacity,
          duration: Duration(milliseconds: 500),
          child: Container(
            height: 100,
            width: 100,
            color: Colors.amber,
            child: FlatButton(
              child: Text('Tap to Fade'),
              onPressed: _animatedOpacity,
            ),
          ),
        ),
      ],
    );
  }

  void _animatedOpacity() => setState(() => _opacity = _opacity == 1 ? 0.3 : 1);
}
