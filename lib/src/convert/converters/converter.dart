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