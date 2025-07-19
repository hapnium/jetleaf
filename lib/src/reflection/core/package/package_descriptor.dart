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

/// {@template package_descriptor}
/// Abstract base class for representing package metadata at runtime.
///
/// This class provides access to basic information about a Dart package,
/// such as its name and version. Concrete implementations are generated
/// by the CLI and can be loaded dynamically using `dart:mirrors`.
///
/// Used primarily for diagnostics, logging, version reporting, and
/// dependency introspection at runtime.
///
/// Example usage:
/// ```dart
/// PackageDescriptor descriptor = PackageScanner.load();
/// print('Package: ${descriptor.name}, version: ${descriptor.version}');
/// ```
/// {@endtemplate}
abstract class PackageDescriptor {
  /// {@macro package_descriptor}
  const PackageDescriptor();

  /// The name of the package (e.g., 'jetleaf').
  String get name;

  /// The semantic version of the package (e.g., '1.0.0').
  String get version;

  /// The Dart language version this package uses, if defined.
  String? get languageVersion;

  /// Whether the package is the user's application.
  /// 
  /// This is used to determine which package is the project created by the user.
  bool get isRootPackage;
}