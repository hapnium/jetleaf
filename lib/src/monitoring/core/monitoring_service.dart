import 'dart:async';

import '_monitoring_service.dart';

/// {@template monitoring_service}
/// The main access point for the JetLeaf monitoring system.
///
/// This interface exposes a unified API to collect and manage metrics related to
/// system resources, application behavior, and component performance.
///
/// It also supports logging custom metrics, tracking code execution times, and exporting
/// all collected metrics. A singleton instance is available via [MonitoringService.instance].
///
/// ### Example Usage:
///
/// ```dart
/// final monitoring = MonitoringService.instance;
///
/// // Track code execution
/// await monitoring.trackExecution('database.query', () async {
///   await database.fetch();
/// });
///
/// // Log a custom metric
/// monitoring.logCustomMetric('custom.api.hits', 42, tags: {'env': 'prod'});
///
/// // Export all metrics
/// final metrics = monitoring.exportMetrics();
/// print(metrics);
/// ```
/// {@endtemplate}
abstract interface class MonitoringService {
  /// {@macro monitoring_service}
  factory MonitoringService() => DefaultMonitoringService.instance;

  /// The singleton instance of [MonitoringService].
  static MonitoringService get instance => DefaultMonitoringService.instance;

  /// {@template get_system_metrics}
  /// Retrieves a snapshot of system-level metrics.
  ///
  /// These may include memory usage, CPU stats, and disk information.
  ///
  /// ### Example:
  /// ```dart
  /// final systemMetrics = MonitoringService.instance.getSystemMetrics();
  /// print(systemMetrics['cpu.usage']); // 0.35 (35%)
  /// ```
  /// {@endtemplate}
  Map<String, Object> getSystemMetrics();

  /// {@template get_application_metrics}
  /// Retrieves a snapshot of application-level metrics.
  ///
  /// These typically include framework-level metrics such as
  /// HTTP request count, error rates, uptime, etc.
  ///
  /// ### Example:
  /// ```dart
  /// final appMetrics = MonitoringService.instance.getApplicationMetrics();
  /// print(appMetrics['http.requests.total']);
  /// ```
  /// {@endtemplate}
  Map<String, Object> getApplicationMetrics();

  /// {@template get_component_metrics}
  /// Retrieves a snapshot of component-level metrics.
  ///
  /// These are gathered from various contributors registered
  /// within the application, like DB health, cache hit/miss ratios, etc.
  ///
  /// ### Example:
  /// ```dart
  /// final compMetrics = MonitoringService.instance.getComponentMetrics();
  /// print(compMetrics['db.query.count']);
  /// ```
  /// {@endtemplate}
  Map<String, Object> getComponentMetrics();

  /// {@template log_custom_metric}
  /// Logs a custom metric with a given name, value, and optional tags.
  ///
  /// This is useful for adding domain-specific data into your monitoring stream.
  /// Tags allow filtering and grouping during analysis.
  ///
  /// ### Example:
  /// ```dart
  /// MonitoringService.instance.logCustomMetric(
  ///   'order.placed',
  ///   1,
  ///   tags: {'userType': 'premium'},
  /// );
  /// ```
  /// {@endtemplate}
  void logCustomMetric(String name, num value, {Map<String, String>? tags});

  /// {@template track_execution}
  /// Tracks the execution time of a given `block` of code.
  ///
  /// Automatically records how long the code took to execute and can associate
  /// it with the provided [name].
  ///
  /// Supports both `sync` and `async` functions.
  ///
  /// ### Example:
  /// ```dart
  /// await MonitoringService.instance.trackExecution('load.homepage', () async {
  ///   await pageLoader.load();
  /// });
  /// ```
  /// {@endtemplate}
  FutureOr<T> trackExecution<T>(String name, FutureOr<T> Function() block);

  /// {@template export_metrics}
  /// Exports all collected metrics.
  ///
  /// Metrics include system, application, component, and custom data.
  /// Returns a JSON-serializable map.
  ///
  /// ### Example:
  /// ```dart
  /// final data = MonitoringService.instance.exportMetrics();
  /// final jsonString = jsonEncode(data);
  /// ```
  /// {@endtemplate}
  Map<String, Object> exportMetrics();

  /// {@template start_periodic_sampling}
  /// Starts periodic sampling of metrics.
  ///
  /// This will continuously collect metrics at the specified [interval].
  /// The optional [onSample] callback will be called with the current metric set.
  ///
  /// ### Example:
  /// ```dart
  /// MonitoringService.instance.startPeriodicSampling(
  ///   Duration(seconds: 10),
  ///   onSample: (metrics) {
  ///     print('Sampled metrics: $metrics');
  ///   },
  /// );
  /// ```
  /// {@endtemplate}
  void startPeriodicSampling(Duration interval, {void Function(Map<String, Object> metrics)? onSample});

  /// {@template stop_periodic_sampling}
  /// Stops any active periodic metric sampling.
  ///
  /// After calling this, no further automatic collection will occur.
  ///
  /// ### Example:
  /// ```dart
  /// MonitoringService.instance.stopPeriodicSampling();
  /// ```
  /// {@endtemplate}
  void stopPeriodicSampling();
}