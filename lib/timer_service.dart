import 'dart:async';

import 'package:signals/signals_flutter.dart';

final Signal<int> sTimer = Signal<int>(300);

class TimerService {
  static final TimerService _instance = TimerService._internal();
  Timer? _timer;
  final int _initialTime = 300;

  factory TimerService() {
    return _instance;
  }

  TimerService._internal();

  void startTimer(Function onTimerComplete) {
    // Cancel any existing timer.
    _timer?.cancel();

    // Reset the timer value.
    sTimer.value = _initialTime;

    // Start a new timer.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sTimer.value > 0) {
        sTimer.value -= 1;
      } else {
        timer.cancel();
        onTimerComplete();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }
}
