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