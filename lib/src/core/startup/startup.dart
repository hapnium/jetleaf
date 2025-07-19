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

/// {@template startup}
/// Represents a startup lifecycle monitor for JetLeaf-based applications.
///
/// This interface defines timing-related hooks that allow modules and tools
/// to track the time it takes for the application to start and be ready.
///
/// It can be used to expose startup metrics, perform readiness checks,
/// or log time durations at various points during the boot process.
///
/// ---
///
/// ### Example
/// ```dart
/// class JetLeafStartup extends Startup {
///   final int _start = DateTime.now().millisecondsSinceEpoch;
///
///   @override
///   int getStartTime() => _start;
///
///   @override
///   int? getProcessUptime() => DateTime.now().millisecondsSinceEpoch - _start;
///
///   @override
///   String getAction() => 'JetLeaf started';
/// }
/// ```
/// {@endtemplate}
abstract class Startup {
  /// The time taken to reach the `started()` phase.
  late final Duration _timeTakenToStarted;

  /// Returns the system timestamp (in milliseconds since epoch) at which
  /// the application startup began.
  ///
  /// This value is used to calculate startup durations.
  int getStartTime();

  /// Returns the current process uptime in milliseconds since the
  /// application start time, or `null` if unsupported.
  ///
  /// Can be used for long-running diagnostic tools.
  int? getProcessUptime();

  /// Returns a string representation of the startup action,
  /// such as `'ApplicationContext refreshed'` or `'JetLeaf ready'`.
  String getAction();

  /// Marks the application as "started" and calculates the duration
  /// since `getStartTime()`.
  ///
  /// Stores the result in `_timeTakenToStarted` for future reference.
  ///
  /// ---
  ///
  /// ### Example
  /// ```dart
  /// final duration = startup.started();
  /// print('Started in ${duration.inMilliseconds}ms');
  /// ```
  Duration started() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _timeTakenToStarted = Duration(milliseconds: now - getStartTime());
    return _timeTakenToStarted;
  }

  /// Returns the time it took to reach the `started()` state.
  ///
  /// This will throw if `started()` has not yet been called.
  Duration getTimeTakenToStarted() => _timeTakenToStarted;

  /// Returns the current time elapsed since the application began starting.
  ///
  /// This is a live measure and recalculates on every call.
  ///
  /// ---
  ///
  /// ### Example
  /// ```dart
  /// print('App has been booting for: ${startup.getReady()}');
  /// ```
  Duration getReady() => Duration(milliseconds: DateTime.now().millisecondsSinceEpoch - getStartTime());
}