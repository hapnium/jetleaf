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

import 'dart:io';

import '../core/metric_contributor.dart';

/// {@template system_metrics_contributor}
/// A [MetricContributor] that collects system-level metrics related to the
/// current Dart process and environment.
///
/// This contributor provides useful data for monitoring runtime behavior such as:
/// - Memory usage (RSS)
/// - Application uptime
/// - Current timestamp
/// - Process details (PID, platform, Dart version, etc.)
///
/// Example:
/// ```dart
/// final contributor = SystemMetricsContributor();
/// final metrics = contributor.collectMetrics();
///
/// print(metrics['system.memory.rss.bytes']);         // e.g., 10485760
/// print(metrics['system.uptime.milliseconds']);      // e.g., 5234
/// print(metrics['system.process.pid']);              // e.g., 4231
/// print(metrics['system.process.platform']);         // 'macos' | 'linux' | 'windows'
/// ```
/// {@endtemplate}
class SystemMetricsContributor implements MetricContributor {
  /// {@macro system_metrics_contributor}
  SystemMetricsContributor();

  final DateTime _appStartTime = DateTime.now();

  /// {@template collect_metrics}
  /// Collects and returns system metrics as an unmodifiable map.
  ///
  /// The returned map contains:
  /// - `system.memory.rss.bytes`: Current resident set size in bytes.
  /// - `system.memory.maxRss.bytes`: Max resident set size ever used.
  /// - `system.uptime.milliseconds`: Time since this instance was created.
  /// - `system.timestamp`: Current system timestamp in ISO-8601 format.
  /// - `system.process.pid`: Process ID of the current Dart VM.
  /// - `system.process.platform`: Operating system name (e.g., 'linux').
  /// - `system.process.version`: Dart runtime version string.
  /// - `system.process.numberOfProcessors`: Number of available CPU cores.
  ///
  /// Example:
  /// ```dart
  /// final metrics = contributor.collectMetrics();
  /// print(metrics['system.timestamp']);
  /// ```
  /// {@endtemplate}
  @override
  Map<String, Object> collectMetrics() {
    final currentRss = ProcessInfo.currentRss; // Resident Set Size in bytes
    final maxRss = ProcessInfo.maxRss; // Max RSS ever reached
    final uptime = DateTime.now().difference(_appStartTime);

    return Map.unmodifiable({
      'system.memory.rss.bytes': currentRss,
      'system.memory.maxRss.bytes': maxRss,
      'system.uptime.milliseconds': uptime.inMilliseconds,
      'system.timestamp': DateTime.now().toIso8601String(),
      'system.process.pid': pid,
      'system.process.platform': Platform.operatingSystem,
      'system.process.version': Platform.version,
      'system.process.numberOfProcessors': Platform.numberOfProcessors,
    });
  }
}