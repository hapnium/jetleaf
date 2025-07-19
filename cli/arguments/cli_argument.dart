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

import 'package:args/args.dart';

import '../_logger_printer.dart';
import '../commons/cli_command.dart';

/// {@template cli_argument}
/// Defines a contract for CLI argument handlers within the JetLeaf framework.
///
/// Each concrete implementation of [CliArgument] is responsible for:
/// - Defining a subcommand (e.g., `dev`, `prod`)
/// - Attaching options and flags via the [ArgParser]
/// - Executing logic associated with the command
/// - Providing help/usage information
///
/// Typical usage:
///
/// ```dart
/// class DevArgument extends CliArgument {
///   DevArgument()
///       : super(ArgParser(), 'dev', 'Run the application in development mode.', DevLogging());
///
///   @override
///   bool canUse(CliCommand command) => command.name == 'dev';
///
///   @override
///   Future<void> run(List<String> args, ArgResults results) async {
///     // Handle dev command
///   }
/// }
/// ```
/// {@endtemplate}
abstract class CliArgument {
  /// {@macro cli_argument}
  CliArgument(
    this.parser,
    this.command,
    this.description,
    this.loggingSession,
  );

  /// The `args` package parser for this command.
  ///
  /// Used to define and parse options and flags related to the subcommand.
  final ArgParser parser;

  /// The name of the CLI subcommand (e.g., `'dev'`, `'build'`, `'prod'`).
  final String command;

  /// A brief description of what the subcommand does.
  ///
  /// Typically used in usage messages.
  final String description;

  /// The logger session associated with this CLI command.
  ///
  /// Useful for scoping logs during execution.
  final Logger loggingSession;

  /// Determines whether this CLI argument handler should respond
  /// to the given [command].
  ///
  /// Typically compares [CliCommand.name] to [command].
  bool canUse(CliCommand command);

  /// Runs the CLI command with the provided arguments.
  ///
  /// - [args]: The raw command-line arguments.
  /// - [results]: The parsed results from [parser].
  ///
  /// Implement this to define the behavior when the command is invoked.
  Future<void> run(List<String> args, ArgResults results);

  /// Returns the formatted usage string for this subcommand.
  ///
  /// This uses the underlying `ArgParser.usage` to generate help output.
  String get usage => parser.usage;
}