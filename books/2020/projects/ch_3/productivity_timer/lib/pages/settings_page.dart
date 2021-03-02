import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/settings_button.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const String WORKTIME = 'workTime';
  static const String SHORTBREAK = 'shortBreak';
  static const String LONGBREAK = 'longBreak';
  SharedPreferences prefs;
  TextEditingController txtWork;
  TextEditingController txtShort;
  TextEditingController txtLong;

  @override
  void initState() {
    txtWork = TextEditingController();
    txtShort = TextEditingController();
    txtLong = TextEditingController();
    readSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(fontSize: 24);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: GridView.count(
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          crossAxisCount: 3,
          childAspectRatio: 3, // itemWidth/itemHeight
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            Text('Work'),
            Text(''),
            Text(''),
            SettingsButton(Color(0xFF455A64), '-', -1, WORKTIME, updateSetting),
            TextField(
              controller: txtWork,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            SettingsButton(Color(0xFF009688), '+', 1, WORKTIME, updateSetting),
            Text('Short'),
            Text(''),
            Text(''),
            SettingsButton(
                Color(0xFF455A64), '-', -1, SHORTBREAK, updateSetting),
            TextField(
              controller: txtShort,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            SettingsButton(
                Color(0xFF009688), '+', 1, SHORTBREAK, updateSetting),
            Text('Long'),
            Text(''),
            Text(''),
            SettingsButton(
                Color(0xFF455A64), '-', -1, LONGBREAK, updateSetting),
            TextField(
              controller: txtLong,
              style: textStyle,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
            SettingsButton(Color(0xFF009688), '+', 1, LONGBREAK, updateSetting),
          ],
        ),
      ),
    );
  }

  // reads the values of the settings from SharedPreferences
  // and then it writes the values in the text fields
  void readSettings() async {
    prefs = await SharedPreferences.getInstance();
    int workTime = prefs.getInt(WORKTIME);
    int shortBreak = prefs.getInt(SHORTBREAK);
    int longBreak = prefs.getInt(LONGBREAK);

    if (workTime == null) await prefs.setInt(WORKTIME, int.parse('30'));
    if (shortBreak == null) await prefs.setInt(SHORTBREAK, int.parse('5'));
    if (longBreak == null) await prefs.setInt(LONGBREAK, int.parse('20'));

    setState(() {
      txtWork.text = workTime.toString();
      txtShort.text = shortBreak.toString();
      txtLong.text = longBreak.toString();
    });
  }

  void updateSetting(String key, int value) {
    switch (key) {
      case WORKTIME:
        {
          int workTime = prefs.getInt(WORKTIME);
          workTime += value;
          if (workTime >= 1 && workTime <= 180) {
            prefs.setInt(WORKTIME, workTime);
            setState(() => txtWork.text = workTime.toString());
          }
        }
        break;
      case SHORTBREAK:
        {
          int short = prefs.getInt(SHORTBREAK);
          short += value;
          if (short >= 1 && short <= 120) {
            prefs.setInt(SHORTBREAK, short);
            setState(() => txtShort.text = short.toString());
          }
        }
        break;
      case LONGBREAK:
        {
          int long = prefs.getInt(LONGBREAK);
          long += value;
          if (long >= 1 && long <= 180) {
            prefs.setInt(LONGBREAK, long);
            setState(() => txtLong.text = long.toString());
          }
        }
        break;
    }
  }
}
