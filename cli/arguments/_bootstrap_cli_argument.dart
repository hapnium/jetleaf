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
import '../commons/prompts.dart' as prompt;
import '../commons/utils.dart';
import '../commons/spinner.dart';
import 'cli_argument.dart';

/// {@template bootstrap_cli_argument}
/// Defines CLI arguments for the `generate` command used in JetLeaf bootstrapping.
///
/// This argument parser is responsible for parsing options and flags when the
/// user runs a `jetleaf generate` or similar command to scaffold the application.
///
/// Supported options:
/// - `--target` (`-t`): Path to the bootstrap file (defaults to `target/bootstrap.dart`)
/// - `--force`: Forces overwrite of the target file if it already exists.
/// - `--help` (`-h`): Displays usage help for this command.
///
/// Example usage:
/// ```bash
/// jl generate --target target/main.dart --force
/// ```
/// {@endtemplate}
class BootstrapCliArgument extends CliArgument {
  /// {@macro bootstrap_cli_argument}
  BootstrapCliArgument() : super(
    ArgParser(),
    'generate',
    'Generate a bootstrap file for the application.',
    cliSession.get("GEN")
  ) {
    parser.addOption('target',
      abbr: 't',
      help: 'Target file for the generated bootstrap code.',
    );
    parser.addOption('include_packages',
      abbr: 'i',
      help: 'Comma-separated list of packages to explicitly include for reflection.',
      defaultsTo: '',
    );
    parser.addOption('exclude_packages',
      abbr: 'e',
      help: 'Comma-separated list of packages to explicitly exclude from reflection.',
      defaultsTo: '',
    );
    parser.addOption('exclude_directories',
      abbr: 'd',
      help: 'Comma-separated list of directories to exclude from file scanning.',
      defaultsTo: 'build,target',
    );
    parser.addFlag('force',
      negatable: false,
      help: 'Force overwrite existing target file.',
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

    final stopwatch = Stopwatch()..start();

    String target = results['target'] as String? ?? Constants.DEFAULT_BOOTSTRAP_TARGET;
    final force = results['force'] as bool;
    final includePkgs = _splitCommaSeparated(results['include_packages'] as String);
    final excludePkgs = _splitCommaSeparated(results['exclude_packages'] as String);
    List<String> excludeDirs = _splitCommaSeparated(results['exclude_directories'] as String);

    // Prompt for target if not specified or if default is not desired
    target = prompt.get(
      'Enter the path for the generated bootstrap file',
      defaultsTo: target,
    );

    final targetFile = File(target);
    if (!await _confirmOverwrite(targetFile, force)) {
      this.loggingSession.info('Operation cancelled by user.');
      return;
    }

    // Prompt for exclude directories if default is not desired
    final confirmExcludeDirs = prompt.getBool(
      'Use default excluded directories (${excludeDirs.join(', ')})?',
      defaultsTo: true,
    );
    if (!confirmExcludeDirs) {
      final newExcludeDirs = prompt.get(
        'Enter comma-separated directories to exclude (e.g., "temp,dist")',
        defaultsTo: excludeDirs.join(','),
      );
      excludeDirs = _splitCommaSeparated(newExcludeDirs);
    }

    final buffer = StringBuffer();
    _writeHeader(buffer);

    final spinner = Spinner('Scanning project for Dart files...');
    spinner.start();

    try {
      List<File> allDartFiles = [];
      final packageName = await _readPackageName();
      final mainEntryFile = await _findMainEntryFile(excludeDirs, (files) => allDartFiles = files);
      
      final imports = await _generateImports(mainEntryFile, packageName, excludeDirs, includePkgs, excludePkgs);
      final configurationImports = await _generateConfigurationImports();
      final generatedPackageInfoImports = await _generatePackageInfoClasses(target, packageName);
      
      _writeCollectedImports(
        buffer: buffer,
        imports: imports,
        generatedPackageInfoImports: generatedPackageInfoImports,
        configurationImports: configurationImports,
      );
      
      Directory? resourcesDir;
      await _copyApplicationResources(target, (dir) => resourcesDir = dir);

      _writeMainFunction(buffer, mainEntryFile);
      
      await _writeBootstrapFile(targetFile, buffer);
      spinner.stop(successMessage: 'Generated bootstrap file at $target with ${imports.length} imports and ${generatedPackageInfoImports.length} PackageInfo classes.');

      stopwatch.stop();
      this.loggingSession.info('''
🍃 JetLeaf Bootstrap Summary
────────────────────────────────────────────────────────

📂 Target File:              ${p.normalize(target)}
🧠 Entry Point Found:        ${mainEntryFile.path}
📦 Package:                  $packageName

📊 Generation Stats:
   • Dart Files Scanned:     ${allDartFiles.length}
   • Imports Added:          ${imports.length}
   • Config Classes Found:   ${configurationImports.length}
   • PackageInfo Classes:    ${generatedPackageInfoImports.length}
   • Excluded Directories:   ${excludeDirs.join(', ')}

📁 Resources:
   • Copied To:              ${resourcesDir?.path}

✅ Bootstrap Status:         SUCCESS
   ✔ Bootstrap generated in ${stopwatch.elapsedMilliseconds}ms

🚀 Next:
   • Open ${p.normalize(target)} to view the generated bootstrap.
   • Run `jl build` to build the application.

────────────────────────────────────────────────────────
🔧 Powered by JetLeaf — the Dart backend engine 🍃
''');
    } catch (e) {
      spinner.stop();
      stopwatch.stop();
      this.loggingSession.error('Error during generate: $e');
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

  /// Confirms with the user whether to overwrite an existing target file.
  /// Returns `true` if the file can be overwritten or doesn't exist, `false` if cancelled.
  Future<bool> _confirmOverwrite(File targetFile, bool force) async {
    if (targetFile.existsSync() && !force) {
      final confirm = prompt.getBool(
        'File ${targetFile.path} already exists. Overwrite?',
        defaultsTo: false,
        appendYesNo: true,
      );
      return confirm;
    }
    return true;
  }

  /// Writes the standard JetLeaf bootstrap file header.
  void _writeHeader(StringBuffer buffer) {
    buffer.writeln('// ignore_for_file: unused_import');
    buffer.writeln();
    buffer.writeln(r'''
/// 🍃      _      _   _                __  ______  
/// 🍃     | | ___| |_| |    ___  __ _ / _| \ \ \ \ 
/// 🍃  _  | |/ _ \ __| |   / _ \/ _` | |_   \ \ \ \
/// 🍃 | |_| |  __/ |_| |__|  __/ (_| |  _|  / / / /
/// 🍃  \___/ \___|\__|_____\___|\__,_|_|   /_/_/_/ 
/// 🍃''');
    buffer.writeln('///');
    buffer.writeln('''
/// ---------------------------------------------------------------------------
/// JetLeaf Framework 🍃
///
/// Copyright (c) ${DateTime.now().year} Hapnium & JetLeaf Contributors
///
/// Licensed under the MIT License. See LICENSE file in the root of the jetleaf project
/// for full license information.
///
/// This file is part of the JetLeaf Framework, a modern, modular backend
/// framework for Dart inspired by the Spring ecosystem.
///
/// For documentation and usage, visit:
/// https://jetleaf.hapnium.com/docs
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃
''');
    buffer.writeln('///');
    buffer.writeln('/// AUTO-GENERATED by JetLeaf Bootstap Generator');
    buffer.writeln('/// Do not edit manually.\n');
  }

  /// Reads the package name from `pubspec.yaml`.
  /// Throws an exception if the package name cannot be determined.
  Future<String> _readPackageName() async {
    final packageName = await FileUtils.readPackageName(Directory.current);
    if (packageName == null) {
      throw Exception('Could not determine package name from pubspec.yaml. Ensure pubspec.yaml exists in the current directory.');
    }
    this.loggingSession.info('Detected package name: $packageName');
    return packageName;
  }

  /// Finds the single main entry point file for the application.
  ///
  /// Scans all Dart files in the current directory (excluding [excludeDirs])
  /// to find a file containing `void main(...)` and `JetApplication.run(...)`.
  /// Throws an exception if no such file is found or if multiple are found.
  Future<File> _findMainEntryFile(List<String> excludeDirs, [Function(List<File>)? onFound]) async {
    this.loggingSession.info('🔍 Searching for void main(...) and JetApplication.run(...) for bootstrap entry...');
    final allDartFiles = await FileUtils.findDartFiles(Directory.current, excludeDirs: excludeDirs);
    onFound?.call(allDartFiles);

    final mainCandidates = <File>[];
    for (final file in allDartFiles) {
      final content = await file.readAsString();
      if (FileUtils.countMainFunctions(content) == 1 && FileUtils.containsJetApplicationRun(content)) {
        mainCandidates.add(file);
      }
    }

    if (mainCandidates.isEmpty) {
      throw Exception('No file calling void main(...) with JetApplication.run(...) was found to bootstrap.');
    } else if (mainCandidates.length > 1) {
      this.loggingSession.warn('⚠️  Multiple entry files found with void main(...) and JetApplication.run:');
      for (var i = 0; i < mainCandidates.length; i++) {
        this.loggingSession.warn('  [${i + 1}] ${mainCandidates[i].path}');
      }
      throw Exception('Multiple entry files found. Cannot determine single entry for bootstrap. Please ensure only one main function with JetApplication.run exists in your source code ${excludeDirs.isNotEmpty ? 'excluding ${excludeDirs.join(", ")}' : ''}.');
    }
    this.loggingSession.info('✅ Found main entry point: ${mainCandidates.first.path}');
    return mainCandidates.first;
  }

  /// Generates import statements for all relevant Dart files.
  ///
  /// Excludes the main entry file and files in excluded directories.
  /// Applies include/exclude package filters.
  Future<Set<String>> _generateImports(
    File mainEntryFile,
    String packageName,
    List<String> excludeDirs,
    List<String> includePkgs,
    List<String> excludePkgs,
  ) async {
    final imports = <String>{};
    final allDartFiles = await FileUtils.findDartFiles(Directory.current, excludeDirs: excludeDirs);

    // Add import for the main entry file, aliased to avoid conflicts
    final mainEntryRelativePath = p.relative(mainEntryFile.path);
    final mainEntryPackageUri = FileUtils.resolveToPackageUri(mainEntryRelativePath, packageName);
    if (mainEntryPackageUri == null) {
      throw Exception('Could not resolve package URI for main entry file: ${mainEntryFile.path}. Ensure it is in a recognized source root like "lib/".');
    }
    imports.add("import '$mainEntryPackageUri' as user_main_lib;");
    // Import the base PackageInfo class from jetleaf
    imports.add("import 'package:jetleaf/reflection.dart' show PackageDescriptor;");

    for (final file in allDartFiles) {
      if (file.path == mainEntryFile.path) continue; // Skip the main entry file

      final relativePath = p.relative(file.path);
      if (_shouldInclude(relativePath, includePkgs, excludePkgs)) {
        final content = await file.readAsString();
        if (FileUtils.countMainFunctions(content) > 0) {
          this.loggingSession.warn('⚠️ Skipping import of ${file.path} as it contains a main function and is not the designated entry point. This might lead to unreachable code if not imported elsewhere.');
          continue;
        }
        final packageUri = FileUtils.resolveToPackageUri(relativePath, packageName);
        if (packageUri != null) {
          imports.add("import '$packageUri';");
        } else {
          this.loggingSession.warn('Could not resolve package URI for ${file.path}. Skipping import.');
        }
      }
    }
    return imports;
  }

  /// Generates import statements for all relevant Dart files.
  ///
  /// Scans the resources directory for Dart files containing a class that extends ConfigurationProperty.
  /// Returns a set of import statements for these files.
  Future<Set<String>> _generateConfigurationImports() async {
    final Set<String> imports = {};

    final resourcesDir = Directory('resources');
    if (!resourcesDir.existsSync()) return imports;

    final dartFiles = await FileUtils.findDartFiles(resourcesDir);
    for (final file in dartFiles) {
      final content = await file.readAsString();

      final hasConfigurationClass = RegExp(r'class\s+\w+\s+extends\s+ConfigurationProperty\b')
          .hasMatch(content);

      if (hasConfigurationClass) {
        final relativePath = p.relative(file.path);
        final normalizedPath = relativePath.replaceAll('\\', '/');
        imports.add("import '$normalizedPath';");
      }
    }

    return imports;
  }

  /// Generates `PackageInfo` classes for project dependencies and returns their import statements.
  ///
  /// These classes are used for reflection purposes in JetLeaf.
  /// [targetFilePath] is used to determine the relative path for generated files.
  Future<Set<String>> _generatePackageInfoClasses(String targetFilePath, String packageName) async {
    this.loggingSession.info('📦 Generating PackageInfo classes for dependencies...');
    final dependencies = await FileUtils.readPackageGraphDependencies(Directory.current);
    final generatedPackageInfoImports = <String>{};

    // Prompt for the directory to store generated package info files
    String defaultPackageInfoDir = p.join(FileUtils.getDirectory(targetFilePath), 'resources', 'packages');
    final packageInfoDirInput = prompt.get(
      'Enter the directory for generated PackageInfo files (e.g., "target/resources/packages")',
      defaultsTo: defaultPackageInfoDir,
    );
    final packageInfoDir = Directory(packageInfoDirInput);

    if (!packageInfoDir.existsSync()) {
      await packageInfoDir.create(recursive: true);
    }

    if (dependencies.isNotEmpty) {
      for (final dep in dependencies) {
        final sanitizedClassName = FileUtils.sanitizePackageName(dep.name);
        final fileName = '${sanitizedClassName.toLowerCase()}_package_info.dart';
        final filePath = p.join(packageInfoDir.path, fileName);
        final relativeFilePath = p.relative(filePath, from: FileUtils.getDirectory(targetFilePath));

        final packageInfoContent = '''
/// ---------------------------------------------------------------------------
/// JetLeaf Framework 🍃
///
/// Copyright (c) ${DateTime.now().year} Hapnium & JetLeaf Contributors
///
/// Licensed under the MIT License. See LICENSE file in the root of the jetleaf project
/// for full license information.
///
/// This file is part of the JetLeaf Framework, a modern, modular backend
/// framework for Dart inspired by the Spring ecosystem.
///
/// For documentation and usage, visit:
/// https://jetleaf.hapnium.com/docs
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃
/// 
/// AUTO-GENERATED by JetLeaf Bootstap Generator
/// Do not edit manually.

import 'package:jetleaf/reflection.dart' show PackageDescriptor;

class ${sanitizedClassName}PackageInfo extends PackageDescriptor {
  @override
  final String name = '${dep.name}';

  @override
  final String version = '${dep.version}';

  @override
  final String languageVersion = '${dep.languageVersion}';

  @override
  final bool isRootPackage = ${dep.isRootPackage};
}
''';
        await File(filePath).writeAsString(packageInfoContent);
        generatedPackageInfoImports.add("import '$relativeFilePath';");
      }
      this.loggingSession.info('✅ Generated ${dependencies.length} PackageInfo files in ${packageInfoDir.path}');
    } else {
      this.loggingSession.info('ℹ️ No dependencies found in .dart_tool/package_graph.json to generate PackageInfo for.');
    }
    return generatedPackageInfoImports;
  }

  /// Writes all collected import statements to the StringBuffer.
  void _writeCollectedImports({
    required StringBuffer buffer,
    required Set<String> imports,
    required Set<String> generatedPackageInfoImports,
    required Set<String> configurationImports,
  }) {
    for (final line in imports.toList()..sort()) {
      buffer.writeln(line);
    }
    for (final line in configurationImports.toList()..sort()) {
      buffer.writeln(line);
    }
    for (final line in generatedPackageInfoImports.toList()..sort()) {
      buffer.writeln(line);
    }
    buffer.writeln('\n'); // Add a newline after imports
  }

  /// Copies application resources from the user's project to the target directory.
  ///
  /// Prioritizes `resources/` in the root, then `lib/resources/`.
  /// [targetFilePath] is used to determine the destination for copied resources.
  Future<void> _copyApplicationResources(String targetFilePath, [Function(Directory)? onResourcesDirFound]) async {
    final rootResourcesDir = Directory(Constants.RESOURCES_DIR_NAME);
    final libResourcesDir = Directory(p.join('lib', Constants.RESOURCES_DIR_NAME));
    
    // Prompt for the target directory for copied resources
    String defaultTargetResourcesDir = p.join(FileUtils.getDirectory(targetFilePath), Constants.RESOURCES_DIR_NAME);
    final targetResourcesDirInput = prompt.get(
      'Enter the directory to copy application resources to (e.g., "target/resources")',
      defaultsTo: defaultTargetResourcesDir,
    );
    final targetResourcesDir = Directory(targetResourcesDirInput);

    if (rootResourcesDir.existsSync()) {
      this.loggingSession.info('📦 Copying resources from ${rootResourcesDir.path} to ${targetResourcesDir.path}');
      await FileUtils.copyDirectory(rootResourcesDir, targetResourcesDir);
      onResourcesDirFound?.call(rootResourcesDir);
    } else if (libResourcesDir.existsSync()) {
      this.loggingSession.info('📦 Copying resources from ${libResourcesDir.path} to ${targetResourcesDir.path}');
      await FileUtils.copyDirectory(libResourcesDir, targetResourcesDir);
      onResourcesDirFound?.call(libResourcesDir);
    } else {
      this.loggingSession.info('ℹ️ No resources folder found. Creating empty ${targetResourcesDir.path}.');
      await targetResourcesDir.create(recursive: true); // Ensure folder exists even if empty
    }
  }

  /// Writes the main function for the bootstrap file, which calls the user's main function.
  void _writeMainFunction(StringBuffer buffer, File mainEntryFile) {
    buffer.writeln('''
void main(List<String> args) {
  user_main_lib.main(args); // Call the user's main function from their main entry point
}
''');
    buffer.writeln('\n');
  }

  /// Writes the final generated content to the target bootstrap file.
  Future<void> _writeBootstrapFile(File targetFile, StringBuffer buffer) async {
    await targetFile.parent.create(recursive: true);
    await targetFile.writeAsString(buffer.toString());
  }

  /// Splits a comma-separated string into a list of trimmed strings.
  List<String> _splitCommaSeparated(String input) {
    return input.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Determines if a given file path should be included based on include/exclude package lists.
  bool _shouldInclude(String path, List<String> includePkgs, List<String> excludePkgs) {
    final segments = p.split(path);
    if (segments.isEmpty) return false;

    final isInExcluded = excludePkgs.any((ex) => path.startsWith('$ex/') || path == ex);
    if (isInExcluded) return false;

    if (includePkgs.isEmpty) return true;
    return includePkgs.any((inc) => path.startsWith('$inc/') || path == inc);
  }
}
