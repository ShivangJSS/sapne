import 'dart:async';

class SimpleTimer {
  Timer? _timer;
  int _seconds = 0;

  // Start
  void start() {
    _seconds = 0; // agar hamesha fresh start chahiye
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
    });
  }

  // Stop
  void stop() {
    _timer?.cancel();
  }

  // Get time as MM:SS string
  String get formattedTime {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (_seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  // Get raw seconds
  int get totalSeconds => _seconds;
}
