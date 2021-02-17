import 'package:flutter/material.dart';

/*
  1 Add AnimationController
  2 Add Animation
  3 Initiate AnimationController with Duration(milliseconds, seconds)
  4 Initiate Animation with Tween with begin and end values and chain
    the animate method with CurvedAnimation
  5 Use the AnimatedBuilder with Animation using a Container with a
    balloon to start Animation by calling AnimationController.forward()
    and .reverse() to run the animation backward. The AnimatedBuilder
    widget that performs a reusable animation
*/

class AnimatedBalloonWidget extends StatefulWidget {
  @override
  _AnimatedBalloonWidgetState createState() => _AnimatedBalloonWidgetState();
}

class _AnimatedBalloonWidgetState extends State<AnimatedBalloonWidget>
    with TickerProviderStateMixin {
  AnimationController _controllerFloatUp;
  AnimationController _controllerGrowSize;
  Animation<double> _animationFloatUp;
  Animation<double> _animationGrowSize;

  @override
  void initState() {
    super.initState();
    _controllerFloatUp =
        AnimationController(duration: Duration(seconds: 4), vsync: this);
    _controllerGrowSize =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double _balloonHeight = MediaQuery.of(context).size.height / 2;
    double _balloonWidth = MediaQuery.of(context).size.width / 2;
    double _balloonBottomLocation =
        MediaQuery.of(context).size.height - _balloonHeight;
    _animationFloatUp = Tween(begin: _balloonBottomLocation, end: 0).animate(
        CurvedAnimation(
            parent: _controllerFloatUp, curve: Curves.fastOutSlowIn));
    _animationGrowSize = Tween(begin: 50, end: _balloonWidth).animate(
        CurvedAnimation(
            parent: _controllerGrowSize, curve: Curves.elasticInOut));

    return AnimatedBuilder(
      animation: _animationFloatUp,
      builder: (context, child) => Container(
        width: _animationGrowSize.value,
        margin: EdgeInsets.only(
          top: _animationFloatUp.value,
        ),
        child: child,
      ),
      child: GestureDetector(
        onTap: () {
          if (_controllerFloatUp.isCompleted) {
            _controllerFloatUp.reverse();
            _controllerGrowSize.reverse();
          } else {
            _controllerFloatUp.forward();
            _controllerGrowSize.forward();
          }
        },
        child: Image.asset(
          'assets/images/BeginningGoogleFlutter-Balloon.png',
          height: _balloonHeight,
          width: _balloonWidth,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerFloatUp.dispose();
    _controllerGrowSize.dispose();
    super.dispose();
  }
}
