import 'package:flutter/material.dart';
import '../widgets/animation_container.dart';
import '../widgets/animated_cross_fade.dart';
import '../widgets/animated_opacity.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animations'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            AnimatedContainerWidget(),
            Divider(),
            AnimatedCrossFadeWidget(),
            Divider(),
            AnimatedOpacityWidget(),
          ],
        ),
      ),
    );
  }
}
