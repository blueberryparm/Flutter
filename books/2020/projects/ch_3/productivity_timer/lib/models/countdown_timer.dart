import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'timer.dart';

class CountDownTimer {
  double _radius = 1;
  // when the user presses the stop button it becomes inactive
  bool _isActive = true;
  // used to create countdown timers
  Timer timer;
  // remaining time
  Duration _time;
  // beginning time
  Duration _fullTime;
  int work = 30;
  int shortBreak = 5;
  int longBreak = 20;

  // the * after async is used to say that a Stream is being returned
  // you are creating a generator function
  // any number of events can be returned in a Stream
  // returns a Stream of Timer decrementing the Duration every second
  Stream<Timer> stream() async* {
    // yield* delivers a result. Creates a Stream that emits events at the intervals
    yield* Stream.periodic(Duration(seconds: 1), (int a) {
      String time;
      if (_isActive) {
        // we decrease the value of time by 1 second
        _time = _time - Duration(seconds: 1);
        // remaining time divided by the total time
        _radius = _time.inSeconds / _fullTime.inSeconds;
        // if it gets down to 0 to stop the countdown
        if (_time.inSeconds <= 0) _isActive = false;
      }
      // transform the remaining Duration into a String
      time = returnTime(_time);
      return Timer(time, _radius);
    });
  }

  String returnTime(Duration t) {
    String minutes = (t.inMinutes < 10)
        ? '0' + t.inMinutes.toString()
        : t.inMinutes.toString();

    int numSeconds = t.inSeconds - (t.inMinutes * 60);
    String seconds =
        (numSeconds < 10) ? '0' + numSeconds.toString() : numSeconds.toString();

    String formattedTime = minutes + ":" + seconds;
    return formattedTime;
  }

  // retrieves the settings saved in SharedPreferences instance or sets default values
  Future readSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    work = prefs.getInt('workTime') == null ? 30 : prefs.getInt('workTime');
    shortBreak =
        prefs.getInt('shortBreak') == null ? 30 : prefs.getInt('shortBreak');
    longBreak =
        prefs.getInt('longBreak') == null ? 30 : prefs.getInt('longBreak');
  }

  // set the _time duration to the number of minutes contained
  // in the work variable and the same for the _fullTime field
  void startWork() async {
    await readSettings();
    _radius = 1;
    _time = Duration(minutes: work, seconds: 0);
    _fullTime = _time;
  }

  void stopTimer() => _isActive = false;

  void startTimer() {
    if (_time.inSeconds > 0) _isActive = true;
  }

  void startBreak(bool isShort) {
    _radius = 1;
    _time = Duration(minutes: (isShort) ? shortBreak : longBreak);
    _fullTime = _time;
  }
}
