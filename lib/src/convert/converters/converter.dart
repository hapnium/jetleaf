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

/// {@template converter}
/// A generic interface for converting objects from type [S] (source) to [T] (target).
///
/// This interface is typically used in type conversion pipelines and property
/// resolution, where values must be adapted from one type to another.
///
/// ---
///
/// ### 🔧 Example Usage:
/// ```dart
/// class StringToIntConverter implements Converter<String, int> {
///   @override
///   int convert(String source) => int.parse(source);
/// }
///
/// final converter = StringToIntConverter();
/// final result = converter.convert('123'); // result == 123
/// ```
///
/// {@endtemplate}
abstract class Converter<S, T> {
  /// {@macro converter}
  ///
  /// Converts the given [source] of type [S] to type [T].
  ///
  /// Returns the converted value, or throws an exception if conversion fails.
  T convert(S source);
}