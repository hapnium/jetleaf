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

/// {@template build_runner_cli_argument}
/// Defines CLI arguments for the `build` command in JetLeaf.
///
/// This class configures command-line options used to build the application
/// in production mode, specifically targeting precompiled `.dill` files.
///
/// Supported options:
/// - `--target` (`-t`): Full path to the `.dill` file. Default: `build/main.dill`.
/// - `--source` (`-s`): Source Dart file to compile. Default: `target/bootstrap.dart`.
/// - `--force`: Forces overwrite of any existing `.dill` file.
/// - `--help` (`-h`): Displays usage help for this command.
///
/// Example:
/// ```bash
/// dart jetleaf.dart build --file build/server.dill --force
/// ```
/// {@endtemplate}
class BuildRunnerCliArgument extends CliArgument {
  /// {@macro build_runner_cli_argument}
  BuildRunnerCliArgument() : super(
    ArgParser(),
    'build',
    'Build the application in production mode.',
    cliSession.get("PROD")
  ) {
    parser.addOption('target',
      abbr: 't',
      help: 'Path to .dill file (e.g., "build/main.dill").',
    );
    parser.addOption('source',
      abbr: 's',
      help: 'Source file to compile (e.g., "target/bootstrap.dart").',
    );
    parser.addFlag('force',
      negatable: false,
      help: 'Force overwrite existing .dill file.',
    );
    parser.addFlag('help',
      abbr: 'h',
      negatable: false,
      help: 'Show this help message.',
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

    final stopWatch = Stopwatch()..start();

    String source = results["source"] as String? ?? Constants.DEFAULT_BOOTSTRAP_TARGET;
    String target = results["target"] as String? ?? Constants.DEFAULT_BUILD_TARGET;
    final force = results['force'] as bool;

    // Prompt for source and target if not specified or if defaults are not desired
    source = prompt.get(
      'Enter the source Dart file to compile (e.g., "target/bootstrap.dart")',
      defaultsTo: source,
    );
    target = prompt.get(
      'Enter the output path for the compiled .dill file (e.g., "build/main.dill")',
      defaultsTo: target,
    );

    final buildSpinner = Spinner('Preparing build environment...');
    buildSpinner.start();

    try {
      await _prepareBuildDirectory(target);
      await _copyApplicationResources(target);
      await _copyJetLeafCoreAssets(target);
      await _validateSourceFile(source);

      buildSpinner.stop(successMessage: 'Build environment ready.');

      final compileSpinner = Spinner('Compiling application...');
      compileSpinner.start();
      final dillFileSize = await _compileApplication(target, source, force: force);
      compileSpinner.stop(successMessage: 'Build completed successfully.');
      stopWatch.stop();

      this.loggingSession.info('''
🍃 JetLeaf Build Summary
────────────────────────────────────────────────────────────

📂 Source File:           ${p.normalize(source)}
📦 Output .dill File:     ${p.normalize(target)}
🗂️  Output File Size:      ${dillFileSize}
🔁 Overwrite Enabled:     ${force ? 'Yes' : 'No'}

📁 Resources & Assets:
   • Resources copied to:  ${p.join(p.dirname(target), Constants.RESOURCES_DIR_NAME)}
   • JetLeaf assets to:    ${p.join(p.dirname(target), Constants.PACKAGE_ASSET_DIR_FOR_BUILD)}

✅ Build Completed Successfully in ${stopWatch.elapsedMilliseconds}ms

🚀 Next Steps:
   • Run the app:
       dart run ${p.normalize(target)}

   • You can add additional arguments to the run command to enable features like:
       --watch     → hot-reload dev mode
       --inspect   → view project info

📘 Tips:
   • Edit bootstrap in:    ${Constants.DEFAULT_BOOTSTRAP_TARGET}
   • Dev resources:        https://jetleaf.hapnium.com/docs

────────────────────────────────────────────────────────────
🔧 Powered by JetLeaf — the Dart backend engine 🍃
''');
    } catch (e) {
      stopWatch.stop();
      buildSpinner.stop(); // Ensure spinner is stopped on error
      this.loggingSession.error('Error during build run: $e');
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

  /// Prepares the build directory by creating it if it doesn't exist.
  Future<void> _prepareBuildDirectory(String targetPath) async {
    final buildDir = Directory(p.dirname(targetPath));
    if (!buildDir.existsSync()) {
      this.loggingSession.info('📁 Creating build directory: ${buildDir.path}');
      await buildDir.create(recursive: true);
    }
  }

  /// Copies application resources from the user's project to the build output directory.
  ///
  /// Prioritizes `target/resources` (from bootstrap), then `resources/` in the root.
  Future<void> _copyApplicationResources(String targetPath) async {
    final buildDir = Directory(p.dirname(targetPath));
    final targetResourcesDir = Directory(p.join(p.dirname(Constants.DEFAULT_BOOTSTRAP_TARGET), Constants.RESOURCES_DIR_NAME));
    final rootResourcesDir = Directory(Constants.RESOURCES_DIR_NAME);
    
    // Prompt for the target directory for copied resources
    String defaultBuildResourcesDir = p.join(buildDir.path, Constants.RESOURCES_DIR_NAME);
    final buildResourcesDirInput = prompt.get(
      'Enter the directory to copy application resources to (e.g., "build/resources")',
      defaultsTo: defaultBuildResourcesDir,
    );
    final buildResourcesDir = Directory(buildResourcesDirInput);

    if (targetResourcesDir.existsSync()) {
      this.loggingSession.info('📦 Copying resources from ${targetResourcesDir.path} to ${buildResourcesDir.path}');
      await FileUtils.copyDirectory(targetResourcesDir, buildResourcesDir);
    } else if (rootResourcesDir.existsSync()) {
      this.loggingSession.info('📦 Copying resources from ${rootResourcesDir.path} to ${buildResourcesDir.path}');
      await FileUtils.copyDirectory(rootResourcesDir, buildResourcesDir);
    } else {
      this.loggingSession.info('ℹ️ No resources folder found. Creating empty ${buildResourcesDir.path}');
      await buildResourcesDir.create(recursive: true); // Ensure folder exists even if empty
    }
  }

  /// Copies JetLeaf core assets to the build output directory for production mode.
  ///
  /// This ensures that necessary runtime assets are available to the compiled application.
  Future<void> _copyJetLeafCoreAssets(String targetPath) async {
    final buildDir = Directory(p.dirname(targetPath));
    final jetleafPackagePath = await FileUtils.findPackagePath(Constants.PACKAGE_NAME);
    if (jetleafPackagePath != null) {
      final sourceCoreDir = Directory(p.join(jetleafPackagePath, Constants.PACKAGE_ASSET_DIR));
      
      // Prompt for the target directory for JetLeaf assets
      String defaultTargetCoreDir = p.join(buildDir.path, Constants.PACKAGE_ASSET_DIR_FOR_BUILD);
      final targetCoreDirInput = prompt.get(
        'Enter the directory to copy JetLeaf core assets to (e.g., "build/jetleaf_assets")',
        defaultsTo: defaultTargetCoreDir,
      );
      final targetCoreDir = Directory(targetCoreDirInput);

      if (sourceCoreDir.existsSync()) {
        this.loggingSession.info('📦 Copying jet_leaf core assets from ${sourceCoreDir.path} to ${targetCoreDir.path}');
        await FileUtils.copyDirectory(sourceCoreDir, targetCoreDir);
      } else {
        this.loggingSession.warn('⚠️ JetLeaf core assets directory not found at ${sourceCoreDir.path}. Skipping copy.');
      }
    } else {
      this.loggingSession.warn('⚠️ Could not find JetLeaf package path. Skipping JetLeaf core assets copy.');
    }
  }

  /// Validates the source file before compilation.
  /// Checks for existence and ensures there's at most one `main` function.
  Future<void> _validateSourceFile(String sourcePath) async {
    if (!FileUtils.exists(sourcePath)) {
      throw Exception('Source file not found: $sourcePath\n'
          'Make sure your JetLeaf app has a bin/main.dart entry point or a generated bootstrap file.');
    }
    final sourceContent = await File(sourcePath).readAsString();
    final mainCount = FileUtils.countMainFunctions(sourceContent);
    if (mainCount > 1) {
      throw Exception('Multiple main functions found in source file: $sourcePath. Only one main function is allowed for compilation.');
    } else if (mainCount == 0) {
      this.loggingSession.warn('⚠️ No main function found in source file: $sourcePath. Compilation might fail.');
    }
  }

  /// Compiles the Dart application to a `.dill` file.
  ///
  /// [target]: The output path for the `.dill` file.
  /// [source]: The source Dart file to compile.
  /// [force]: Whether to force overwrite an existing `.dill` file.
  Future<String> _compileApplication(String target, String source, {bool force = false}) async {
    if (FileUtils.exists(target) && !force) {
      final confirm = prompt.getBool(
        'Dill file $target already exists. Overwrite?',
        defaultsTo: false,
        appendYesNo: true,
      );
      if (!confirm) {
        throw Exception('Compilation cancelled by user.');
      }
    }
    
    final result = await Process.run('dart', [
      'compile',
      'kernel',
      source,
      '-o',
      target,
    ]);

    if (result.exitCode != 0) {
      throw Exception('Build failed:\n${result.stderr}');
    }

    if (!FileUtils.exists(target)) {
      throw Exception('Build completed but .dill file was not created: $target');
    }
    final fileSize = await File(target).length();
    this.loggingSession.info('📦 Created ${_formatBytes(fileSize)} .dill file');

    return _formatBytes(fileSize);
  }

  /// Formats a byte count into a human-readable string (e.g., 1.2MB).
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }
}