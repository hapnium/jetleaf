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

import 'conversion_service.dart';
import '../converters/converter.dart';
import '../converters/converter_factory.dart';
import '../converters/generic_converter.dart';

/// {@template configurable_conversion_service}
/// A configurable conversion service that allows dynamic registration of converters.
///
/// This interface is typically used during application bootstrap or module initialization
/// to register additional [Converter], [ConverterFactory], or [GenericConverter] instances
/// that will be used for type conversion across the framework.
///
/// ---
///
/// ### 🔧 Example Usage:
/// ```dart
/// final service = DefaultConversionService();
///
/// service.addConverter<String, int>(StringToIntConverter());
/// service.addConverterFactory<String, Enum>(StringToEnumConverterFactory());
/// service.addGenericConverter(MyCustomGenericConverter());
/// ```
///
/// See also:
/// - [ConversionService]
/// - [Converter]
/// - [ConverterFactory]
/// - [GenericConverter]
/// {@endtemplate}
abstract class ConfigurableConversionService extends ConversionService {
  /// {@macro configurable_conversion_service}
  ///
  /// Registers a simple type-to-type [Converter].
  ///
  /// Example:
  /// ```dart
  /// conversionService.addConverter<String, bool>(StringToBoolConverter());
  /// ```
  void addConverter<S, T>(Converter<S, T> converter);

  /// {@macro configurable_conversion_service}
  ///
  /// Registers a factory that can create converters from a single source type [S]
  /// to multiple target types extending [R].
  ///
  /// Example:
  /// ```dart
  /// conversionService.addConverterFactory<String, Enum>(StringToEnumFactory());
  /// ```
  void addConverterFactory<S, R>(ConverterFactory<S, R> factory);

  /// {@macro configurable_conversion_service}
  ///
  /// Registers a [GenericConverter] that can handle conversions between
  /// arbitrary types based on runtime conditions.
  ///
  /// Example:
  /// ```dart
  /// conversionService.addGenericConverter(MyFlexibleConverter());
  /// ```
  void addGenericConverter(GenericConverter converter);
}