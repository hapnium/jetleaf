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

import 'package:jetleaf/reflection.dart';

import '../converters/converter.dart';
import '../converters/converter_factory.dart';
import '../exceptions.dart';

/// {@template string_to_enum_converter_factory}
/// A [ConverterFactory] that provides a [Converter] to transform [String] values
/// into enum constants of a given [Enum] type.
///
/// This converter matches input strings to enum values by their `name`
/// (not `toString()` or `index`), and is case-sensitive.
///
/// Requires support from `jetleaf/reflection.dart` to introspect enum types.
///
/// Example:
/// ```dart
/// enum Color { red, green, blue }
///
/// final factory = StringToEnumConverterFactory();
/// final converter = factory.getConverter<Color>()!;
/// final color = converter.convert("green");
/// print(color); // Color.green
/// ```
///
/// Throws a [ConversionException] if the string does not match any enum name.
/// {@endtemplate}
class StringToEnumConverterFactory implements ConverterFactory<String, Enum> {
  /// {@macro string_to_enum_converter_factory}
  StringToEnumConverterFactory();

  final Map<Type, List<Enum>> _enumCache = {};

  @override
  Converter<String, T>? getConverter<T extends Enum>() {
    final enumValues = _getEnumValues<T>();
    if (enumValues == null) return null;

    return _StringToEnumConverter<T>(enumValues);
  }

  List<T>? _getEnumValues<T extends Enum>() {
    if (_enumCache.containsKey(T)) {
      return _enumCache[T]! as List<T>;
    }

    try {
      final clazz = Class<T>();
      if (clazz.isEnum) {
        return clazz.getEnumValues<T>();
      }
    } catch (_) {}
    return null;
  }
}

/// {@template string_to_enum_converter}
/// A [Converter] that converts a [String] to an [Enum] constant by matching the
/// input to the `name` of the enum.
///
/// This match is **case-sensitive** and only works for enums that are properly
/// reflected by the JetLeaf reflection system.
///
/// Example:
/// ```dart
/// enum Status { active, paused, closed }
///
/// final converter = _StringToEnumConverter(Status.values);
/// final result = converter.convert("paused");
/// print(result); // Status.paused
/// ```
///
/// Throws a [ConversionException] if no matching enum value is found.
/// {@endtemplate}
class _StringToEnumConverter<T extends Enum> implements Converter<String, T> {
  final List<T> values;

  /// {@macro string_to_enum_converter}
  _StringToEnumConverter(this.values);

  @override
  T convert(String source) {
    return values.firstWhere(
      (e) => e.name == source,
      orElse: () => throw ConversionException('No enum value for "$source" in $T'),
    );
  }
}