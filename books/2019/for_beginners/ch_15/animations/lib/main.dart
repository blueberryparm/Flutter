import 'package:flutter/material.dart';
import 'animation_animated_widget.dart';
import 'animation_builder.dart';
import 'composed_animations.dart';
import 'custom_tween_animations.dart';
import 'rotation_animations.dart';
import 'scale_animations.dart';
import 'translate_animations.dart';

void main() => runApp(AnimationsApp());

class AnimationsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Animations Demo",
      home: RotationAnimations(),
      // home: ScaleAnimations(),
      // home: TranslateAnimations(),
      // home: ComposedAnimations(),
      // home: AnimationBuilderAnimations(),
      // home: AnimatedWidgetAnimations(),
    );
  }
}
