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

import 'dart:io';

import 'package:jetleaf/logging.dart';
import 'package:jetleaf/src/logging/helpers/commons.dart';

/// A simple logger class for CLI output.
class Logger {
  final String name;

  /// Creates a new [Logger] instance with a given [name].
  Logger(this.name);

  /// Logs an informational message.
  void info(String message) {
    final color = LogCommons.levelColors[LogLevel.INFO]!;
    final emoji = LogCommons.levelEmojis[LogLevel.INFO]!;
    stdout.writeln('${color.call('[$name]')} ${color.call('$emoji INFO:')} $message');
  }

  /// Logs a warning message.
  void warn(String message) {
    final color = LogCommons.levelColors[LogLevel.WARN]!;
    final emoji = LogCommons.levelEmojis[LogLevel.WARN]!;
    stdout.writeln('${color.call('[$name]')} ${color.call('$emoji WARN:')} $message');
  }

  /// Logs an error message.
  void error(String message) {
    final color = LogCommons.levelColors[LogLevel.ERROR]!;
    final emoji = LogCommons.levelEmojis[LogLevel.ERROR]!;
    stderr.writeln('${color.call('[$name]')} ${color.call('$emoji ERROR:')} $message');
  }

  /// Prints an empty line for spacing.
  void space() => stdout.writeln('');
}

/// A simple session manager for CLI loggers.
class CliSession {
  /// Retrieves a [Logger] instance by name.
  Logger get(String name) => Logger(name);
}

/// Global instance of [CliSession].
final cliSession = CliSession();