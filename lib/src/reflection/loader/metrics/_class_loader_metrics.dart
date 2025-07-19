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
import '_class_load_stats.dart';
import 'class_load_stats.dart';
import 'class_loader_metrics.dart';

/// Performance metrics and monitoring for class loaders
class ClassLoaderMetricsImpl implements ClassLoaderMetrics {
  final Map<String, ClassLoadStats> _classStats = {};
  final List<ClassLoadEvent> _recentEvents = [];
  bool _detailedTracking = false;
  
  int _totalLoads = 0;
  int _totalErrors = 0;
  int _totalReloads = 0;
  int _cacheHits = 0;
  int _cacheMisses = 0;
  
  @override
  void enableDetailedTracking() {
    _detailedTracking = true;
  }
  
  @override
  void disableDetailedTracking() {
    _detailedTracking = false;
    _recentEvents.clear();
  }
  
  @override
  void recordClassLoad(String className, int microseconds) {
    _totalLoads++;
    
    final stats = _classStats.putIfAbsent(className, () => ClassLoadStatsImpl(className));
    stats.recordLoad(microseconds);
    
    if (_detailedTracking) {
      _recentEvents.add(ClassLoadEvent(
        className: className,
        timestamp: DateTime.now(),
        duration: Duration(microseconds: microseconds),
        success: true,
      ));
      
      // Keep only recent events
      if (_recentEvents.length > 1000) {
        _recentEvents.removeRange(0, 500);
      }
    }
  }
  
  @override
  void recordClassLoadError(String className, Object error) {
    _totalErrors++;
    
    final stats = _classStats.putIfAbsent(className, () => ClassLoadStatsImpl(className));
    stats.recordError(error);
    
    if (_detailedTracking) {
      _recentEvents.add(ClassLoadEvent(
        className: className,
        timestamp: DateTime.now(),
        success: false,
        error: error,
      ));
    }
  }
  
  @override
  void recordClassReload(String className) {
    _totalReloads++;
    
    final stats = _classStats.putIfAbsent(className, () => ClassLoadStatsImpl(className));
    stats.recordReload();
  }
  
  @override
  void recordCacheHit() {
    _cacheHits++;
  }
  
  @override
  void recordCacheMiss() {
    _cacheMisses++;
  }
  
  @override
  int get totalLoads => _totalLoads;
  
  @override
  int get totalErrors => _totalErrors;
  
  @override
  int get totalReloads => _totalReloads;
  
  @override
  double get cacheHitRatio {
    final total = _cacheHits + _cacheMisses;
    return total > 0 ? _cacheHits / total : 0.0;
  }
  
  @override
  double get averageLoadTime {
    if (_classStats.isEmpty) return 0.0;
    
    final totalTime = _classStats.values
        .map((stats) => stats.totalLoadTime)
        .fold(0, (a, b) => a + b);
    
    return totalTime / _totalLoads;
  }
  
  @override
  List<ClassLoadStats> getSlowestClasses([int limit = 10]) {
    final sorted = _classStats.values.toList()
      ..sort((a, b) => b.averageLoadTime.compareTo(a.averageLoadTime));
    
    return sorted.take(limit).toList();
  }
  
  @override
  List<ClassLoadStats> getMostLoadedClasses([int limit = 10]) {
    final sorted = _classStats.values.toList()
      ..sort((a, b) => b.loadCount.compareTo(a.loadCount));
    
    return sorted.take(limit).toList();
  }
  
  @override
  List<ClassLoadStats> getClassesWithErrors() {
    return _classStats.values.where((stats) => stats.errorCount > 0).toList();
  }
  
  @override
  List<ClassLoadEvent> getRecentEvents([int limit = 100]) {
    return _recentEvents.reversed.take(limit).toList();
  }
  
  @override
  Map<String, dynamic> getSummary() {
    return {
      'totalLoads': _totalLoads,
      'totalErrors': _totalErrors,
      'totalReloads': _totalReloads,
      'cacheHitRatio': cacheHitRatio,
      'averageLoadTime': averageLoadTime,
      'uniqueClasses': _classStats.length,
      'detailedTracking': _detailedTracking,
    };
  }
  
  @override
  void reset() {
    _classStats.clear();
    _recentEvents.clear();
    _totalLoads = 0;
    _totalErrors = 0;
    _totalReloads = 0;
    _cacheHits = 0;
    _cacheMisses = 0;
  }
  
  @override
  void printReport() {
    final summary = getSummary();
    
    print('📊 ClassLoader Performance Report');
    print('================================');
    print('Total Loads: ${summary['totalLoads']}');
    print('Total Errors: ${summary['totalErrors']}');
    print('Total Reloads: ${summary['totalReloads']}');
    print('Cache Hit Ratio: ${(summary['cacheHitRatio'] * 100).toStringAsFixed(1)}%');
    print('Average Load Time: ${(summary['averageLoadTime'] / 1000).toStringAsFixed(2)}ms');
    print('Unique Classes: ${summary['uniqueClasses']}');
    print('');
    
    final slowest = getSlowestClasses(5);
    if (slowest.isNotEmpty) {
      print('🐌 Slowest Loading Classes:');
      for (final stats in slowest) {
        print('  ${stats.className}: ${(stats.averageLoadTime / 1000).toStringAsFixed(2)}ms');
      }
      print('');
    }
    
    final mostLoaded = getMostLoadedClasses(5);
    if (mostLoaded.isNotEmpty) {
      print('🔥 Most Frequently Loaded:');
      for (final stats in mostLoaded) {
        print('  ${stats.className}: ${stats.loadCount} times');
      }
      print('');
    }
    
    final withErrors = getClassesWithErrors();
    if (withErrors.isNotEmpty) {
      print('❌ Classes with Errors:');
      for (final stats in withErrors) {
        print('  ${stats.className}: ${stats.errorCount} errors');
      }
    }
  }
}