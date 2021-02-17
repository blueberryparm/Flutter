import 'package:flutter/material.dart';

class AnimatedCrossFadeWidget extends StatefulWidget {
  @override
  _AnimatedCrossFadeWidgetState createState() =>
      _AnimatedCrossFadeWidgetState();
}

class _AnimatedCrossFadeWidgetState extends State<AnimatedCrossFadeWidget> {
  bool _crossFadeStateShowFirst = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            AnimatedCrossFade(
              duration: Duration(milliseconds: 500),
              sizeCurve: Curves.bounceOut,
              crossFadeState: _crossFadeStateShowFirst
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Container(
                height: 100,
                width: 100,
                color: Colors.amber,
              ),
              secondChild: Container(
                height: 200,
                width: 200,
                color: Colors.lime,
              ),
            ),
            Positioned.fill(
              child: FlatButton(
                child: Text('Tap to\nFade Color & Size'),
                onPressed: _crossFade,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _crossFade() {
    setState(() =>
        _crossFadeStateShowFirst = _crossFadeStateShowFirst ? false : true);
  }
}
