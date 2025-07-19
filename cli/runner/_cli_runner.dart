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

import 'package:args/args.dart';

import '../_logger_printer.dart';
import '../arguments/_bootstrap_cli_argument.dart';
import '../arguments/_help_cli_argument.dart';
import '../arguments/cli_argument.dart';
import 'cli_runner.dart';
import '../arguments/_dev_runner_cli_argument.dart';
import '../arguments/_build_runner_cli_argument.dart';
import '../commons/cli_command.dart';
import '../commons/prompts.dart' as prompt;

/// The current version of the CLI tool.
const String cliVersion = '1.0.0';

class CliRunnerImpl implements CliRunner {
  late final List<CliArgument> _arguments;

  Logger get logger => cliSession.get("CLI");

  /// Creates a new [CliRunnerImpl] instance, registering all available commands.
  CliRunnerImpl() {
    _arguments = [
      DevRunnerCliArgument(),
      BuildRunnerCliArgument(),
      BootstrapCliArgument(),
    ];
    // Add help command last, as it needs access to all other commands
    _arguments.add(HelpCliArgument(_arguments));
  }

  @override
  Future<void> run(List<String> args) async {
    if (_handleGlobalFlags(args)) {
      return;
    }

    if (await _handleNoCommand(args)) {
      return;
    }

    final commandName = args.first;
    final commandArgs = args.skip(1).toList();

    await _findAndRunCommand(commandName, commandArgs);
  }

  /// Handles global flags like `--version` or `-v`.
  /// Returns `true` if a global flag was handled, `false` otherwise.
  bool _handleGlobalFlags(List<String> args) {
    if (args.contains('--version') || args.contains('-v')) {
      logger.info('JetLeaf CLI Version: $cliVersion');
      return true;
    }
    return false;
  }

  /// Handles cases where no command is provided or help flags are present.
  /// Returns `true` if help was displayed, `false` otherwise.
  Future<bool> _handleNoCommand(List<String> args) async {
    if (args.isEmpty || args.contains('--help') || args.contains('-h') || args.contains('help')) {
      logger.info('No command specified. Showing general help.');
      await HelpCliArgument(_arguments).run([], ArgParser().parse([]));
      return true;
    }
    return false;
  }

  /// Finds the appropriate [CliArgument] for the given command name and executes it.
  /// Handles argument parsing errors and unknown commands.
  Future<void> _findAndRunCommand(String commandName, List<String> commandArgs) async {
    CliArgument? targetCommand;
    try {
      targetCommand = _arguments.firstWhere(
        (cmd) => cmd.canUse(CliCommand.fromString(commandName)),
      );
    } catch (e) {
      logger.error('❌ Unknown command: "$commandName".');
      final showHelp = prompt.getBool(
        'Would you like to see the list of available commands?',
        defaultsTo: true,
      );
      if (showHelp) {
        await HelpCliArgument(_arguments).run([], ArgParser().parse([]));
      }
      exit(1);
    }

    try {
      final parsedResults = targetCommand.parser.parse(commandArgs);
      // If --help is explicitly requested for a command, show its usage
      if (parsedResults['help'] == true) {
        logger.info('Usage for "${targetCommand.command}":');
        logger.info(targetCommand.usage);
      } else {
        await targetCommand.run(commandArgs, parsedResults);
      }
    } on FormatException catch (e) {
      logger.error('❌ Argument parsing error for command "${targetCommand.command}": ${e.message}');
      logger.info('Usage for "${targetCommand.command}":');
      logger.info(targetCommand.usage);
      exit(1);
    } catch (e) {
      logger.error('An unexpected error occurred during command "${targetCommand.command}" execution: $e');
      exit(1);
    }
  }
}