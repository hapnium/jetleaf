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