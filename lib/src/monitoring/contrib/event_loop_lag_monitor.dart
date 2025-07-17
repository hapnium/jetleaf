import 'dart:async';
import 'dart:collection';

import '../core/metric_contributor.dart';
import '../timers/stopwatch_metric.dart';

/// {@template event_loop_lag_monitor}
/// A [MetricContributor] that monitors event loop lag by measuring the
/// difference between expected and actual delays using a [Stopwatch].
///
/// This is useful for identifying performance bottlenecks caused by
/// long-running synchronous operations that block the event loop.
///
/// The monitor samples every [checkInterval] and stores lag data
/// to calculate maximum and average lag over a rolling window.
///
/// Example:
/// ```dart
/// final monitor = EventLoopLagMonitor();
/// // Register with the metrics system
/// metricsRegistry.register(monitor);
/// ```
///
/// You can stop monitoring manually by calling [stopMonitoring].
/// {@endtemplate}
class EventLoopLagMonitor implements MetricContributor {
  /// {@macro event_loop_lag_monitor}
  EventLoopLagMonitor({Duration checkInterval = const Duration(seconds: 1)})
      : _checkInterval = checkInterval {
    _startMonitoring();
  }

  final Duration _checkInterval;
  final StopwatchMetric _stopwatch = StopwatchMetric();
  final Queue<int> _lagSamples = Queue();
  static const int _maxSamples = 60; // Rolling window of samples

  Timer? _timer;
  int _maxLag = 0;
  double _averageLag = 0.0;

  void _startMonitoring() {
    _stopwatch.start();
    _timer = Timer.periodic(_checkInterval, (timer) {
      _stopwatch.stop();
      final expectedElapsed = _checkInterval.inMicroseconds;
      final actualElapsed = _stopwatch.elapsedMicroseconds;
      final lag = actualElapsed - expectedElapsed;

      if (lag > 0) {
        _lagSamples.add(lag);
        if (_lagSamples.length > _maxSamples) {
          _lagSamples.removeFirst();
        }
        _maxLag = _lagSamples.fold(0, (prev, element) => element > prev ? element : prev);
        _averageLag = _lagSamples.reduce((a, b) => a + b) / _lagSamples.length;
      }

      _stopwatch.reset();
      _stopwatch.start();
    });
  }

  /// {@template stop_monitoring}
  /// Stops the periodic sampling of event loop lag and cancels the timer.
  ///
  /// Call this if the monitor is no longer needed, to free resources:
  ///
  /// ```dart
  /// monitor.stopMonitoring();
  /// ```
  /// {@endtemplate}
  void stopMonitoring() {
    _timer?.cancel();
    _stopwatch.stop();
  }

  @override
  Map<String, Object> collectMetrics() {
    return Map.unmodifiable({
      'eventLoop.lag.max.microseconds': _maxLag,
      'eventLoop.lag.avg.microseconds': _averageLag.round(),
      'eventLoop.lag.samples.count': _lagSamples.length,
    });
  }
}