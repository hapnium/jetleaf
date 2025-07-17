import '../converters/converter.dart';
import '../converters/converter_factory.dart';

/// {@template string_to_map_converter_factory}
/// A [ConverterFactory] that provides [Converter]s to convert comma-separated
/// key-value [String] inputs into a [Map].
///
/// Currently, only [Map<String, String>] is supported.
///
/// Input format must be a comma-separated list of `key:value` pairs.
///
/// Example:
/// ```dart
/// final factory = StringToMapConverterFactory();
///
/// final converter = factory.getConverter<Map<String, String>>()!;
/// final map = converter.convert('foo:bar, baz:qux');
/// print(map); // {foo: bar, baz: qux}
/// ```
///
/// Whitespace around keys and values is trimmed.
/// Pairs without a colon (`:`) are ignored silently.
/// {@endtemplate}
class StringToMapConverterFactory implements ConverterFactory<String, Map> {
  /// {@macro string_to_map_converter_factory}
  StringToMapConverterFactory();

  @override
  Converter<String, T>? getConverter<T extends Map>() {
    if (T == Map<String, String>) {
      return (StringToStringMapConverter() as Converter<String, T>);
    }
    return null;
  }
}

/// {@template string_to_string_map_converter}
/// A [Converter] that transforms a comma-separated [String] of key-value pairs
/// into a [Map<String, String>].
///
/// The input string must follow this format:
/// ```
//// key1:value1, key2:value2, ...
/// ```
///
/// Whitespace is trimmed from both keys and values.
/// Entries without a colon separator are skipped.
///
/// Example:
/// ```dart
/// final converter = StringToStringMapConverter();
/// final map = converter.convert('a:1, b:2, c: 3');
/// print(map); // {a: 1, b: 2, c: 3}
/// ```
/// {@endtemplate}
class StringToStringMapConverter implements Converter<String, Map<String, String>> {
  /// {@macro string_to_string_map_converter}
  StringToStringMapConverter();

  @override
  Map<String, String> convert(String source) {
    final entries = source.split(',').map((e) => e.split(':'));
    return {
      for (var pair in entries)
        if (pair.length == 2) pair[0].trim(): pair[1].trim()
    };
  }
}