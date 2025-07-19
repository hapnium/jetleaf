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

import 'startup.dart';

/// {@template standard_startup}
/// Default implementation of the {@macro startup} interface.
///
/// This class captures the system time when it is instantiated and uses
/// that as the reference point for all startup timing calculations.
///
/// It is suitable for most JetLeaf applications where basic timing
/// and readiness metrics are sufficient.
///
/// ---
///
/// ### Example
/// ```dart
/// final startup = StandardStartup();
///
/// // At the end of your boot sequence
/// startup.started();
/// print('JetLeaf started in ${startup.getTimeTakenToStarted().inMilliseconds}ms');
/// ```
/// {@endtemplate}
class StandardStartup extends Startup {
  /// Captures the current time in milliseconds since epoch
  /// as the start of the application.
  final int _startTime = DateTime.now().millisecondsSinceEpoch;

  /// {@macro startup.getStartTime}
  @override
  int getStartTime() => _startTime;

  /// {@macro startup.getProcessUptime}
  ///
  /// This implementation returns `null` because it does not track
  /// continuous uptime beyond the recorded startup time.
  @override
  int? getProcessUptime() => null;

  /// {@macro startup.getAction}
  ///
  /// Always returns `'Started'` as the startup description.
  @override
  String getAction() => 'Started';
}