import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../widgets/productivity_button.dart';
import '../models/timer.dart';
import '../models/countdown_timer.dart';
import 'settings_page.dart';

class TimerHomePage extends StatelessWidget {
  final double defaultPadding = 5;
  final CountDownTimer timer = CountDownTimer();

  @override
  Widget build(BuildContext context) {
    final List<PopupMenuItem<String>> menuItems = [];
    menuItems.add(
      PopupMenuItem(
        value: 'Settings',
        child: Text('Settings'),
      ),
    );
    timer.startWork();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Work Timer'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => menuItems.toList(),
            onSelected: (s) {
              if (s == 'Settings') goToSettings(context);
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double availableWidth = constraints.maxWidth;
          return Column(
            children: [
              _topOfSceneProductivityButtons(),
              _middleOfSceneTimer(context, availableWidth),
              _bottomOfSceneProductivityButtons(),
            ],
          );
        },
      ),
    );
  }

  void goToSettings(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ),
      );

  Row _topOfSceneProductivityButtons() => Row(
        children: [
          Padding(padding: EdgeInsets.all(defaultPadding)),
          Expanded(
            child: ProductivityButton(
              color: Color(0xFF009688),
              text: 'Work',
              onPressed: () => timer.startWork(),
            ),
          ),
          Padding(padding: EdgeInsets.all(defaultPadding)),
          Expanded(
            child: ProductivityButton(
              color: Color(0xFF607D8B),
              text: 'Short Break',
              onPressed: () => timer.startBreak(true),
            ),
          ),
          Padding(padding: EdgeInsets.all(defaultPadding)),
          Expanded(
            child: ProductivityButton(
              color: Color(0xFF455A64),
              text: 'Long Break',
              onPressed: () => timer.startBreak(false),
            ),
          ),
          Padding(padding: EdgeInsets.all(defaultPadding)),
        ],
      );

  Expanded _middleOfSceneTimer(BuildContext context, double width) {
    return Expanded(
      child: StreamBuilder(
        initialData: Timer('00:00', 1),
        stream: timer.stream(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Timer timer = snapshot.data;
          return Container(
            child: CircularPercentIndicator(
              radius: width / 2,
              lineWidth: 10.0,
              percent: (timer.percent == null) ? 1 : timer.percent,
              center: Text(
                (timer.time == null) ? '00:00' : timer.time,
                style: Theme.of(context).textTheme.headline4,
              ),
              progressColor: Color(0xff009688),
            ),
          );
        },
      ),
    );
  }

  Row _bottomOfSceneProductivityButtons() => Row(
        children: [
          Padding(padding: EdgeInsets.all(defaultPadding)),
          Expanded(
            child: ProductivityButton(
              color: Color(0xFF212121),
              text: 'Stop',
              onPressed: () => timer.stopTimer(),
            ),
          ),
          Padding(padding: EdgeInsets.all(defaultPadding)),
          Expanded(
            child: ProductivityButton(
              color: Color(0xFF009688),
              text: 'Restart',
              onPressed: () => timer.startTimer(),
            ),
          ),
          Padding(padding: EdgeInsets.all(defaultPadding)),
        ],
      );
}
