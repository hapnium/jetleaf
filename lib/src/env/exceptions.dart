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

/// {@template missing_env_var_exception}
/// Exception thrown when a required environment variable is not found.
///
/// This is typically used in systems where environment variables are
/// mandatory and their absence should fail-fast during startup or runtime.
///
/// You can optionally attach a [cause] for additional context.
///
/// ---
///
/// ### 📦 Example Usage:
/// ```dart
/// final env = Environment.SYSTEM;
/// try {
///   final token = env.get('API_TOKEN');
/// } on MissingRequiredEnvironmentException catch (e) {
///   print('Missing variable: ${e.message}');
/// }
/// ```
///
/// ---
///
/// Used internally by [SystemEnvironment.get] in the JetLeaf framework.
/// {@endtemplate}
class MissingRequiredEnvironmentException implements Exception {
  /// The exception message describing the missing variable.
  final String message;

  /// Optional root cause or underlying reason for the error.
  final Object? cause;

  /// {@macro missing_env_var_exception}
  ///
  /// Creates a new [MissingRequiredEnvironmentException] with the given [message]
  /// and an optional [cause].
  MissingRequiredEnvironmentException(this.message, [this.cause]);
}

/// {@template environment_parsing_exception}
/// An [Exception] thrown when an error occurs during environment property parsing.
///
/// This exception typically indicates that the environment configuration
/// contains invalid or malformed values that cannot be properly interpreted.
///
/// ### Example usage:
///
/// ```dart
/// if (someParsingError) {
///   throw EnvironmentParsingException('Failed to parse environment variable XYZ');
/// }
/// ```
///
/// Catch this exception to handle or report environment parsing failures specifically.
/// {@endtemplate}
class EnvironmentParsingException implements Exception {
  /// A human-readable message describing the parsing error.
  final String message;

  /// {@macro environment_parsing_exception}
  EnvironmentParsingException(this.message);

  @override
  String toString() => 'EnvironmentParsingException: $message';
}