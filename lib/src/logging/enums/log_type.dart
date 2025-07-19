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

import 'package:jetleaf/lang.dart';

/// Specifies the overall formatting strategy used for log output.
///
/// Different [LogType]s determine how verbose, styled, or structured the logs are.
enum LogType {
  /// Basic flat log format with minimal styling.
  FLAT,

  /// Flat layout with structured key/value formatting.
  FLAT_STRUCTURED,

  /// Pretty format with boxed, styled output.
  PRETTY,

  /// Pretty format with structured sections and symbols.
  PRETTY_STRUCTURED,

  /// Prefix-based logs, where each line begins with a level/tag.
  PREFIX,

  /// printf-style formatting with placeholders and patterns.
  FMT,

  /// Compact single-line logs suitable for CLI or minimal environments.
  SIMPLE,

  /// Hybrid format combining flat and pretty elements.
  HYBRID;

  /// Returns the [LogType] corresponding to the given name.
  /// 
  /// If the name does not match any [LogType], an [InvalidArgumentException] is thrown.
  static LogType fromString(String name) {
    return LogType.values.firstWhere((e) => e.name.equalsIgnoreCase(name))
      .getOrThrow("Invalid log type: $name. Available log types: ${LogType.values.map((e) => e.name).join(", ")}");
  }
}