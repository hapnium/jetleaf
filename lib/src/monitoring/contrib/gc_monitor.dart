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

/// {@template gc_monitor}
/// A [MetricContributor] for approximating Garbage Collection (GC) metrics.
///
/// Dart's VM does not expose direct GC statistics like Java. This implementation
/// approximates GC activity by tracking memory deltas—specifically Resident Set Size (RSS).
///
/// If the RSS decreases between metric collections, it is heuristically assumed
/// that a GC has occurred and memory was freed.
///
/// For more accurate GC monitoring, integration with the Dart VM service protocol
/// (such as via Observatory or VM Service) would be required, which is out of scope
/// for pure Dart libraries.
///
/// Example usage:
/// ```dart
/// final gc = GCMonitor();
/// print(gc.collectMetrics());
/// gc.resetGcMetrics();
/// ```
/// {@endtemplate}
class GCMonitor implements MetricContributor {
  /// {@macro gc_monitor}
  GCMonitor();

  int _lastRss = 0;
  int _gcCount = 0;
  int _gcMemoryFreed = 0;

  /// {@template gc_collect_metrics}
  /// Collects the current GC-related metrics.
  ///
  /// Metrics returned:
  /// - `gc.count`: Number of suspected GC events based on RSS drops.
  /// - `gc.memoryFreed.bytes`: Total memory freed across all detected GC events.
  /// - `memory.rss.bytes`: Current resident set size.
  /// - `memory.heap.total.bytes`: Maximum recorded RSS since app start.
  ///
  /// Returns an immutable map of metrics.
  /// {@endtemplate}
  @override
  Map<String, Object> collectMetrics() {
    final currentRss = ProcessInfo.currentRss;

    if (_lastRss > 0 && currentRss < _lastRss) {
      _gcCount++;
      _gcMemoryFreed += (_lastRss - currentRss);
    }
    _lastRss = currentRss;

    return Map.unmodifiable({
      'gc.count': _gcCount,
      'gc.memoryFreed.bytes': _gcMemoryFreed,
      'memory.rss.bytes': currentRss,
      'memory.heap.total.bytes': ProcessInfo.maxRss,
    });
  }

  /// {@template reset_gc_metrics}
  /// Resets the accumulated GC metrics, clearing `gc.count` and `gc.memoryFreed`.
  ///
  /// This does **not** affect current memory readings or `_lastRss`.
  /// {@endtemplate}
  void resetGcMetrics() {
    _gcCount = 0;
    _gcMemoryFreed = 0;
  }
}