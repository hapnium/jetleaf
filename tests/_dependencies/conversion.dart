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

import 'package:jetleaf/convert.dart';
import 'package:jetleaf/src/convert/conversion/_configurable_conversion_service.dart';
import 'package:jetleaf/src/convert/converter_factories/string_to_bool_converter_factory.dart';
import 'package:jetleaf/src/convert/converter_factories/string_to_datetime_converter_factory.dart';
import 'package:jetleaf/src/convert/converter_factories/string_to_num_converter_factory.dart';
import 'package:jetleaf/src/convert/converter_factories/string_to_string_converter_factory.dart';

ConfigurableConversionService getConversionService() {
  final conversionService = ConfigurableConversionServiceImpl();
  conversionService.addConverterFactory(StringToNumConverterFactory());
  conversionService.addConverterFactory(StringToStringConverterFactory());
  conversionService.addConverterFactory(StringToBoolConverterFactory());
  conversionService.addConverterFactory(StringToDateTimeConverterFactory());

  return conversionService;
}