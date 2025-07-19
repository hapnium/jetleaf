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

/// {@template jetleaf_constants}
/// Defines global constant values used across the JetLeaf framework.
///
/// These constants represent well-known paths and identifiers used
/// in various CLI, build, and runtime operations.
///
/// Example usage:
/// ```dart
/// final bootstrapFile = File(Constants.DEFAULT_BOOTSTRAP_TARGET);
/// ```
/// {@endtemplate}
class Constants {
  /// {@macro jetleaf_constants}
  const Constants._(); // Prevent instantiation

  /// Name of the default resources directory (non-package-specific).
  static const String RESOURCES_DIR_NAME = 'resources';

  /// The name of the JetLeaf package.
  static const String PACKAGE_NAME = 'jetleaf';

  /// Path to the JetLeaf asset directory inside `lib/`.
  ///
  /// This is where static or generated assets are located during development.
  static const String PACKAGE_ASSET_DIR = 'lib/assets';

  /// Path where JetLeaf resources are placed when building.
  ///
  /// This is used in production builds and asset bundling.
  static const String PACKAGE_ASSET_DIR_FOR_BUILD = 'resources/jetleaf';

  /// Default directory where compiled or temporary files are placed.
  static const String TARGET_DIR = 'target';

  /// Default file path used for bootstrapping the application.
  ///
  /// JetLeaf may generate or expect a `bootstrap.dart` file here to run the app.
  static const String DEFAULT_BOOTSTRAP_TARGET = 'target/bootstrap.dart';

  /// Default location of the compiled kernel `.dill` file for launching the app.
  static const String DEFAULT_BUILD_TARGET = 'build/main.dill';
}