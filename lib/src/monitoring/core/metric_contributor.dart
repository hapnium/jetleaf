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

/// {@template metric_contributor}
/// An interface for any component that wants to contribute metrics to the
/// JetLeaf monitoring system.
///
/// Implementations of this interface are responsible for collecting specific
/// sets of metrics (e.g., system-level, application-level, or framework-specific)
/// and returning them as key-value pairs.
///
/// These metrics are used by the monitoring engine to provide insights into
/// application health, performance, and runtime behavior.
///
/// ## Example:
/// ```dart
/// class SystemMetrics implements MetricContributor {
///   @override
///   Map<String, Object> collectMetrics() {
///     return {
///       'system.cpu.usage': 0.85,
///       'system.memory.free': 2048,
///     };
///   }
/// }
/// ```
///
/// The returned keys should use dot notation for namespacing (e.g., `system.cpu.usage`).
/// {@endtemplate}
abstract interface class MetricContributor {
  /// {@template collect_metrics}
  /// Collects and returns a map of metrics.
  ///
  /// - The returned [Map]'s keys are metric names (e.g., `'cpu.usage'`,
  /// `'memory.free'`, `'security.auth.failedLogins'`).
  /// - The values represent the current state or data point of that metric.
  ///
  /// Metric names should follow a dot notation format to represent namespaces.
  ///
  /// ## Example:
  /// ```dart
  /// {
  ///   'app.user.count': 1500,
  ///   'app.request.latency.avg': 23.7,
  ///   'system.memory.used': 3576,
  /// }
  /// ```
  /// {@endtemplate}
  Map<String, Object> collectMetrics();
}