import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/bat.dart';
import '../widgets/ball.dart';

class Pong extends StatefulWidget {
  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  double height;
  double width;
  double posX = 0;
  double posY = 0;
  double batHeight = 0;
  double batWidth = 0;
  double batPosition = 0;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;

  @override
  void initState() {
    posX = 0;
    posY = 0;
    // defines how long the animation should run
    controller = AnimationController(
      duration: Duration(minutes: 10000),
      vsync: this,
    );
    // to set a linear value increment
    animation = Tween<double>(begin: 0, end: 100).animate(controller);
    animation.addListener(() {
      safeSetState(() {
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    // to start the animation
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double height = constraints.maxHeight;
        double width = constraints.maxWidth;
        batHeight = height / 20;
        batWidth = width / 5;

        return Stack(
          children: [
            Positioned(
              top: 0,
              right: 24,
              child: Text('Score: $score'),
            ),
            Positioned(
              top: posY,
              left: posX,
              child: Ball(),
            ),
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(
                  height: batHeight,
                  width: batWidth,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double randomNumbers() {
    // this is a number between 0.5 and 1.5
    var ran = Random();
    int myNum = ran.nextInt(10);
    return (50 + myNum) / 100;
  }

  void checkBorders() {
    double diameter = 50;

    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumbers();
    }

    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumbers();
    }

    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randY = randomNumbers();
    }

    if (posY >= height - diameter && vDir == Direction.down) {
      // check if the bat is here, otherwise lose
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumbers();
        safeSetState(() => score++);
      } else {
        controller.stop();
        dispose();
      }
    }
  }

  void moveBat(DragUpdateDetails update) =>
      safeSetState(() => batPosition += update.delta.dx);

  void safeSetState(Function function) {
    if (mounted && controller.isAnimating) setState(() => function());
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Game Over'),
        content: Text('Would you like to play again?'),
        actions: [
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              setState(() {
                posX = 0;
                posY = 0;
                score = 0;
              });
              Navigator.of(context).pop();
              controller.repeat();
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
              dispose();
            },
          ),
        ],
      ),
    );
  }
}

enum Direction { up, down, left, right }
