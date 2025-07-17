import '../converters/converter.dart';
import '../converters/converter_factory.dart';

/// {@template string_to_datetime_converter_factory}
/// A [ConverterFactory] that provides a [Converter] for converting [String]
/// values into [DateTime] instances using `DateTime.parse()`.
///
/// The input string must conform to ISO 8601 or other formats supported
/// by `DateTime.parse()`.
///
/// Example:
/// ```dart
/// final factory = StringToDateTimeConverterFactory();
/// final converter = factory.getConverter<DateTime>()!;
/// final dt = converter.convert("2024-12-01T12:30:00Z");
/// print(dt.toUtc()); // 2024-12-01 12:30:00.000Z
/// ```
/// {@endtemplate}
class StringToDateTimeConverterFactory implements ConverterFactory<String, DateTime> {
  /// {@macro string_to_datetime_converter_factory}
  StringToDateTimeConverterFactory();

  @override
  Converter<String, T>? getConverter<T extends DateTime>() {
    if (T == DateTime) {
      return StringToDateTimeConverter() as Converter<String, T>;
    }
    return null;
  }
}

/// {@template string_to_datetime_converter}
/// A [Converter] that converts a [String] into a [DateTime] using `DateTime.parse()`.
///
/// Supports ISO 8601 and other formats natively parsed by Dart's core libraries.
///
/// Example:
/// ```dart
/// final converter = StringToDateTimeConverter();
/// final dateTime = converter.convert("2025-07-17T15:45:00");
/// print(dateTime); // 2025-07-17 15:45:00.000
/// ```
/// {@endtemplate}
class StringToDateTimeConverter implements Converter<String, DateTime> {
  /// {@macro string_to_datetime_converter}
  StringToDateTimeConverter();

  @override
  DateTime convert(String source) => DateTime.parse(source);
}