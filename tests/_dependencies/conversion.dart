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