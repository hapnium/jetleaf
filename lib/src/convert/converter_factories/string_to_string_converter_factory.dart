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

/// {@template string_to_string_converter_factory}
/// A [ConverterFactory] that provides [Converter]s for converting [String]
/// inputs into [String] types.
///
/// Only [String] is supported out of the box.
///
/// Example:
/// ```dart
/// final factory = StringToStringConverterFactory();
///
/// final converter = factory.getConverter<String>()!;
/// final result = converter.convert('hello');
/// print(result); // hello
/// ```
/// {@endtemplate}
class StringToStringConverterFactory implements ConverterFactory<String, String> {
  /// {@macro string_to_string_converter_factory}
  StringToStringConverterFactory();

  @override
  Converter<String, T>? getConverter<T extends String>() {
    if (T == String) {
      return StringIdentityConverter() as Converter<String, T>;
    }
    return null;
  }
}

/// {@template string_identity_converter}
/// A [Converter] that returns the input [String] unchanged.
///
/// This converter is used by the [StringToStringConverterFactory] to provide
/// a default converter for [String] to [String] conversion.
/// {@endtemplate}
class StringIdentityConverter implements Converter<String, String> {
  /// {@macro string_identity_converter}
  StringIdentityConverter();

  @override
  String convert(String source) => source;
}