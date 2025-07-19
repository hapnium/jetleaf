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

import '../converters/converter.dart';
import '../converters/converter_factory.dart';

class StringToNumConverterFactory implements ConverterFactory<String, num> {
  @override
  Converter<String, T>? getConverter<T extends num>() {
    if (T == int) {
      return (StringToIntConverter() as Converter<String, T>);
    } else if (T == double) {
      return (StringToDoubleConverter() as Converter<String, T>);
    }
    return null;
  }
}

class StringToIntConverter implements Converter<String, int> {
  @override
  int convert(String source) => int.parse(source);
}

class StringToDoubleConverter implements Converter<String, double> {
  @override
  double convert(String source) => double.parse(source);
}