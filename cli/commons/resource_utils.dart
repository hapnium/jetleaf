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
import 'package:path/path.dart' as p;

/// Utility class for resolving paths to application resources.
///
/// Resources are typically located in a `resources` directory relative
/// to the application's entry point. In a compiled (prod) environment,
/// these are usually copied to the `build/resources` directory.
/// In a development environment, they might be accessed directly from
/// the project's `resources` or `target/resources` folder.
class ResourceUtils {
  // A configurable base directory for resources. Can be set by user prompt.
  static String? _customResourceBaseDir;

  /// Sets a custom base directory for resource resolution.
  /// This can be used to override the default detection logic.
  static void setCustomResourceBaseDir(String path) {
    _customResourceBaseDir = path;
  }

  /// Resolves the absolute path to a resource within the application's
  /// resources directory.
  ///
  /// [relativePath]: The path to the resource relative to the `resources` folder.
  ///
  /// Returns the absolute path to the resource.
  /// Throws [Exception] if the resource path cannot be resolved.
  static String resolveResourcePath(String relativePath) {
    String baseDir;

    if (_customResourceBaseDir != null) {
      baseDir = _customResourceBaseDir!;
    } else {
      final scriptUri = Platform.script;
      String? detectedBaseDir;

      if (scriptUri.scheme == 'file') {
        final scriptPath = p.fromUri(scriptUri);
        final scriptDir = p.dirname(scriptPath);

        // Check for 'build/resources' (common for compiled apps)
        final buildResourcesPath = p.join(scriptDir, 'resources');
        if (Directory(buildResourcesPath).existsSync()) {
          detectedBaseDir = buildResourcesPath;
        }
        // Check for 'target/resources' (common for generated bootstrap in dev)
        else if (Directory(p.join(scriptDir, 'target', 'resources')).existsSync()) {
          detectedBaseDir = p.join(scriptDir, 'target', 'resources');
        }
        // Check for 'resources' in the current working directory (common for dev)
        else if (Directory(p.join(Directory.current.path, 'resources')).existsSync()) {
          detectedBaseDir = p.join(Directory.current.path, 'resources');
        }
      } else if (scriptUri.scheme == 'package') {
        // If running from `dart run`, Platform.script might be a package: URI.
        // In this scenario, the resources would typically be copied to `target/resources`
        // or `build/resources` by the CLI.
        final currentDir = Directory.current.path;
        final targetResourcesPath = p.join(currentDir, 'target', 'resources');
        final buildResourcesPath = p.join(currentDir, 'build', 'resources');

        if (Directory(targetResourcesPath).existsSync()) {
          detectedBaseDir = targetResourcesPath;
        } else if (Directory(buildResourcesPath).existsSync()) {
          detectedBaseDir = buildResourcesPath;
        }
      }

      if (detectedBaseDir != null) {
        baseDir = detectedBaseDir;
      } else {
        baseDir = Directory.current.path;
      }
    }

    final fullPath = p.join(baseDir, relativePath);
    if (!File(fullPath).existsSync()) {
      throw Exception('Resource not found: $fullPath (resolved from $relativePath). Please ensure the resource exists or the resource base directory is correctly configured.');
    }
    return fullPath;
  }

  /// Reads the content of a text resource.
  static Future<String> readTextResource(String relativePath) async {
    final path = resolveResourcePath(relativePath);
    return await File(path).readAsString();
  }

  /// Reads the content of a binary resource (e.g., image, video).
  static Future<List<int>> readBinaryResource(String relativePath) async {
    final path = resolveResourcePath(relativePath);
    return await File(path).readAsBytes();
  }
}