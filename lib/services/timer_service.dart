import 'dart:async';
import 'dart:ui';

import 'package:signals/signals_flutter.dart';

// Create sTimer Signal.
final Signal<int> sTimer = Signal<int>(300);

class TimerService {
  factory TimerService() {
    return _instance;
  }

  TimerService._internal();

  static final TimerService _instance = TimerService._internal();

  Timer? _timer;
  final int _initialTime = 300;

  void startTimer(VoidCallback onTimerComplete) {
    // Cancel any existing timer.
    _timer?.cancel();

    // Reset the timer value.
    sTimer.value = _initialTime;

    // Start a new timer.
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
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
