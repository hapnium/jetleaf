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

/// {@template dart_loading_exception}
/// Exception thrown when Dart file loading fails
/// 
/// This exception is thrown when an error occurs during the loading
/// of a Dart file, such as a syntax error or a missing required
/// import.
/// 
/// {@endtemplate}
class DartLoadingException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// {@macro dart_loading_exception}
  DartLoadingException(this.message);
}