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

import '../converters/converter.dart';
import '../converters/converter_factory.dart';

/// {@template string_to_bool_converter_factory}
/// A [ConverterFactory] that converts [String] values to [bool].
///
/// Converts the following strings to `true`:
/// - `'true'` (case-insensitive)
/// - `'1'`
///
/// All other values resolve to `false`.
///
/// Used internally by the JetLeaf conversion system.
///
/// Example:
/// ```dart
/// final factory = StringToBoolConverterFactory();
/// final converter = factory.getConverter<bool>()!;
/// print(converter.convert("true")); // true
/// print(converter.convert("FALSE")); // false
/// print(converter.convert("1")); // true
/// ```
/// {@endtemplate}
class StringToBoolConverterFactory implements ConverterFactory<String, bool> {
  /// {@macro string_to_bool_converter_factory}
  StringToBoolConverterFactory();

  @override
  Converter<String, T>? getConverter<T extends bool>() {
    if (T == bool) {
      return StringToBoolConverter() as Converter<String, T>;
    }
    return null;
  }
}

/// {@template string_to_bool_converter}
/// Converts a [String] to a [bool] using simple rules:
/// - `'true'` (case-insensitive) or `'1'` → `true`
/// - All other values → `false`
///
/// Example:
/// ```dart
/// final converter = StringToBoolConverter();
/// print(converter.convert("true"));  // true
/// print(converter.convert("0"));     // false
/// ```
/// {@endtemplate}
class StringToBoolConverter implements Converter<String, bool> {
  /// {@macro string_to_bool_converter}
  StringToBoolConverter();

  @override
  bool convert(String source) => source.toLowerCase() == 'true' || source == '1';
}