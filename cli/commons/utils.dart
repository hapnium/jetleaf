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

import 'dart:convert';
import 'dart:io';
import 'package:jetleaf/logging.dart';
import 'package:jetleaf/reflection.dart';
import 'package:path/path.dart' as p;

/// {@template ansi_esc}
/// ANSI escape sequence introducer for terminal control.
/// {@endtemplate}
const String _ansiEsc = '\x1B';

/// {@template carriage_return}
/// ASCII carriage return used to reset to the beginning of the current line.
/// {@endtemplate}
const String _cr = '\r';

/// {@template go_up_one_line}
/// Moves the terminal cursor one line up using ANSI escape codes.
/// {@endtemplate}
void goUpOneLine() {
  if (stdout.supportsAnsiEscapes) {
    stdout.write('$_ansiEsc[1A');
  }
}

/// {@template clear_line}
/// Clears the current terminal line using ANSI escape codes and
/// resets the cursor to the beginning of the line.
/// {@endtemplate}
void clearLine() {
  if (stdout.supportsAnsiEscapes) {
    stdout.write('$_cr$_ansiEsc[2K');
  }
}

/// {@template wrap_with}
/// Applies multiple [AnsiColor] styles to a given [msg] string.
///
/// Useful for combining text styles like bold, underline, and colors.
///
/// Example:
/// ```dart
/// print(wrapWith('Hello', [AnsiColor.RED, AnsiColor.BOLD]));
/// ```
/// {@endtemplate}
String wrapWith(String msg, List<AnsiColor> codes) {
  if (!stdout.supportsAnsiEscapes) return msg;
  String result = msg;
  for (final code in codes) {
    result = code.call(result);
  }
  return result;
}

/// {@template file_utils}
/// Utility class for common file system operations in JetLeaf.
///
/// Provides methods for checking file existence, resolving directory paths,
/// copying directories, scanning Dart files, and analyzing Dart file content.
/// {@endtemplate}
class FileUtils {
  /// {@macro file_utils}

  /// Checks if a file or directory exists at the given [path].
  ///
  /// This returns `true` if either a file or a directory exists,
  /// and `false` otherwise.
  ///
  /// Example:
  /// ```dart
  /// if (FileUtils.exists('lib/main.dart')) {
  ///   print('File exists');
  /// }
  /// ```
  static bool exists(String path) {
    return File(path).existsSync() || Directory(path).existsSync();
  }

  /// Returns the parent directory of a given [path].
  ///
  /// This uses `package:path/path.dart` to resolve the directory.
  ///
  /// Example:
  /// ```dart
  /// print(FileUtils.getDirectory('/home/user/project/main.dart'));
  /// // Output: /home/user/project
  /// ```
  static String getDirectory(String path) {
    return p.dirname(path);
  }

  /// Recursively finds all `.dart` files in the specified [directory].
  ///
  /// This scans the entire directory tree (non-symlink) and returns
  /// a list of all files ending in `.dart`.
  ///
  /// Example:
  /// ```dart
  /// final files = await FileUtils.findDartFiles(Directory.current);
  /// print('Found ${files.length} Dart files');
  /// ```
  static Future<List<File>> findDartFiles(Directory directory, {List<String> excludeDirs = const ['target', 'build']}) async {
    final result = <File>[];
    if (!directory.existsSync()) return result;

    final absoluteExcludePaths = excludeDirs.map((dir) => p.join(directory.path, dir)).toList();

    await for (final entity in directory.list(recursive: true, followLinks: false)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        bool shouldExclude = false;
        for (final excludePath in absoluteExcludePaths) {
          if (p.isWithin(excludePath, entity.path)) {
            shouldExclude = true;
            break;
          }
        }
        if (!shouldExclude) {
          result.add(entity);
        }
      }
    }
    return result;
  }

  /// Recursively copies all files and directories from [source] to [destination].
  ///
  /// This will create missing directories in the destination path and overwrite
  /// existing files with the same names.
  ///
  /// Example:
  /// ```dart
  /// await FileUtils.copyDirectory(Directory('src'), Directory('backup/src'));
  /// ```
  static Future<void> copyDirectory(Directory source, Directory destination) async {
    if (!source.existsSync()) {
      return;
    }
    if (!destination.existsSync()) {
      await destination.create(recursive: true);
    }

    await for (var entity in source.list(recursive: true, followLinks: false)) {
      final newPath = p.join(destination.path, p.relative(entity.path, from: source.path));
      if (entity is File) {
        await entity.copy(newPath);
      } else if (entity is Directory) {
        await Directory(newPath).create(recursive: true);
      }
    }
  }

  /// Counts the number of top-level `main()` functions in [content].
  ///
  /// This is helpful for detecting potential entry points in a Dart source file.
  ///
  /// Example:
  /// ```dart
  /// int count = FileUtils.countMainFunctions(File('main.dart').readAsStringSync());
  /// ```
  static int countMainFunctions(String content) {
    final mainRegex = RegExp(
      r'void\s+main\s*\(\s*(?:List<\s*String\s*>\s*\w*\s*)?\)\s*{',
      multiLine: true,
    );
    return mainRegex.allMatches(content).length;
  }

  /// Checks whether the Dart source [content] calls `JetApplication.run()`.
  ///
  /// This can be used to identify the main bootstrapping class in a JetLeaf project.
  ///
  /// Example:
  /// ```dart
  /// bool hasRun = FileUtils.containsJetApplicationRun(File('main.dart').readAsStringSync());
  /// ```
  static bool containsJetApplicationRun(String content) {
    return content.contains('JetApplication.run(');
  }

  /// Reads the package name from pubspec.yaml.
  static Future<String?> readPackageName(Directory projectRoot) async {
    final pubspecFile = File(p.join(projectRoot.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      return null;
    }
    final lines = await pubspecFile.readAsLines();
    for (final line in lines) {
      if (line.startsWith('name:')) {
        return line.substring('name:'.length).trim();
      }
    }
    return null;
  }

  /// Reads dependencies from .dart_tool/package_graph.json.
  static Future<List<Package>> readPackageGraphDependencies(Directory projectRoot) async {
    final graphFile = File(p.join(projectRoot.path, '.dart_tool', 'package_graph.json'));
    final configFile = File(p.join(projectRoot.path, '.dart_tool', 'package_config.json'));

    if (!graphFile.existsSync()) return [];

    Map<String, dynamic> graph = {};
    Map<String, dynamic> config = {};

    try {
      graph = jsonDecode(await graphFile.readAsString());
    } catch (e) {
      print('Error reading package_graph.json: $e');
      return [];
    }

    if (configFile.existsSync()) {
      try {
        config = jsonDecode(await configFile.readAsString());
      } catch (e) {
        print('Error reading package_config.json: $e');
      }
    }

    final roots = Set<String>.from(graph['roots'] ?? []);
    final graphPackages = Map.fromEntries(
      (graph['packages'] as List)
          .whereType<Map>()
          .map((pkg) => MapEntry(pkg['name'], pkg['version'])),
    );

    final configPackages = config['packages'] as List<dynamic>? ?? [];

    final result = <Package>[];

    for (final entry in configPackages) {
      if (entry is Map<String, dynamic>) {
        final name = entry['name'] as String?;
        final rootUri = entry['rootUri'] as String?;
        final langVersion = entry['languageVersion'] as String?;
        final version = graphPackages[name];

        if (name != null && version != null) {
          final isRoot = rootUri == '../' || roots.contains(name);
          result.add(Package(
            name: name,
            version: version,
            languageVersion: langVersion,
            isRootPackage: isRoot,
          ));
        }
      }
    }

    // If config is missing or empty, fallback to graph only
    if (result.isEmpty) {
      for (final pkg in graphPackages.entries) {
        result.add(Package(
          name: pkg.key,
          version: pkg.value,
          languageVersion: null,
          isRootPackage: roots.contains(pkg.key),
        ));
      }
    }

    return result;
  }

  /// Resolves a file path to a package URI.
  /// Example: 'lib/src/my_file.dart' -> 'package:my_package/src/my_file.dart'
  static String? resolveToPackageUri(String filePath, String packageName) {
    // Normalize path separators for consistency
    final normalizedPath = filePath.replaceAll(r'\', '/');

    if (normalizedPath.startsWith('lib/')) {
      return 'package:$packageName/${normalizedPath.substring(4)}';
    }
    // Add more logic here if you have other source roots like 'bin/', 'web/' etc.
    // For now, only 'lib/' is handled as a package URI source.
    return null;
  }

  /// Sanitizes a package name to be used as a valid Dart class name segment.
  /// Converts kebab-case or dot-separated names to PascalCase.
  static String sanitizePackageName(String packageName) {
    return packageName
        .split(RegExp(r'[-_.]')) // Split by hyphens, underscores, or dots
        .map((segment) => segment.isEmpty ? '' : '${segment[0].toUpperCase()}${segment.substring(1)}')
        .join();
  }

  /// Finds the absolute path to an installed package's root directory.
  /// This relies on the `.dart_tool/package_config.json` file.
  static Future<String?> findPackagePath(String packageName) async {
    final packageConfigFile = File(p.join(Directory.current.path, '.dart_tool', 'package_config.json'));
    if (!packageConfigFile.existsSync()) {
      return null;
    }

    try {
      final content = await packageConfigFile.readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      final packages = json['packages'] as List<dynamic>;

      for (final pkg in packages) {
        if (pkg is Map<String, dynamic> && pkg['name'] == packageName) {
          final rootUri = pkg['rootUri'] as String?;
          if (rootUri != null) {
            // rootUri can be 'file:///...' or a relative path
            final uri = Uri.parse(rootUri);
            if (uri.scheme == 'file') {
              return p.fromUri(uri);
            } else {
              // Assume it's a relative path from .dart_tool/package_config.json
              return p.normalize(p.join(packageConfigFile.parent.path, rootUri));
            }
          }
        }
      }
    } catch (e) {
      print('Error reading package_config.json: $e');
    }
    return null;
  }
}