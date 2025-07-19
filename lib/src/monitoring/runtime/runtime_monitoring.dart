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

import 'dart:async';

import '../models/lifecycle_report.dart';
import '../models/memory_analytics.dart';
import '../models/memory_reading.dart';

/// {@template runtime_lifecycle_service}
/// A service interface responsible for application lifecycle tracking and memory monitoring.
///
/// This service provides comprehensive system observability, including:
/// - Real-time memory usage tracking
/// - Application uptime monitoring
/// - Performance analytics
/// - Lifecycle event logging
/// - Data export capabilities
///
/// {@endtemplate}
abstract class RuntimeMonitoringService {
  /// {@macro runtime_lifecycle_service}
  RuntimeMonitoringService();

  /// {@template memory_stream}
  /// A broadcast stream of [MemoryReading] entries representing
  /// real-time memory usage samples collected by the system.
  ///
  /// Example:
  /// ```dart
  /// lifecycleService.memoryStream.listen((reading) {
  ///   print('Memory in use: ${reading.memoryMB} MB');
  /// });
  /// ```
  /// {@endtemplate}
  Stream<MemoryReading> get memoryStream;

  /// {@template current_memory_usage}
  /// Returns the latest known memory usage of the application in megabytes (MB).
  /// {@endtemplate}
  double get currentMemoryUsage;

  /// {@template app_start_time}
  /// The exact [DateTime] when the application lifecycle monitoring began.
  ///
  /// Returns `null` if monitoring has not been initialized.
  /// {@endtemplate}
  DateTime? get appStartTime;

  /// {@template uptime}
  /// The total time the application has been running since initialization.
  ///
  /// Calculated as: `DateTime.now() - appStartTime`.
  /// {@endtemplate}
  Duration get uptime;

  /// {@template memory_analytics}
  /// Provides aggregated memory usage statistics (e.g., average, peak, min)
  /// over predefined time windows.
  /// {@endtemplate}
  MemoryAnalytics get memoryAnalytics;

  /// {@template memory_history}
  /// A full list of memory readings collected since the monitoring started.
  ///
  /// This can be used for historical analysis or charting.
  /// {@endtemplate}
  List<MemoryReading> get memoryHistory;

  /// {@template error_log}
  /// A chronological log of errors captured during the lifecycle.
  ///
  /// Each log entry includes a timestamp and error message.
  /// {@endtemplate}
  List<String> get errorLog;

  /// {@template initialize_lifecycle}
  /// Initializes the lifecycle service, preparing it to begin tracking memory
  /// and system metrics.
  ///
  /// This must be called before accessing any data or starting monitoring.
  ///
  /// Example:
  /// ```dart
  /// final lifecycleService = MyLifecycleService();
  /// await lifecycleService.initialize();
  /// ```
  /// {@endtemplate}
  Future<void> initialize();

  /// {@template start_memory_monitoring}
  /// Starts continuous memory monitoring using the specified sampling [interval].
  ///
  /// Defaults to sampling every 5 seconds.
  ///
  /// Example:
  /// ```dart
  /// await lifecycleService.startMemoryMonitoring(interval: Duration(seconds: 10));
  /// ```
  /// {@endtemplate}
  Future<void> startMemoryMonitoring({Duration interval = const Duration(seconds: 5)});

  /// {@template stop_memory_monitoring}
  /// Stops the background memory monitoring process and stream.
  /// {@endtemplate}
  Future<void> stopMemoryMonitoring();

  /// {@template get_memory_analytics}
  /// Returns memory analytics data for a specific [duration] window.
  ///
  /// Example:
  /// ```dart
  /// final lastMinuteStats = lifecycleService.getMemoryAnalytics(Duration(minutes: 1));
  /// ```
  /// {@endtemplate}
  MemoryAnalytics getMemoryAnalytics(Duration duration);

  /// {@template export_lifecycle_data}
  /// Exports a full report of the lifecycle, including memory history,
  /// error logs, and system metadata.
  ///
  /// This is useful for diagnostics, support, or reporting.
  /// {@endtemplate}
  LifecycleReport exportLifecycleData();

  /// {@template log_error}
  /// Adds a new error log entry to the internal log store with a timestamp.
  ///
  /// Example:
  /// ```dart
  /// lifecycleService.logError('Database connection timeout');
  /// ```
  /// {@endtemplate}
  void logError(String error);

  /// {@template dispose_lifecycle_service}
  /// Cleans up all resources, stops monitoring, and clears internal state.
  ///
  /// Should be called when the service is no longer needed.
  /// {@endtemplate}
  Future<void> dispose();
}