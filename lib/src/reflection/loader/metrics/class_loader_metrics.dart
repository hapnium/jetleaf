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

import 'class_load_event.dart';
import 'class_load_stats.dart';

/// {@template class_loader_metrics}
/// Interface for collecting, tracking, and analyzing class loading metrics
/// within a custom class loader system.
///
/// This metrics interface is designed for use in performance-sensitive or
/// dynamic environments where class loading behavior must be monitored in
/// detail. It supports tracking individual class loads, load durations,
/// errors, cache hits/misses, reloads, and detailed per-class statistics.
///
/// Implementors may store these statistics in memory or forward them to
/// external systems for centralized monitoring.
///
/// Typical usage:
/// ```dart
/// final metrics = InMemoryClassLoaderMetrics();
/// metrics.recordClassLoad('package:example/example.dart', 120);
/// metrics.recordCacheHit();
/// print(metrics.getSummary());
/// ```
/// {@endtemplate}
abstract interface class ClassLoaderMetrics {
  /// {@macro class_loader_metrics}
  const ClassLoaderMetrics();

  /// Enables detailed tracking such as per-event durations and individual errors.
  ///
  /// This mode is helpful during diagnostics but may add memory and CPU overhead.
  void enableDetailedTracking();

  /// Disables detailed tracking to reduce memory and processing usage.
  ///
  /// Events and stats may be aggregated instead of recorded individually.
  void disableDetailedTracking();

  /// Records a successful class load event.
  ///
  /// [className] is the name of the loaded class.
  /// [microseconds] is the duration it took to load the class.
  void recordClassLoad(String className, int microseconds);

  /// Records an error that occurred during class loading.
  ///
  /// [className] is the name of the class that failed to load.
  /// [error] is the exception or error thrown during the attempt.
  void recordClassLoadError(String className, Object error);

  /// Records that a class was reloaded.
  ///
  /// Reloading typically means an existing class was replaced or re-initialized.
  void recordClassReload(String className);

  /// Records that a class load operation was served from the cache.
  void recordCacheHit();

  /// Records that a class load operation was not found in the cache.
  void recordCacheMiss();

  /// Total number of successfully loaded classes.
  int get totalLoads;

  /// Total number of class loading errors encountered.
  int get totalErrors;

  /// Total number of class reload operations.
  int get totalReloads;

  /// Ratio of cache hits to total cache accesses (between 0.0 and 1.0).
  double get cacheHitRatio;

  /// Average duration of successful class loads in microseconds.
  double get averageLoadTime;

  /// Returns a list of the slowest-loading classes by average load time.
  ///
  /// [limit] defines the number of results to return. Defaults to 10.
  List<ClassLoadStats> getSlowestClasses([int limit = 10]);

  /// Returns a list of the most frequently loaded classes.
  ///
  /// [limit] defines the number of results to return. Defaults to 10.
  List<ClassLoadStats> getMostLoadedClasses([int limit = 10]);

  /// Returns all classes that have experienced at least one loading error.
  List<ClassLoadStats> getClassesWithErrors();

  /// Returns a list of recent class load events, including successes and failures.
  ///
  /// [limit] defines the maximum number of events to return. Defaults to 100.
  List<ClassLoadEvent> getRecentEvents([int limit = 100]);

  /// Returns a summary of key metrics for diagnostics or external export.
  ///
  /// Keys may include: `totalLoads`, `totalErrors`, `averageLoadTime`, etc.
  Map<String, dynamic> getSummary();

  /// Clears all collected statistics and resets internal counters.
  void reset();

  /// Prints a formatted report of current metrics to standard output.
  ///
  /// Useful for on-demand inspection or scheduled logs.
  void printReport();
}