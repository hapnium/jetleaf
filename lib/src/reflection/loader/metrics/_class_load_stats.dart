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

import 'class_load_stats.dart';

/// {@template class_load_stats}
/// Tracks statistics related to loading a single class within the class loader.
///
/// This includes total load count, error count, reloads, cumulative load time,
/// and the ability to compute average load time. Also records a list of all
/// thrown errors during class loading for later diagnostics.
///
/// ### Example:
/// ```dart
/// final stats = ClassLoadStats('package:example/example.dart');
/// stats.recordLoad(120);
/// stats.recordError(Exception('Failed to load'));
/// print(stats.averageLoadTime); // e.g. 120.0
/// ```
/// {@endtemplate}
class ClassLoadStatsImpl implements ClassLoadStats {
  /// The fully qualified name of the class this statistics object is tracking.
  final String className;

  int _loadCount = 0;
  int _errorCount = 0;
  int _reloadCount = 0;
  int _totalLoadTime = 0;
  final List<Object> _errors = [];

  /// {@macro class_load_stats}
  ClassLoadStatsImpl(this.className);

  @override
  void recordLoad(int microseconds) {
    _loadCount++;
    _totalLoadTime += microseconds;
  }

  @override
  void recordError(Object error) {
    _errorCount++;
    _errors.add(error);
  }

  @override
  void recordReload() {
    _reloadCount++;
  }

  @override
  int get loadCount => _loadCount;

  @override
  int get errorCount => _errorCount;

  @override
  int get reloadCount => _reloadCount;

  @override
  int get totalLoadTime => _totalLoadTime;

  @override
  double get averageLoadTime => _loadCount > 0 ? _totalLoadTime / _loadCount : 0.0;

  @override
  List<Object> get errors => List.unmodifiable(_errors);
}