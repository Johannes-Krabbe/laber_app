import 'dart:async';

class IntervalExecutor {
  Timer? _timer;
  final Duration interval;
  final Function() callback;

  IntervalExecutor({
    required this.interval,
    required this.callback,
  });

  void start() {
    _timer = Timer.periodic(interval, (_) => callback());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  bool get isRunning => _timer != null && _timer!.isActive;
}
