/// {@template stopwatch_metric}
/// A simple wrapper around Dart's [Stopwatch] for measuring elapsed time.
///
/// This class provides a cleaner interface for timing operations and is
/// commonly used to benchmark execution time of code blocks or monitor
/// method performance.
///
/// ## Example:
/// ```dart
/// final timer = StopwatchMetric();
///
/// timer.start();
/// performExpensiveOperation();
/// timer.stop();
///
/// print('Elapsed: ${timer.elapsedMilliseconds} ms');
/// ```
///
/// Can be used together with [MetricsRegistry] to track execution time of
/// critical operations.
/// {@endtemplate}
class StopwatchMetric {
  /// {@macro stopwatch_metric}
  StopwatchMetric();

  final Stopwatch _stopwatch = Stopwatch();

  /// {@template start_stopwatch}
  /// Starts the stopwatch.
  ///
  /// If already running, this has no effect.
  ///
  /// ## Example:
  /// ```dart
  /// timer.start();
  /// ```
  /// {@endtemplate}
  void start() {
    _stopwatch.start();
  }

  /// {@template stop_stopwatch}
  /// Stops the stopwatch.
  ///
  /// The elapsed time remains recorded and can be retrieved using [elapsed].
  ///
  /// ## Example:
  /// ```dart
  /// timer.stop();
  /// print('Elapsed: ${timer.elapsed}');
  /// ```
  /// {@endtemplate}
  void stop() {
    _stopwatch.stop();
  }

  /// {@template reset_stopwatch}
  /// Resets the stopwatch's elapsed time to zero and stops it.
  ///
  /// ## Example:
  /// ```dart
  /// timer.reset();
  /// ```
  /// {@endtemplate}
  void reset() {
    _stopwatch.reset();
  }

  /// {@template restart_stopwatch}
  /// Resets and starts the stopwatch in one operation.
  ///
  /// Useful for timing multiple blocks consecutively.
  ///
  /// ## Example:
  /// ```dart
  /// timer.restart();
  /// ```
  /// {@endtemplate}
  void restart() {
    _stopwatch.reset();
    _stopwatch.start();
  }

  /// {@template elapsed_duration}
  /// Returns the total elapsed [Duration] measured by the stopwatch.
  ///
  /// ## Example:
  /// ```dart
  /// final duration = timer.elapsed;
  /// print('Duration: $duration');
  /// ```
  /// {@endtemplate}
  Duration get elapsed => _stopwatch.elapsed;

  /// {@template elapsed_milliseconds}
  /// Returns the total elapsed time in milliseconds.
  ///
  /// ## Example:
  /// ```dart
  /// print('${timer.elapsedMilliseconds} ms');
  /// ```
  /// {@endtemplate}
  int get elapsedMilliseconds => _stopwatch.elapsedMilliseconds;

  /// {@template elapsed_microseconds}
  /// Returns the total elapsed time in microseconds.
  ///
  /// ## Example:
  /// ```dart
  /// print('${timer.elapsedMicroseconds} µs');
  /// ```
  /// {@endtemplate}
  int get elapsedMicroseconds => _stopwatch.elapsedMicroseconds;

  /// {@template is_running}
  /// Returns `true` if the stopwatch is currently running.
  ///
  /// ## Example:
  /// ```dart
  /// if (timer.isRunning) {
  ///   print('Timer is active...');
  /// }
  /// ```
  /// {@endtemplate}
  bool get isRunning => _stopwatch.isRunning;
}