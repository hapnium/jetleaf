import 'dart:async';

import 'package:jetleaf/lang.dart';

import '../timers/_named_timer.dart';
import '../timers/named_timer.dart';
import '_performance_tracker.dart';
import 'metrics_registry.dart';
import 'monitoring_service.dart';
import 'performance_tracker.dart';

/// {@template default_monitoring_service}
/// Default implementation of [MonitoringService].
///
/// This class orchestrates metric collection by interacting with the
/// [MetricsRegistry] and provides convenience methods for common monitoring tasks.
/// {@endtemplate}
class DefaultMonitoringService implements MonitoringService {
  /// {@macro default_monitoring_service}
  DefaultMonitoringService._internal();

  /// The singleton instance of [DefaultMonitoringService].
  static final DefaultMonitoringService _instance = DefaultMonitoringService._internal();

  /// Returns the singleton instance of [DefaultMonitoringService].
  static DefaultMonitoringService get instance => _instance;

  final MetricsRegistry _registry = MetricsRegistry.instance;
  final NamedTimer _namedTimer = DefaultNamedTimer();
  final PerformanceTracker _performanceTracker = DefaultPerformanceTracker();
  final Map<String, num> _customMetrics = HashMap();
  Timer? _samplerTimer;

  @override
  Map<String, Object> getSystemMetrics() {
    // System metrics are collected by SystemMetricsContributor,
    // which is registered with the registry.
    // We can filter the full export or rely on the contributor directly if needed.
    // For simplicity, we'll just return all collected metrics for now.
    return _registry.collectAllMetrics(); // This will include system metrics
  }

  @override
  Map<String, Object> getApplicationMetrics() {
    // Application metrics are collected by ApplicationBootMetrics and other
    // application-specific contributors.
    return _registry.collectAllMetrics(); // This will include application metrics
  }

  @override
  Map<String, Object> getComponentMetrics() {
    // Component metrics are collected by various contributors and named timers.
    return _registry.collectAllMetrics(); // This will include component metrics
  }

  @override
  void logCustomMetric(String name, num value, {Map<String, String>? tags}) {
    // For simplicity, custom metrics are stored directly in the service
    // or can be delegated to a dedicated CustomMetricsContributor.
    // Using a simple map for now.
    _customMetrics[name] = value;
    // Optionally, if tags are complex, you might want a more structured storage
    // or a dedicated CustomMetric class.
  }

  @override
  FutureOr<T> trackExecution<T>(String name, FutureOr<T> Function() block) {
    return _performanceTracker.trackExecution(name, block);
  }

  @override
  Map<String, Object> exportMetrics() {
    final allMetrics = _registry.collectAllMetrics();
    allMetrics.addAll(_namedTimer.getDurations()); // Add named timer durations
    allMetrics.addAll(_performanceTracker.getMetrics()); // Add performance tracker metrics
    allMetrics.addAll(_customMetrics); // Add custom metrics
    return allMetrics;
  }

  @override
  void startPeriodicSampling(Duration interval,
      {void Function(Map<String, Object> metrics)? onSample}) {
    if (_samplerTimer != null && _samplerTimer!.isActive) {
      return; // Already sampling
    }
    _samplerTimer = Timer.periodic(interval, (timer) {
      final metrics = exportMetrics();
      onSample?.call(metrics);
      // print('Sampled Metrics: $metrics'); // For debugging
    });
  }

  @override
  void stopPeriodicSampling() {
    _samplerTimer?.cancel();
    _samplerTimer = null;
  }
}