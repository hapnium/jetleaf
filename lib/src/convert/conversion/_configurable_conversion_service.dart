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

import 'configurable_conversion_service.dart';
import '../converters/converter.dart';
import '../converters/converter_factory.dart';
import '../exceptions.dart';
import '../converters/generic_converter.dart';

/// {@template configurable_conversion_service_implementation}
/// A default implementation of [ConfigurableConversionService].
///
/// This class uses three different strategies to find a converter for a given
/// source and target type.
///
/// 1. Direct converters: If a converter of type [Converter<S, T>] is added
///    to this service, then it will be used to convert from [S] to [T].
///
/// 2. Generic converters: If a generic converter of type [GenericConverter]
///    is added to this service, then it will be used to convert from any source
///    type to any target type, as long as the generic converter's [matches]
///    method returns true.
///
/// 3. Converter factories: If a converter factory of type
///    [ConverterFactory<S, R>] is added to this service, then it will be asked
///    to create a converter of type [Converter<S, T>] for each target type [T].
///
/// ---
///
/// ### 🔧 Example Usage:
/// ```dart
/// final service = ConfigurableConversionServiceImpl();
///
/// service.addConverter<String, int>(StringToIntConverter());
/// service.addConverterFactory<String, Enum>(StringToEnumConverterFactory());
/// service.addGenericConverter(MyCustomGenericConverter());
/// ```
/// {@endtemplate}
class ConfigurableConversionServiceImpl implements ConfigurableConversionService {
  final Map<Type, Map<Type, Converter<Object?, Object?>>> _converters = {};
  final List<GenericConverter> _genericConverters = [];
  final List<ConverterFactory<Object?, Object?>> _factories = [];

  /// {@macro configurable_conversion_service_implementation}
  ConfigurableConversionServiceImpl();

  @override
  void addConverter<S, T>(Converter<S, T> converter) {
    _converters.putIfAbsent(S, () => {})[T] = (converter as Converter<Object?, Object?>);
  }

  @override
  void addConverterFactory<S, R>(ConverterFactory<S, R> factory) {
    _factories.add(factory);
  }

  @override
  void addGenericConverter(GenericConverter converter) {
    _genericConverters.add(converter);
  }

  @override
  bool canConvert(Type sourceType, Type targetType) {
    return _converters[sourceType]?.containsKey(targetType) == true ||
        _genericConverters.any((c) => c.matches(sourceType, targetType));
  }

  @override
  T? convert<T>(Object? source, Type targetType) {
    try {
      if (source == null) return null;
      final sourceType = source.runtimeType;

      final direct = _converters[sourceType]?[targetType];
      if (direct != null) {
        return direct.convert(source) as T;
      }

      for (final generic in _genericConverters) {
        if (generic.matches(sourceType, targetType)) {
          return generic.convert(source, sourceType, targetType) as T;
        }
      }

      for (final factory in _factories) {
        final converter = factory.getConverter<T>();
        if (converter != null) {
          return converter.convert(source);
        }
      }
    } on TypeError catch (e) {
      throw ConversionException(e.toString());
    }

    throw ConversionException('No converter found for $source → $targetType');
  }
}