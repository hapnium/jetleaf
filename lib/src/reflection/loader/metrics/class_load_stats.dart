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

/// {@template class_load_stats}
/// An interface for tracking detailed statistics about class loading activities
/// in a Dart-based class loader system.
///
/// Implementations of this class can be used by class loaders or monitoring tools
/// to gather insights into class loading performance, frequency, failures, and
/// reloads. Useful for metrics, diagnostics, and debugging purposes.
///
/// Example:
/// ```dart
/// final stats = MyClassLoadStats('package:example/example.dart');
/// stats.recordLoad(320);
/// stats.recordReload();
/// stats.recordError(Exception('Failed to load'));
///
/// print(stats.averageLoadTime); // Output: average load duration
/// print(stats.errors); // Output: list of captured load errors
/// ```
/// {@endtemplate}
abstract class ClassLoadStats {
  /// {@macro class_load_stats}
  const ClassLoadStats();

  /// {@template class_load_stats.class_name}
  /// The fully qualified name of the class this statistics object is tracking.
  ///
  /// This allows associating the statistics to a particular class within the system.
  /// {@endtemplate}
  String get className;

  /// {@template class_load_stats.record_load}
  /// Records a successful class load operation.
  ///
  /// [microseconds] is the time taken to load the class, measured in microseconds.
  ///
  /// Example:
  /// ```dart
  /// stats.recordLoad(250); // 250 microseconds taken
  /// ```
  /// {@endtemplate}
  void recordLoad(int microseconds);

  /// {@template class_load_stats.record_error}
  /// Records an error that occurred while attempting to load the class.
  ///
  /// [error] is the exception or error thrown during the load.
  ///
  /// Example:
  /// ```dart
  /// stats.recordError(Exception('Timeout while loading'));
  /// ```
  /// {@endtemplate}
  void recordError(Object error);

  /// {@template class_load_stats.record_reload}
  /// Records that the class has been reloaded.
  ///
  /// Useful for hot-reload or dynamic class refresh tracking.
  ///
  /// Example:
  /// ```dart
  /// stats.recordReload();
  /// ```
  /// {@endtemplate}
  void recordReload();

  /// {@template class_load_stats.load_count}
  /// Total number of successful class load operations recorded.
  ///
  /// Example:
  /// ```dart
  /// print(stats.loadCount); // e.g., 12
  /// ```
  /// {@endtemplate}
  int get loadCount;

  /// {@template class_load_stats.error_count}
  /// Total number of failed class load attempts.
  ///
  /// Example:
  /// ```dart
  /// print(stats.errorCount); // e.g., 2
  /// ```
  /// {@endtemplate}
  int get errorCount;

  /// {@template class_load_stats.reload_count}
  /// Number of times the class has been reloaded.
  ///
  /// Example:
  /// ```dart
  /// print(stats.reloadCount); // e.g., 3
  /// ```
  /// {@endtemplate}
  int get reloadCount;

  /// {@template class_load_stats.total_load_time}
  /// The total cumulative time spent loading the class in microseconds.
  ///
  /// Example:
  /// ```dart
  /// print(stats.totalLoadTime); // e.g., 10200 (µs)
  /// ```
  /// {@endtemplate}
  int get totalLoadTime;

  /// {@template class_load_stats.average_load_time}
  /// Returns the average class load time in microseconds.
  ///
  /// Returns `0.0` if no successful loads have been recorded.
  ///
  /// Example:
  /// ```dart
  /// print(stats.averageLoadTime); // e.g., 340.5
  /// ```
  /// {@endtemplate}
  double get averageLoadTime;

  /// {@template class_load_stats.errors}
  /// A list of errors that were encountered during class load operations.
  ///
  /// This list can be useful for debugging and reporting purposes.
  ///
  /// Example:
  /// ```dart
  /// stats.errors.forEach(print); // print each recorded error
  /// ```
  /// {@endtemplate}
  List<Object> get errors;
}