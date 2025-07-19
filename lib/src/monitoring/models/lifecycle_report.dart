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

import 'memory_reading.dart';

/// Comprehensive lifecycle report containing all collected data.
class LifecycleReport {
  final DateTime appStartTime;
  final Duration totalUptime;
  final List<MemoryReading> memoryHistory;
  final Map<String, dynamic> systemInfo;
  final List<String> errorLog;
  
  const LifecycleReport({
    required this.appStartTime,
    required this.totalUptime,
    required this.memoryHistory,
    required this.systemInfo,
    required this.errorLog,
  });
  
  Map<String, dynamic> toJson() => {
    'appStartTime': appStartTime.toIso8601String(),
    'totalUptime': totalUptime.inMilliseconds,
    'memoryReadingCount': memoryHistory.length,
    'systemInfo': systemInfo,
    'errorCount': errorLog.length,
  };
}