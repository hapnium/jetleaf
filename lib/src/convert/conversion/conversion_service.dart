/// {@template conversion_service}
/// A strategy interface for type conversion.
///
/// Implementations of this interface are responsible for converting values between
/// different types, such as from `String` to `int`, `List<String>` to `Set<int>`, or
/// custom object mappings.
///
/// Typically used in configuration binding, message deserialization, and
/// property resolution pipelines.
///
/// ---
///
/// ### 🔧 Example Usage:
/// ```dart
/// final service = DefaultConversionService();
///
/// if (service.canConvert(String, int)) {
///   final value = service.convert<int>('42', int);
///   print(value + 1); // 43
/// }
/// ```
/// {@endtemplate}
abstract class ConversionService {
  /// {@template conversion_service_can_convert}
  /// Determines whether objects of [sourceType] can be converted to [targetType].
  ///
  /// This allows frameworks to optimize or validate before performing conversions.
  ///
  /// ### Example:
  /// ```dart
  /// if (conversionService.canConvert(String, DateTime)) {
  ///   final date = conversionService.convert<DateTime>('2025-01-01', DateTime);
  /// }
  /// ```
  /// {@endtemplate}
  bool canConvert(Type sourceType, Type targetType);

  /// {@template conversion_service_convert}
  /// Converts the given [source] object to the specified [targetType].
  ///
  /// Returns `null` if the conversion fails or if [source] is `null`.
  ///
  /// ### Example:
  /// ```dart
  /// final port = conversionService.convert<int>('8080', int);
  /// final date = conversionService.convert<DateTime>('2025-01-01', DateTime);
  /// ```
  ///
  /// The [T] type parameter represents the expected return type.
  /// {@endtemplate}
  T? convert<T>(Object? source, Type targetType);
}