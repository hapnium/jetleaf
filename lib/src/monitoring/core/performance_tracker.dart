import 'dart:async';

/// {@template performance_tracker}
/// An optional high-level interface to wrap components and track durations and errors.
///
/// `PerformanceTracker` provides a structured mechanism for measuring the
/// execution time and failure rates of operations (e.g., service methods,
/// API calls, background jobs).
///
/// Use this when you want to profile performance without manually managing timers
/// or error counters.
///
/// ## Example:
/// ```dart
/// class SimpleTracker implements PerformanceTracker {
///   final Map<String, StopwatchMetric> _timers = {};
///   final Map<String, int> _errorCounts = {};
///
///   @override
///   FutureOr<T> trackExecution<T>(String name, FutureOr<T> Function() block) async {
///     final timer = StopwatchMetric()..start();
///     try {
///       final result = await block();
///       return result;
///     } catch (e) {
///       _errorCounts[name] = (_errorCounts[name] ?? 0) + 1;
///       rethrow;
///     } finally {
///       timer.stop();
///       _timers[name] = timer;
///     }
///   }
///
///   @override
///   Map<String, Object> getMetrics() {
///     return {
///       for (final entry in _timers.entries) '${entry.key}.duration': entry.value.elapsedMilliseconds,
///       for (final entry in _errorCounts.entries) '${entry.key}.errors': entry.value,
///     };
///   }
/// }
/// ```
/// {@endtemplate}
abstract interface class PerformanceTracker {
  /// {@template track_execution_with_errors}
  /// Tracks the execution of a [block] of code, recording its duration
  /// and any errors that occur.
  ///
  /// The [name] identifies the operation being tracked, and will be used as the
  /// namespace for the collected metrics.
  ///
  /// Implementations should:
  /// - Start a timer
  /// - Run the [block]
  /// - Record duration and catch any errors
  ///
  /// ## Example:
  /// ```dart
  /// await tracker.trackExecution('user.save', () => userService.save(user));
  /// ```
  /// {@endtemplate}
  FutureOr<T> trackExecution<T>(String name, FutureOr<T> Function() block);

  /// {@template get_performance_metrics}
  /// Returns a map of collected performance metrics.
  ///
  /// The keys should be dot-notated metric names such as:
  /// - `'user.save.duration'`: Execution time in milliseconds
  /// - `'user.save.errors'`: Error count for that operation
  ///
  /// ## Example:
  /// ```dart
  /// final metrics = tracker.getMetrics();
  /// print(metrics['job.sync.duration']); // 153
  /// print(metrics['job.sync.errors']);   // 2
  /// ```
  /// {@endtemplate}
  Map<String, Object> getMetrics();
}