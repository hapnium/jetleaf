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
import 'package:path/path.dart' as p;

import '../_logger_printer.dart';
import '../commons/cli_command.dart';
import '../commons/constants.dart';
import '../commons/utils.dart';
import '../commons/spinner.dart';
import '../commons/prompts.dart' as prompt;
import 'cli_argument.dart';

/// {@template dev_runner_cli_argument}
/// Defines CLI arguments for the `dev` command in JetLeaf.
///
/// This class configures command-line flags and options used to launch
/// the application in development mode with optional hot reload support.
///
/// Supported options:
/// - `--watch` (`-w`): Enables hot reload when file changes are detected.
/// - `--entry` (`-e`): Sets the entry point Dart file for the application.
/// - `--help` (`-h`): Displays usage information for the dev command.
///
/// Example usage:
/// ```bash
/// jl dev --entry lib/main.dart --watch
/// ```
/// {@endtemplate}
class DevRunnerCliArgument extends CliArgument {
  /// {@macro dev_runner_cli_argument}
  DevRunnerCliArgument() : super(
    ArgParser(),
    'dev',
    'Launch the application in development mode.',
    cliSession.get("DEV")
  ) {
    parser.addOption('entry',
      abbr: 'e',
      help: 'Entry file',
    );
    parser.addFlag('watch',
      abbr: 'w',
      help: 'Enable hot reload',
      defaultsTo: true,
      negatable: false,
    );
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
    if (_handleHelp(results)) {
      return;
    }

    final entry = results["entry"] as String?;
    // final watch = results['watch'] as bool; // Not implemented hot reload, but keeping flag
    final remainingArgs = results.rest; // Arguments to pass to the Dart application

    try {
      final targetFile = await _determineEntryPoint(entry);
      
      this.loggingSession.info('🚀 Running: dart ${targetFile.path} ${remainingArgs.join(' ')}');
      this.loggingSession.space();

      await _copyJetLeafCoreAssets();

      await _executeApplication(targetFile, remainingArgs);

    } catch (e) {
      this.loggingSession.error('Error during dev run: $e');
      exit(1);
    }
  }

  /// Handles the `--help` flag.
  /// Returns `true` if help was displayed, `false` otherwise.
  bool _handleHelp(ArgResults results) {
    if (results['help'] == true) {
      this.loggingSession.info(parser.usage);
      return true;
    }
    return false;
  }

  /// Determines the application's entry point.
  ///
  /// If [entryPath] is provided, it validates the file.
  /// Otherwise, it searches the current project for a suitable entry file
  /// and prompts the user if multiple candidates are found.
  /// Throws an exception if no valid entry point is found or if multiple are found
  /// without user selection.
  Future<File> _determineEntryPoint(String? entryPath) async {
    final spinner = Spinner('Searching for entry point...');
    spinner.start();
    try {
      final candidates = <File>[];
      if (entryPath != null && entryPath.isNotEmpty) {
        final file = File(entryPath);
        if (!file.existsSync()) {
          throw Exception('Specified entry file does not exist: $entryPath');
        }
        final content = await file.readAsString();
        if (FileUtils.countMainFunctions(content) == 1 && FileUtils.containsJetApplicationRun(content)) {
          candidates.add(file);
        } else {
          throw Exception('Specified entry file "$entryPath" does not contain a single main function with JetApplication.run(...).');
        }
      } else {
        this.loggingSession.info('🔍 Searching for void main(...) and JetApplication.run(...) in current project...');
        final files = await FileUtils.findDartFiles(Directory.current, excludeDirs: ['target', 'build']);
        for (final file in files) {
          final content = await file.readAsString();
          if (FileUtils.countMainFunctions(content) == 1 && FileUtils.containsJetApplicationRun(content)) {
            candidates.add(file);
          }
        }
      }

      spinner.stop(successMessage: 'Entry point search complete.');

      if (candidates.isEmpty) {
        throw Exception('No file calling void main(...) with JetApplication.run(...) was found.');
      } else if (candidates.length > 1) {
        this.loggingSession.warn('⚠️  Multiple entry files found with void main(...) and JetApplication.run:');
        final selectedPath = prompt.choose<String>(
          'Please select the entry file to run:',
          candidates.map((f) => f.path),
          prompt: 'Enter the number corresponding to your choice',
        );
        if (selectedPath == null) {
          throw Exception('Multiple entry files found and no selection made. Operation cancelled.');
        }
        return File(selectedPath);
      }
      return candidates.first;
    } finally {
      spinner.stop(); // Ensure spinner is stopped even on error
    }
  }

  /// Copies JetLeaf core assets to the target directory for development mode.
  ///
  /// This ensures that necessary runtime assets are available to the application.
  Future<void> _copyJetLeafCoreAssets() async {
    final jetleafPackagePath = await FileUtils.findPackagePath(Constants.PACKAGE_NAME);
    if (jetleafPackagePath != null) {
      final sourceCoreDir = Directory(p.join(jetleafPackagePath, Constants.PACKAGE_ASSET_DIR));
      
      // Prompt for the target directory for JetLeaf assets
      String defaultTargetDir = p.join(Constants.TARGET_DIR, Constants.PACKAGE_ASSET_DIR_FOR_BUILD);
      final targetDirInput = prompt.get(
        'Enter the directory to copy JetLeaf core assets to (e.g., "target/jetleaf_assets")',
        defaultsTo: defaultTargetDir,
      );
      final targetCoreDir = Directory(targetDirInput);

      if (sourceCoreDir.existsSync()) {
        this.loggingSession.info('📦 Copying JetLeaf core assets from ${sourceCoreDir.path} to ${targetCoreDir.path}');
        await FileUtils.copyDirectory(sourceCoreDir, targetCoreDir);
      } else {
        this.loggingSession.warn('⚠️ JetLeaf core assets directory not found at ${sourceCoreDir.path}. Skipping copy.');
      }
    } else {
      this.loggingSession.warn('⚠️ Could not find jetleaf package path. Skipping JetLeaf core assets copy.');
    }
  }

  /// Executes the Dart application using `dart run`.
  ///
  /// [targetFile]: The entry point Dart file to run.
  /// [remainingArgs]: Additional arguments to pass to the Dart application.
  Future<void> _executeApplication(File targetFile, List<String> remainingArgs) async {
    final runSpinner = Spinner('Application running...');
    runSpinner.start();

    final process = await Process.start('dart', [targetFile.path, ...remainingArgs]);

    stdout.addStream(process.stdout);
    stderr.addStream(process.stderr);

    final exitCode = await process.exitCode;
    runSpinner.stop();

    if (exitCode != 0) {
      this.loggingSession.error('❌ Application exited with code: $exitCode');
      exit(exitCode);
    }
  }
}