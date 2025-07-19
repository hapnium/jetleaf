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

import 'package:jetleaf/src/convert/conversion/_configurable_conversion_service.dart';
import 'package:test/test.dart';
import 'package:jetleaf/convert.dart';

import '../_dependencies/conversion.dart';

void main() {
  group('ConfigurableConversionServiceImpl', () {
    late ConfigurableConversionService service;

    setUp(() {
      service = getConversionService();
    });

    test('can add and use a simple Converter', () {
      service.addConverter<String, int>(_StringToIntConverter());

      expect(service.canConvert(String, int), isTrue);
      final result = service.convert<int>('123', int);
      expect(result, 123);
    });

    test('can handle missing converter gracefully', () {
      service = ConfigurableConversionServiceImpl();
      expect(() => service.convert<int>('123', int), throwsA(isA<ConversionException>()));
      expect(service.canConvert(String, int), isFalse);
    });

    test('convert returns null if source is null', () {
      service.addConverter<String, int>(_StringToIntConverter());
      final result = service.convert<int>(null, int);
      expect(result, isNull);
    });

    test('can add and use ConverterFactory', () {
      service.addConverterFactory<String, num>(_StringToNumberConverterFactory());

      expect(service.canConvert(String, int), isFalse); // Factory alone does not mark canConvert true (current impl)
      // But convert should work via factory:
      final intResult = service.convert<int>('42', int);
      final doubleResult = service.convert<double>('3.14', double);
      expect(intResult, 42);
      expect(doubleResult, 3.14);
    });

    test('converter factory throws ConversionException on unsupported target', () {
      service = ConfigurableConversionServiceImpl();
      service.addConverterFactory<String, num>(_StringToNumberConverterFactory());
      expect(() => service.convert<bool>('true', bool), throwsA(isA<ConversionException>()));
    });

    test('can add and use GenericConverter', () {
      service.addGenericConverter(_StringToBoolGenericConverter());

      expect(service.canConvert(String, bool), isTrue);

      final trueVal = service.convert<bool>('true', bool);
      final falseVal = service.convert<bool>('false', bool);
      final nullVal = service.convert<bool>('notabool', bool);

      expect(trueVal, isTrue);
      expect(falseVal, isFalse);
      expect(nullVal, isFalse); // Our implementation returns false for non "true"
    });

    test('conversion prefers direct converter over generic and factory', () {
      service.addGenericConverter(_StringToBoolGenericConverter());
      service.addConverterFactory<String, bool>(_StringToBoolFactory());
      service.addConverter<String, bool>(_AlwaysTrueConverter());

      expect(service.canConvert(String, bool), isTrue);
      final result = service.convert<bool>('false', bool);
      // direct converter returns true always
      expect(result, isTrue);
    });
  });
}

// Simple Converter from String to int
class _StringToIntConverter implements Converter<String, int> {
  @override
  int convert(String source) => int.parse(source);
}

// ConverterFactory from String to num (int or double)
class _StringToNumberConverterFactory implements ConverterFactory<String, num> {
  @override
  Converter<String, T>? getConverter<T extends num>() {
    if (T == int) return _StringToIntConverter() as Converter<String, T>;
    if (T == double) return _StringToDoubleConverter() as Converter<String, T>;
    throw ConversionException('No converter for $T');
  }
}

class _StringToDoubleConverter implements Converter<String, double> {
  @override
  double convert(String source) => double.parse(source);
}

// GenericConverter from String to bool
class _StringToBoolGenericConverter implements GenericConverter {
  @override
  bool matches(Type sourceType, Type targetType) => sourceType == String && targetType == bool;

  @override
  Object? convert(Object? source, Type sourceType, Type targetType) {
    if (source is! String) return null;
    return source.toLowerCase() == 'true';
  }
}

// ConverterFactory from String to bool that always throws
class _StringToBoolFactory implements ConverterFactory<String, bool> {
  @override
  Converter<String, T>? getConverter<T extends bool>() {
    return _StringToBoolConverter() as Converter<String, T>;
  }
}

class _StringToBoolConverter implements Converter<String, bool> {
  @override
  bool convert(String source) => source == 'true';
}

// Direct Converter from String to bool that always returns true (to test preference)
class _AlwaysTrueConverter implements Converter<String, bool> {
  @override
  bool convert(String source) => true;
}