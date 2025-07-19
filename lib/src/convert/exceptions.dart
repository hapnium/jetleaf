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