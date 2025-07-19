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

/// {@template cli_command}
/// Enum representing the available CLI commands for launching or managing
/// a JetLeaf application.
///
/// These commands are typically passed to the CLI runner at startup and
/// determine how the application is bootstrapped.
///
/// Example:
/// ```dart
/// final command = CliCommand.fromString("dev");
/// print(command); // CliCommand.dev
/// ```
/// {@endtemplate}
enum CliCommand {
  /// Launch the application in development mode.
  ///
  /// Enables features like hot reload, verbose logging, and development profiles.
  dev("dev"),

  /// Launch the application in production mode.
  ///
  /// Optimizes performance, disables dev-only features, and loads production profiles.
  build("build"),

  /// Run code generation or tooling tasks.
  ///
  /// Used to generate metadata, perform pre-analysis, or other internal tasks.
  generate("generate");

  /// The string representation of the CLI command (e.g. `"dev"`).
  final String name;

  /// {@macro cli_command}
  const CliCommand(this.name);

  /// Checks if the provided string matches the given [CliCommand]
  //// 
  /// Returns either true or false
  bool equals(String value) => name == value;

  /// Parses a string and returns the corresponding [CliCommand] enum.
  ///
  /// Throws an [Exception] if the command is invalid.
  ///
  /// Example:
  /// ```dart
  /// final cmd = CliCommand.fromString('build');
  /// ```
  static CliCommand fromString(String name) {
    return switch (name) {
      "dev" => dev,
      "build" => build,
      "generate" => generate,
      _ => throw Exception("Invalid command: $name"),
    };
  }
}