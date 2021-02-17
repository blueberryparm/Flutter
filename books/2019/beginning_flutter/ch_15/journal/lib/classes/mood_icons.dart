import 'package:flutter/material.dart';

class MoodIcons {
  String title;
  Color color;
  double rotation;
  IconData icon;

  MoodIcons({this.title, this.color, this.rotation, this.icon});

  List<MoodIcons> _moodIconsList = <MoodIcons>[
    MoodIcons(
      title: 'Very Satisfied',
      color: Colors.amber,
      rotation: 0.4,
      icon: Icons.sentiment_very_satisfied,
    ),
    MoodIcons(
      title: 'Satisfied',
      color: Colors.green,
      rotation: 0.2,
      icon: Icons.sentiment_satisfied,
    ),
    MoodIcons(
      title: 'Neutral',
      color: Colors.grey,
      rotation: 0.0,
      icon: Icons.sentiment_neutral,
    ),
    MoodIcons(
      title: 'Dissatisfied',
      color: Colors.cyan,
      rotation: -0.2,
      icon: Icons.sentiment_dissatisfied,
    ),
    MoodIcons(
      title: 'Very Dissatisfied',
      color: Colors.red,
      rotation: -0.4,
      icon: Icons.sentiment_very_dissatisfied,
    ),
  ];

  IconData getMoodIcon(String mood) =>
      _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)]
          .icon;

  Color getMoodColor(String mood) =>
      _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)]
          .color;

  double getMoodRotation(String mood) =>
      _moodIconsList[_moodIconsList.indexWhere((icon) => icon.title == mood)]
          .rotation;

  List<MoodIcons> getMoodIconsList() => _moodIconsList;
}
