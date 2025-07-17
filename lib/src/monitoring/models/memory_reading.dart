/// Represents a memory reading at a specific point in time.
class MemoryReading {
  final DateTime timestamp;
  final double memoryMB;
  final Duration uptime;
  
  const MemoryReading({
    required this.timestamp,
    required this.memoryMB,
    required this.uptime,
  });
  
  @override
  String toString() => 'MemoryReading(${timestamp.toIso8601String()}, ${memoryMB.toStringAsFixed(2)}MB, uptime: $uptime)';
}