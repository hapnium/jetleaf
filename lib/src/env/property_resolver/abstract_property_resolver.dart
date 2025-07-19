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

import '../exceptions.dart';
import 'configurable_property_resolver.dart';

/// {@template abstract_property_resolver}
/// An abstract base implementation of [ConfigurablePropertyResolver] that provides
/// common functionality for resolving property placeholders, type conversion,
/// and required property validation.
/// 
/// This class handles basic configuration like placeholder syntax, escape
/// characters, and integration with a [ConfigurableConversionService].
///
/// Subclasses are expected to provide concrete implementations of
/// [getProperty], [containsProperty], and related methods.
/// {@endtemplate}
abstract class AbstractPropertyResolver implements ConfigurablePropertyResolver {
  /// The conversion service used for converting property values to target types.
  late ConfigurableConversionService _conversionService;

  /// The prefix used to denote the beginning of a placeholder.
  ///
  /// Default is `#{`.
  String placeholderPrefix = '#{';

  /// The suffix used to denote the end of a placeholder.
  ///
  /// Default is `}`.
  String placeholderSuffix = '}';

  /// Optional separator between property key and default value in a placeholder.
  ///
  /// For example: `#{my.prop:default}`. Default is `:`. Can be `null`.
  String? valueSeparator = ':';

  /// Optional character used to escape placeholder syntax. Default is `null`.
  String? escapeCharacter = null;

  /// If `true`, unresolvable nested placeholders will be ignored
  /// instead of throwing an exception. Default is `false`.
  bool ignoreUnresolvableNestedPlaceholders = false;

  /// List of required property keys that must be present in the environment.
  ///
  /// If any are missing, [validateRequiredProperties] will throw.
  List<String> requiredProperties = [];

  /// {@macro abstract_property_resolver}
  @override
  ConfigurableConversionService getConversionService() => _conversionService;

  @override
  void setConversionService(ConfigurableConversionService service) {
    _conversionService = service;
  }

  @override
  void validateRequiredProperties() {
    for (final key in requiredProperties) {
      if (!containsProperty(key)) {
        throw MissingRequiredEnvironmentException("Missing required property: $key");
      }
    }
  }
}