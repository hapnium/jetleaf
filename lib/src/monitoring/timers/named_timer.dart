/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

/// {@template named_timer}
/// An interface for managing and tracking execution times for named operations.
///
/// `NamedTimer` provides an abstraction for measuring the duration of multiple
/// labeled operations concurrently. It is useful when you need fine-grained performance
/// tracking for different parts of an application (e.g., `"startup"`, `"db.query"`, `"http.call"`).
///
/// ## Example:
/// ```dart
/// class SimpleNamedTimer implements NamedTimer {
///   final Map<String, Stopwatch> _timers = {};
///   final Map<String, Duration> _results = {};
///
///   @override
///   void start(String name) {
///     _timers[name] = Stopwatch()..start();
///   }
///
///   @override
///   void stop(String name) {
///     final timer = _timers[name];
///     if (timer != null && timer.isRunning) {
///       timer.stop();
///       _results[name] = timer.elapsed;
///     }
///   }
///
///   @override
///   Duration? duration(String name) => _results[name];
///
///   @override
///   Map<String, num> getDurations() {
///     return _results.map((key, value) => MapEntry(key, value.inMilliseconds));
///   }
/// }
///
/// final timer = SimpleNamedTimer();
/// timer.start('db.query');
/// await runDatabaseQuery();
/// timer.stop('db.query');
///
/// print(timer.duration('db.query')); // e.g., 75ms
/// ```
/// {@endtemplate}
abstract interface class NamedTimer {
  /// {@template start_timer}
  /// Starts a timer for the given [name].
  ///
  /// If a timer with the same name is already running, it will be reset and started again.
  ///
  /// ## Example:
  /// ```dart
  /// timer.start('app.init');
  /// ```
  /// {@endtemplate}
  void start(String name);

  /// {@template stop_timer}
  /// Stops the timer for the given [name].
  ///
  /// If the timer is not running, this method does nothing.
  ///
  /// ## Example:
  /// ```dart
  /// timer.stop('app.init');
  /// ```
  /// {@endtemplate}
  void stop(String name);

  /// {@template get_duration}
  /// Returns the elapsed duration for the given [name].
  ///
  /// If the timer was never started or not stopped, returns `null`.
  ///
  /// ## Example:
  /// ```dart
  /// final duration = timer.duration('db.query');
  /// if (duration != null) {
  ///   print('Query took ${duration.inMilliseconds}ms');
  /// }
  /// ```
  /// {@endtemplate}
  Duration? duration(String name);

  /// {@template get_durations}
  /// Returns a map of all recorded timer durations.
  ///
  /// The map keys are the timer names, and the values are the durations in milliseconds.
  ///
  /// ## Example:
  /// ```dart
  /// final metrics = timer.getDurations();
  /// print(metrics['app.init']); // 123
  /// print(metrics['http.call']); // 78
  /// ```
  /// {@endtemplate}
  Map<String, num> getDurations();
}