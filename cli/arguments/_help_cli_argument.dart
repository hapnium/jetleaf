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
import 'cli_argument.dart';

/// {@template help_cli_argument}
/// Defines the CLI argument for the `help` command.
///
/// This command is used to display general help information about the CLI
/// or specific help for a given command.
/// {@endtemplate}
class HelpCliArgument extends CliArgument {
  /// A list of all available CLI commands.
  final List<CliArgument> allCommands;

  /// {@macro help_cli_argument}
  HelpCliArgument(this.allCommands) : super(
    ArgParser(),
    'help',
    'Show help for commands or the application.',
    cliSession.get("HELP")
  ) {
    parser.addFlag('help',
      abbr: 'h',
      negatable: false,
      help: 'Show this help message',
    );
  }

  @override
  bool canUse(CliCommand command) {
    return command.equals(this.command);
  }

  @override
  Future<void> run(List<String> args, ArgResults results) async {
    if (args.isEmpty || (args.length == 1 && results['help'] == true)) {
      _showGeneralHelp();
    } else {
      final commandName = args.first;
      _showSpecificCommandHelp(commandName);
    }
  }

  /// Displays the general help message for the CLI.
  void _showGeneralHelp() {
    this.loggingSession.info('🍃 JetLeaf CLI - Command Line Interface');
    this.loggingSession.space();
    this.loggingSession.info('Usage: jl <command> [options]');
    this.loggingSession.space();
    this.loggingSession.info('Available Commands:');
    for (final cmd in allCommands) {
      this.loggingSession.info('  ${cmd.command.padRight(10)} ${cmd.description}');
    }
    this.loggingSession.space();
    this.loggingSession.info('Run "jl <command> --help" for more information on a specific command.');
  }

  /// Displays help for a specific command.
  /// [commandName]: The name of the command to show help for.
  void _showSpecificCommandHelp(String commandName) {
    try {
      final targetCommand = allCommands.firstWhere(
        (cmd) => cmd.command == commandName,
      );
      this.loggingSession.info('Usage for "${targetCommand.command}":');
      this.loggingSession.info(targetCommand.usage);
    } catch (e) {
      this.loggingSession.error('❌ Unknown command: $commandName');
      _showGeneralHelp();
    }
  }
}