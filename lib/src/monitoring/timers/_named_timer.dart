import 'package:jetleaf/lang.dart';

import 'stopwatch_metric.dart';
import 'named_timer.dart';

/// {@template default_named_timer}
/// Default implementation of [NamedTimer] using [StopwatchMetric].
/// {@endtemplate}
class DefaultNamedTimer implements NamedTimer {
  /// {@macro default_named_timer}
  DefaultNamedTimer();

  final Map<String, StopwatchMetric> _timers = HashMap();
  final Map<String, Duration> _recordedDurations = HashMap();

  @override
  void start(String name) {
    _timers.putIfAbsent(name, () => StopwatchMetric()).start();
  }

  @override
  void stop(String name) {
    final timer = _timers[name];
    if (timer != null) {
      timer.stop();
      _recordedDurations[name] = timer.elapsed;
    }
  }

  @override
  Duration? duration(String name) {
    return _recordedDurations[name];
  }

  @override
  Map<String, num> getDurations() {
    final Map<String, num> durationsMs = {};
    _recordedDurations.forEach((name, duration) {
      durationsMs['timer.$name.milliseconds'] = duration.inMilliseconds;
    });
    return durationsMs;
  }
}