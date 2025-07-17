import 'package:jetleaf/src/lang/primitives/character.dart';

import '../exceptions.dart';
import '../property_source/mutable_property_sources.dart';
import 'abstract_property_resolver.dart';
import '_property_resolver.dart';

/// {@template property_sources_property_resolver}
/// A concrete implementation of [AbstractPropertyResolver] that retrieves
/// property values from a collection of [PropertySource]s managed by a
/// [MutablePropertySources] container.
///
/// This class supports resolving placeholders in property values and converting
/// properties to specific types using a registered [ConversionService].
///
/// It wraps a [RuntimePropertyResolver] for handling placeholder resolution
/// logic, and exposes configuration options like escape character, value
/// separator, and required properties.
///
/// ### Example usage:
///
/// ```dart
/// final sources = MutablePropertySources();
/// sources.addPropertySource(MapPropertySource('config', {'app.name': 'JetLeaf'}));
///
/// final resolver = PropertySourcesPropertyResolver(sources);
/// print(resolver.getProperty('app.name')); // JetLeaf
/// print(resolver.getPropertyWithDefault('app.port', '8080')); // 8080
/// ```
///
/// Placeholder resolution:
///
/// ```dart
/// sources.addPropertySource(MapPropertySource('env', {
///   'host': 'localhost',
///   'url': 'http://${host}:8080'
/// }));
///
/// print(resolver.resolvePlaceholders('API: ${url}')); // API: http://localhost:8080
/// ```
/// {@endtemplate}
class PropertySourcesPropertyResolver extends AbstractPropertyResolver {
  /// The list of property sources to retrieve properties from.
  final MutablePropertySources propertySources;

  /// Used internally to resolve placeholders in property values.
  late final RuntimePropertyResolver resolver;

  /// {@macro property_sources_property_resolver}
  PropertySourcesPropertyResolver(this.propertySources) {
    resolver = RuntimePropertyResolver(this);
  }

  @override
  bool containsProperty(String key) {
    for (final source in propertySources) {
      if (source.containsProperty(key)) return true;
    }
    return false;
  }

  @override
  String? getProperty(String key) {
    for (final source in propertySources) {
      final value = source.getProperty(key);
      if (value != null) return value.toString();
    }
    return null;
  }

  @override
  String getPropertyWithDefault(String key, String defaultValue) {
    return getProperty(key) ?? defaultValue;
  }

  @override
  T? getPropertyAs<T>(String key) {
    final value = getProperty(key);
    final type = T;

    return value == null ? null : getConversionService().convert<T>(value, type);
  }

  @override
  T getPropertyAsWithDefault<T>(String key, T defaultValue) {
    final value = getPropertyAs<T>(key);
    return value ?? defaultValue;
  }

  @override
  String getRequiredProperty(String key) {
    final value = getProperty(key);
    if (value == null) {
      throw MissingRequiredEnvironmentException('Required property "$key" not found');
    }
    return value;
  }

  @override
  T getRequiredPropertyAs<T>(String key) {
    final value = getRequiredProperty(key);
    final result = getConversionService().convert<T>(value, T);

    if (result == null) {
      throw MissingRequiredEnvironmentException('Required property "$key" not found');
    }

    return result;
  }

  @override
  String resolvePlaceholders(String text) {
    return resolver.interpolate(text);
  }

  @override
  String resolveRequiredPlaceholders(String text) {
    return resolver.interpolate(text);
  }

  @override
  void setEscapeCharacter(Character escapeCharacter) {
    this.escapeCharacter = escapeCharacter.value;
  }

  @override
  void setIgnoreUnresolvableNestedPlaceholders(bool ignoreUnresolvableNestedPlaceholders) {
    this.ignoreUnresolvableNestedPlaceholders = ignoreUnresolvableNestedPlaceholders;
  }

  @override
  void setPlaceholderPrefix(String placeholderPrefix) {
    this.placeholderPrefix = placeholderPrefix;
  }

  @override
  void setPlaceholderSuffix(String placeholderSuffix) {
    this.placeholderSuffix = placeholderSuffix;
  }

  @override
  void setRequiredProperties(List<String> requiredProperties) {
    this.requiredProperties = requiredProperties;
  }

  @override
  void setValueSeparator(String valueSeparator) {
    this.valueSeparator = valueSeparator;
  }
}