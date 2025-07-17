import 'metric_contributor.dart';

/// {@template metrics_registry}
/// A singleton registry for all metric providers (`MetricContributor`s).
///
/// This class manages the lifecycle of metrics collection by allowing dynamic
/// registration and deregistration of contributors. It also supports the tracking
/// of custom metrics directly within the registry.
///
/// Aggregated metrics from all sources can be collected using [collectAllMetrics].
///
/// ## Example:
/// ```dart
/// final registry = MetricsRegistry.instance;
///
/// registry.register(SystemMetrics());
/// registry.registerCustomMetric('app.sessions.active', 42);
///
/// final snapshot = registry.collectAllMetrics();
/// print(snapshot['system.memory.free']); // 2048
/// print(snapshot['app.sessions.active']); // 42
/// ```
///
/// This is a central piece of the JetLeaf monitoring infrastructure.
/// {@endtemplate}
class MetricsRegistry {
  /// {@macro metrics_registry}
  MetricsRegistry._internal();

  /// The singleton instance of [MetricsRegistry].
  static final MetricsRegistry _instance = MetricsRegistry._internal();

  /// Returns the singleton instance of [MetricsRegistry].
  ///
  /// ## Example:
  /// ```dart
  /// final registry = MetricsRegistry.instance;
  /// ```
  static MetricsRegistry get instance => _instance;

  final List<MetricContributor> _contributors = [];
  final Map<String, num> _customMetrics = {};

  /// {@template register_metric_contributor}
  /// Registers a [MetricContributor] with the registry.
  ///
  /// Once registered, the contributor will be queried during calls
  /// to [collectAllMetrics] to provide real-time data.
  ///
  /// ## Example:
  /// ```dart
  /// registry.register(SystemMetrics());
  /// ```
  /// {@endtemplate}
  void register(MetricContributor contributor) {
    _contributors.add(contributor);
  }

  /// {@template deregister_metric_contributor}
  /// Deregisters a [MetricContributor] from the registry.
  ///
  /// After deregistration, the contributor's metrics will no longer be
  /// collected during aggregation.
  ///
  /// ## Example:
  /// ```dart
  /// registry.deregister(SystemMetrics());
  /// ```
  /// {@endtemplate}
  void deregister(MetricContributor contributor) {
    _contributors.remove(contributor);
  }

  /// {@template register_custom_metric}
  /// Registers or updates a custom metric.
  ///
  /// Custom metrics are static values you want to expose in addition to
  /// those coming from dynamic contributors.
  ///
  /// ## Example:
  /// ```dart
  /// registry.registerCustomMetric('app.cache.size', 3500);
  /// ```
  /// {@endtemplate}
  void registerCustomMetric(String name, num value) {
    _customMetrics[name] = value;
  }

  /// {@template collect_all_metrics}
  /// Collects and aggregates metrics from all registered contributors
  /// as well as all custom metrics registered manually.
  ///
  /// Returns a [Map] where:
  /// - Keys are metric names (e.g. `'system.memory.used'`)
  /// - Values are numeric or object representations of metric values
  ///
  /// ## Example:
  /// ```dart
  /// final all = registry.collectAllMetrics();
  /// print(all['system.cpu.usage']);
  /// ```
  /// {@endtemplate}
  Map<String, Object> collectAllMetrics() {
    final Map<String, Object> allMetrics = {};
    for (final contributor in _contributors) {
      allMetrics.addAll(contributor.collectMetrics());
    }
    allMetrics.addAll(_customMetrics); // Add custom metrics
    return allMetrics;
  }
}