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

// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';

import '../models/lifecycle_report.dart';
import '../models/memory_analytics.dart';
import '../models/memory_reading.dart';
import 'runtime_monitoring.dart';

/// Implementation of RuntimeMonitoringService for system monitoring and lifecycle tracking.
class _RuntimeMonitoring implements RuntimeMonitoringService {
  // Stream controller for memory readings
  final StreamController<MemoryReading> _memoryController = StreamController<MemoryReading>.broadcast();
  
  // Lifecycle tracking
  DateTime? _appStartTime;
  
  // Data collection
  final List<MemoryReading> _memoryReadings = [];
  final List<String> _errorLog = [];
  
  // Monitoring
  Timer? _memoryTimer;
  Duration _memoryInterval = const Duration(seconds: 5);
  
  @override
  Stream<MemoryReading> get memoryStream => _memoryController.stream;
  
  @override
  double get currentMemoryUsage => ProcessInfo.currentRss / (1024 * 1024);
  
  @override
  DateTime? get appStartTime => _appStartTime;
  
  @override
  Duration get uptime => _appStartTime != null ? DateTime.now().difference(_appStartTime!) : Duration.zero;
  
  @override
  MemoryAnalytics get memoryAnalytics => getMemoryAnalytics(const Duration(hours: 1));
  
  @override
  List<MemoryReading> get memoryHistory => List.unmodifiable(_memoryReadings);
  
  @override
  List<String> get errorLog => List.unmodifiable(_errorLog);
  
  @override
  Future<void> initialize() async {
    try {
      _appStartTime = DateTime.now();
      // console.debug("LifecycleService: Starting initialization...");
      
      await startMemoryMonitoring();
      
      // console.debug("LifecycleService: Initialization completed successfully");
    } catch (e, stackTrace) {
      logError("Initialization failed: $e. $stackTrace");
      rethrow;
    }
  }
  
  @override
  Future<void> startMemoryMonitoring({Duration interval = const Duration(seconds: 5)}) async {
    _memoryInterval = interval;
    await _initializeMemoryMonitoring();
  }
  
  Future<void> _initializeMemoryMonitoring() async {
    _memoryTimer?.cancel();
    
    _memoryTimer = Timer.periodic(_memoryInterval, (timer) {
      final now = DateTime.now();
      final memoryUsageMB = currentMemoryUsage;
      final currentUptime = uptime;
      
      // Create and store memory reading
      final reading = MemoryReading(
        timestamp: now,
        memoryMB: memoryUsageMB,
        uptime: currentUptime,
      );
      
      _memoryReadings.add(reading);
      _memoryController.add(reading);
      
      // Log current memory usage
      final timeStamp = _formatDateTime(now);
      // console.debug("Current Memory Usage: ${memoryUsageMB.toStringAsFixed(2)}MB [$timeStamp]");
      
      // Analyze and log memory patterns
      _analyzeAndLogMemoryPatterns(memoryUsageMB, now);
      
      // Clean up old readings (keep last 24 hours)
      _cleanupOldReadings();
    });
    
    // console.debug("Memory monitoring started with ${_memoryInterval.inSeconds}s interval");
  }
  
  @override
  Future<void> stopMemoryMonitoring() async {
    _memoryTimer?.cancel();
    _memoryTimer = null;
    // console.debug("Memory monitoring stopped");
  }
  
  @override
  MemoryAnalytics getMemoryAnalytics(Duration duration) {
    final now = DateTime.now();
    final cutoff = now.subtract(duration);
    final relevantReadings = _memoryReadings
        .where((reading) => reading.timestamp.isAfter(cutoff))
        .toList();
    
    if (relevantReadings.isEmpty) {
      return MemoryAnalytics(
        timeWindow: duration,
        minMemoryMB: currentMemoryUsage,
        maxMemoryMB: currentMemoryUsage,
        avgMemoryMB: currentMemoryUsage,
        currentMemoryMB: currentMemoryUsage,
        readings: [],
      );
    }
    
    final memoryValues = relevantReadings.map((r) => r.memoryMB).toList();
    final minMemory = memoryValues.reduce((a, b) => a < b ? a : b);
    final maxMemory = memoryValues.reduce((a, b) => a > b ? a : b);
    final avgMemory = memoryValues.reduce((a, b) => a + b) / memoryValues.length;
    
    return MemoryAnalytics(
      timeWindow: duration,
      minMemoryMB: minMemory,
      maxMemoryMB: maxMemory,
      avgMemoryMB: avgMemory,
      currentMemoryMB: currentMemoryUsage,
      readings: List.unmodifiable(relevantReadings),
    );
  }
  
  @override
  LifecycleReport exportLifecycleData() {
    return LifecycleReport(
      appStartTime: _appStartTime ?? DateTime.now(),
      totalUptime: uptime,
      memoryHistory: List.unmodifiable(_memoryReadings),
      systemInfo: {
        'platform': Platform.operatingSystem,
        'version': Platform.operatingSystemVersion,
        'currentMemoryMB': currentMemoryUsage,
      },
      errorLog: List.unmodifiable(_errorLog),
    );
  }
  
  @override
  void logError(String error) {
    _errorLog.add("${DateTime.now().toIso8601String()}: $error");
    // console.debug("ERROR: $error");
  }
  
  @override
  Future<void> dispose() async {
    // console.debug("Disposing LifecycleService...");
    
    await stopMemoryMonitoring();
    await _memoryController.close();
    
    // console.debug("LifecycleService disposed");
  }
  
  // Helper methods
  
  void _analyzeAndLogMemoryPatterns(double currentMemory, DateTime now) {
    // Last hour analysis
    final lastHourAnalytics = getMemoryAnalytics(const Duration(hours: 1));
    if (lastHourAnalytics.readings.isNotEmpty) {
      // console.debug(
      //   "Last hour - Min: ${lastHourAnalytics.minMemoryMB.toStringAsFixed(2)}MB, "
      //   "Max: ${lastHourAnalytics.maxMemoryMB.toStringAsFixed(2)}MB, "
      //   "Avg: ${lastHourAnalytics.avgMemoryMB.toStringAsFixed(2)}MB\n"
      //   "Deltas - Min: ${lastHourAnalytics.minDelta.toStringAsFixed(2)}MB, "
      //   "Max: ${lastHourAnalytics.maxDelta.toStringAsFixed(2)}MB"
      // );
    }
    
    // Initial window analysis (3-13 minutes after start)
    if (_appStartTime != null) {
      final initStart = _appStartTime!.add(const Duration(minutes: 3));
      final initEnd = _appStartTime!.add(const Duration(minutes: 13));
      final initReadings = _memoryReadings.where((r) =>
          r.timestamp.isAfter(initStart) && r.timestamp.isBefore(initEnd)).toList();
      
      final uptimeStr = _formatDuration(uptime);
      
      if (initReadings.isNotEmpty) {
        final initValues = initReadings.map((r) => r.memoryMB).toList();
        final minInit = initValues.reduce((a, b) => a < b ? a : b);
        final maxInit = initValues.reduce((a, b) => a > b ? a : b);
        
        // console.debug(
        //   "Init window (3-13min), uptime: $uptimeStr\n"
        //   "Min: ${minInit.toStringAsFixed(2)}MB, Max: ${maxInit.toStringAsFixed(2)}MB\n"
        //   "Deltas - Min: ${(currentMemory - minInit).toStringAsFixed(2)}MB, "
        //   "Max: ${(currentMemory - maxInit).toStringAsFixed(2)}MB"
        // );
      } else {
        // console.debug("Init window (3-13min): no data yet (uptime: $uptimeStr)");
      }
    }
  }
  
  void _cleanupOldReadings() {
    final cutoff = DateTime.now().subtract(const Duration(hours: 24));
    _memoryReadings.removeWhere((reading) => reading.timestamp.isBefore(cutoff));
  }
  
  String _formatDateTime(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-"
           "${dt.month.toString().padLeft(2, '0')}-"
           "${dt.day.toString().padLeft(2, '0')} "
           "${dt.hour.toString().padLeft(2, '0')}:"
           "${dt.minute.toString().padLeft(2, '0')}";
  }
  
  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0 && minutes > 0) {
      return "${hours}h${minutes}m";
    } else if (hours > 0) {
      return "${hours}h";
    } else if (minutes > 0 && seconds > 0) {
      return "${minutes}m${seconds}s";
    } else if (minutes > 0) {
      return "${minutes}m";
    } else {
      return "${seconds}s";
    }
  }
}

// Singleton instance
final RuntimeMonitoringService RuntimeMonitoring = _RuntimeMonitoring();