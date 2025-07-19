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

/// {@template path_matching_exception}
/// Exception thrown when a URI or route path fails to match a defined template
/// in a path matcher.
///
/// Common scenarios include:
/// - Invalid placeholders
/// - Missing required path segments
/// - Mismatched patterns or formats
///
/// Useful for debugging route resolution and pattern-based matching systems.
/// {@endtemplate}
class PathMatchingException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// {@macro path_matching_exception}
  PathMatchingException(this.message);

  @override
  String toString() => 'PathMatchingException: $message';
}