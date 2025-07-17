/// {@template conversion_exception}
/// Exception thrown when a type conversion fails in a [ConversionService].
///
/// This typically occurs when attempting to convert an object from one type to another
/// and no suitable [Converter] or [GenericConverter] exists, or the conversion logic
/// throws an error due to invalid data or incompatible types.
///
/// ---
///
/// ### ❗ Example:
/// ```dart
/// try {
///   final value = conversionService.convert<String>(42, String);
/// } catch (e) {
///   if (e is ConversionException) {
///     print('Conversion failed: ${e.message}');
///   }
/// }
/// ```
///
/// Use this to catch and handle specific conversion failures during property binding,
/// message deserialization, or data mapping.
/// {@endtemplate}
final class ConversionException implements Exception {
  /// The message describing the conversion failure.
  final String message;

  /// {@macro conversion_exception}
  ConversionException(this.message);

  @override
  String toString() => 'ConversionException: $message';
}