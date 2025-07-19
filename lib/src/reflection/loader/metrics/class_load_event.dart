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

/// {@template class_load_event}
/// Represents a single class loading attempt in the JetLeaf class loader.
///
/// Contains metadata about the attempt such as the class name,
/// time of the attempt, whether it succeeded, how long it took,
/// and any error that occurred if the loading failed.
///
/// This is useful for diagnostics, logging, or performance analysis
/// of the class loading mechanism.
///
/// ### Example:
/// ```dart
/// final event = ClassLoadEvent(
///   className: 'package:example/example.dart',
///   timestamp: DateTime.now(),
///   duration: Duration(milliseconds: 12),
///   success: true,
/// );
/// ```
/// {@endtemplate}
class ClassLoadEvent {
  /// The name of the class being loaded.
  final String className;

  /// The timestamp when the class load started or was recorded.
  final DateTime timestamp;

  /// The time it took to load the class, if measured.
  final Duration? duration;

  /// Whether the class was successfully loaded.
  final bool success;

  /// The error thrown during loading, if it failed.
  final Object? error;

  /// {@macro class_load_event}
  ClassLoadEvent({
    required this.className,
    required this.timestamp,
    this.duration,
    required this.success,
    this.error,
  });
}