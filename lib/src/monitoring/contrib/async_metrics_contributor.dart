import 'dart:isolate';

import '../core/metric_contributor.dart';

/// {@template async_metrics_contributor}
/// A [MetricContributor] for tracking asynchronous execution metrics in Dart.
///
/// This contributor tracks:
/// - The number of active isolates (starting from the main isolate)
/// - Futures that have started
/// - Futures that have completed
///
/// > ⚠️ Note: Dart does not currently offer a native way to monitor all pending
/// futures or task queue size without deep VM integrations or `Zone`-based
/// patching. This class is a conceptual approximation, useful for general
/// observability in application performance dashboards.
///
/// Example:
/// ```dart
/// final metrics = AsyncMetricsContributor();
/// metrics.incrementFuturesStarted();
/// await someAsyncOp();
/// metrics.incrementFuturesCompleted();
/// print(metrics.collectMetrics());
/// ```
/// {@endtemplate}
class AsyncMetricsContributor implements MetricContributor {
  /// {@macro async_metrics_contributor}
  AsyncMetricsContributor();

  int _isolateCount = 1;
  int _futuresCompleted = 0;
  int _futuresStarted = 0;

  /// {@template increment_isolate_count}
  /// Increments the count of active isolates.
  ///
  /// Should be called manually if new isolates are spawned and tracked
  /// explicitly by the developer.
  ///
  /// Example:
  /// ```dart
  /// contributor.incrementIsolateCount();
  /// ```
  /// {@endtemplate}
  void incrementIsolateCount() => _isolateCount++;

  /// {@template decrement_isolate_count}
  /// Decrements the count of active isolates.
  ///
  /// Use when a tracked isolate terminates.
  ///
  /// Example:
  /// ```dart
  /// contributor.decrementIsolateCount();
  /// ```
  /// {@endtemplate}
  void decrementIsolateCount() => _isolateCount--;

  /// {@template increment_futures_started}
  /// Increments the count of started futures.
  ///
  /// Should be called when a new future is launched and being tracked.
  ///
  /// Example:
  /// ```dart
  /// contributor.incrementFuturesStarted();
  /// ```
  /// {@endtemplate}
  void incrementFuturesStarted() => _futuresStarted++;

  /// {@template increment_futures_completed}
  /// Increments the count of completed futures.
  ///
  /// Should be called when a tracked future finishes execution.
  ///
  /// Example:
  /// ```dart
  /// contributor.incrementFuturesCompleted();
  /// ```
  /// {@endtemplate}
  void incrementFuturesCompleted() => _futuresCompleted++;

  @override
  Map<String, Object> collectMetrics() {
    return Map.unmodifiable({
      'async.isolates.active': _isolateCount,
      'async.futures.started': _futuresStarted,
      'async.futures.completed': _futuresCompleted,
      'async.futures.pending': _futuresStarted - _futuresCompleted,
      'async.eventLoop.debugName': Isolate.current.debugName ?? 'unnamed',
    });
  }
}