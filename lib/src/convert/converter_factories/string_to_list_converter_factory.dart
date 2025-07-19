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

/// {@template string_to_list_converter_factory}
/// A [ConverterFactory] that provides [Converter]s for converting comma-separated
/// [String] inputs into [List] types such as [List<String>] or [List<int>].
///
/// This factory supports simple list parsing by splitting the string on commas (`,`),
/// trimming whitespace, and converting each item to the target list type element.
///
/// Example:
/// ```dart
/// final factory = StringToListConverterFactory();
///
/// final stringListConverter = factory.getConverter<List<String>>()!;
/// print(stringListConverter.convert('a, b, c')); // [a, b, c]
///
/// final intListConverter = factory.getConverter<List<int>>()!;
/// print(intListConverter.convert('1, 2, 3')); // [1, 2, 3]
/// ```
///
/// Only [List<String>] and [List<int>] are supported out of the box.
/// {@endtemplate}
class StringToListConverterFactory implements ConverterFactory<String, List> {
  /// {@macro string_to_list_converter_factory}
  StringToListConverterFactory();

  @override
  Converter<String, T>? getConverter<T extends List>() {
    if (T == List<String>) {
      return (StringToStringListConverter() as Converter<String, T>);
    } else if (T == List<int>) {
      return (StringToIntListConverter() as Converter<String, T>);
    }
    return null;
  }
}

/// {@template string_to_list_converter}
/// A [Converter] that parses a comma-separated [String] into a [List].
///
/// This base converter handles comma splitting and whitespace trimming.
/// Concrete implementations are provided for [List<String>] and [List<int>].
///
/// Example:
/// ```dart
/// final stringList = StringToStringListConverter().convert('x, y, z');
/// print(stringList); // [x, y, z]
///
/// final intList = StringToIntListConverter().convert('1, 2, 3');
/// print(intList); // [1, 2, 3]
/// ```
///
/// Throws a [ConversionException] if any value in the list cannot be parsed to `int`.
/// {@endtemplate}
class StringToStringListConverter implements Converter<String, List<String>> {
  /// {@macro string_to_list_converter}
  StringToStringListConverter();

  @override
  List<String> convert(String source) => source.split(',').map((e) => e.trim()).toList();
}

class StringToIntListConverter implements Converter<String, List<int>> {
  /// {@macro string_to_list_converter}
  StringToIntListConverter();

  @override
  List<int> convert(String source) => source.split(',').map((e) => int.parse(e.trim())).toList();
}