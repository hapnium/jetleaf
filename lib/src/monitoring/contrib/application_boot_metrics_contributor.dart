import 'dart:collection';

import '../core/metric_contributor.dart';

/// {@template application_boot_metrics_contributor}
/// A [MetricContributor] for tracking application boot-related metrics,
/// such as JetLeaf context refresh time and bean creation times.
///
/// These metrics are typically set once during application startup and can be
/// used to analyze startup performance and identify bottlenecks.
///
/// Example:
/// ```dart
/// final contributor = ApplicationBootMetricsContributor();
/// contributor.setContextRefreshTime(Duration(milliseconds: 1200));
/// contributor.addBeanCreationTime('myService', Duration(milliseconds: 80));
///
/// final metrics = contributor.collectMetrics();
/// print(metrics['application.boot.contextRefresh.milliseconds']); // 1200
/// ```
/// {@endtemplate}
class ApplicationBootMetricsContributor implements MetricContributor {
  /// {@macro application_boot_metrics_contributor}
  ApplicationBootMetricsContributor();

  final Map<String, Object> _metrics = HashMap();

  /// {@template set_context_refresh_time}
  /// Sets the time it took to refresh the JetLeaf application context.
  ///
  /// This metric reflects the total duration of context initialization and
  /// can help evaluate startup speed.
  ///
  /// Example key in metric map:
  /// - `application.boot.contextRefresh.milliseconds`
  ///
  /// Example:
  /// ```dart
  /// contributor.setContextRefreshTime(Duration(milliseconds: 1500));
  /// ```
  /// {@endtemplate}
  void setContextRefreshTime(Duration duration) {
    _metrics['application.boot.contextRefresh.milliseconds'] = duration.inMilliseconds;
  }

  /// {@template add_bean_creation_time}
  /// Adds a metric for the time it took to create a specific bean during startup.
  ///
  /// [beanName] is the name of the bean. The metric will be stored using the key:
  /// `application.boot.bean.{beanName}.creation.milliseconds`
  ///
  /// Example:
  /// ```dart
  /// contributor.addBeanCreationTime('userService', Duration(milliseconds: 95));
  /// ```
  /// {@endtemplate}
  void addBeanCreationTime(String beanName, Duration duration) {
    _metrics['application.boot.bean.$beanName.creation.milliseconds'] = duration.inMilliseconds;
  }

  /// {@macro collect_metrics}
  @override
  Map<String, Object> collectMetrics() {
    return Map.unmodifiable(_metrics);
  }
}