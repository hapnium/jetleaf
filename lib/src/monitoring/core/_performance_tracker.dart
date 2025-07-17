import 'dart:async';

import 'package:jetleaf/lang.dart';

import '../timers/_named_timer.dart';
import '../timers/named_timer.dart';
import 'performance_tracker.dart';

/// {@template default_performance_tracker}
/// Default implementation of [PerformanceTracker].
/// {@endtemplate}
class DefaultPerformanceTracker implements PerformanceTracker {
  /// {@macro default_performance_tracker}
  DefaultPerformanceTracker();

  final NamedTimer _namedTimer = DefaultNamedTimer();
  final Map<String, int> _errorCounts = HashMap();

  @override
  FutureOr<T> trackExecution<T>(String name, FutureOr<T> Function() block) {
    _namedTimer.start(name);
    try {
      final result = block();
      if (result is Future<T>) {
        return result.whenComplete(() {
          _namedTimer.stop(name);
        }).catchError((e) {
          _incrementErrorCount(name, e);
          throw e; // Re-throw the error after logging
        });
      } else {
        _namedTimer.stop(name);
        return result;
      }
    } catch (e) {
      _incrementErrorCount(name, e);
      rethrow; // Re-throw the error after logging
    }
  }

  void _incrementErrorCount(String name, Object error) {
    final errorType = error.runtimeType.toString();
    _errorCounts.update('error.$name.count', (value) => value + 1,
        ifAbsent: () => 1);
    _errorCounts.update('error.$name.type.$errorType.count',
        (value) => value + 1,
        ifAbsent: () => 1);
  }

  @override
  Map<String, Object> getMetrics() {
    final Map<String, Object> metrics = {};
    metrics.addAll(_namedTimer.getDurations());
    metrics.addAll(_errorCounts);
    return metrics;
  }
}