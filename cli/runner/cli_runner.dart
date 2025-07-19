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

/// {@template cli_runner}
/// A contract for executing CLI-based workflows in the JetLeaf ecosystem.
///
/// Implementations of this interface are responsible for parsing and handling
/// CLI arguments, dispatching to appropriate commands, and executing
/// the logic associated with each command mode (e.g., `dev`, `prod`, `generate`).
///
/// Example:
/// ```dart
/// class MyRunner implements CliRunner {
///   @override
///   Future<void> run(List<String> args) async {
///     // handle CLI logic
///   }
/// }
/// ```
/// {@endtemplate}
abstract interface class CliRunner {
  /// {@macro cli_runner}
  Future<void> run(List<String> args);
}