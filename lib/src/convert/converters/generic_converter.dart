/// {@template generic_converter}
/// A generic converter capable of converting between arbitrary source and target types.
///
/// This interface is more flexible than simple typed [Converter]s and is typically
/// used in generic conversion pipelines like [ConversionService].
///
/// ---
///
/// ### 🔧 Example Usage:
/// ```dart
/// class StringToBoolConverter implements GenericConverter {
///   @override
///   bool matches(Type sourceType, Type targetType) {
///     return sourceType == String && targetType == bool;
///   }
///
///   @override
///   Object? convert(Object? source, Type sourceType, Type targetType) {
///     if (source is! String) return null;
///     return source.toLowerCase() == 'true';
///   }
/// }
/// ```
/// {@endtemplate}
abstract class GenericConverter {
  /// {@macro generic_converter}
  ///
  /// Determines whether this converter can convert from [sourceType] to [targetType].
  ///
  /// Returns `true` if the converter supports this conversion; otherwise `false`.
  bool matches(Type sourceType, Type targetType);

  /// {@macro generic_converter}
  ///
  /// Converts the given [source] object of [sourceType] to the desired [targetType].
  ///
  /// Returns the converted object, or `null` if the conversion is not supported
  /// or the input is invalid.
  Object? convert(Object? source, Type sourceType, Type targetType);
}