import 'memory_reading.dart';

/// Memory usage analytics for different time windows.
class MemoryAnalytics {
  final Duration timeWindow;
  final double minMemoryMB;
  final double maxMemoryMB;
  final double avgMemoryMB;
  final double currentMemoryMB;
  final List<MemoryReading> readings;
  
  const MemoryAnalytics({
    required this.timeWindow,
    required this.minMemoryMB,
    required this.maxMemoryMB,
    required this.avgMemoryMB,
    required this.currentMemoryMB,
    required this.readings,
  });
  
  double get minDelta => currentMemoryMB - minMemoryMB;
  double get maxDelta => currentMemoryMB - maxMemoryMB;
  double get range => maxMemoryMB - minMemoryMB;
  
  @override
  String toString() => 'MemoryAnalytics(${timeWindow.inMinutes}min: ${minMemoryMB.toStringAsFixed(2)}-${maxMemoryMB.toStringAsFixed(2)}MB, avg: ${avgMemoryMB.toStringAsFixed(2)}MB)';
}