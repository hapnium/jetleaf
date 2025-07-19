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

/// {@template property_source}
/// A base abstraction representing a source of key-value properties, such as
/// maps, environment variables, or configuration files.
///
/// Each [PropertySource] has a unique [name] and a backing [source] of type `T`,
/// which holds the actual data. Concrete subclasses implement lookup behavior
/// using [containsProperty] and [getProperty].
///
/// Common implementations include:
/// - [MapPropertySource]
/// - [PropertiesPropertySource]
///
/// This abstraction allows a flexible property resolution system where multiple
/// sources can be layered and resolved by a resolver such as
/// [PropertySourcesPropertyResolver].
///
/// ### Example usage:
///
/// ```dart
/// class MyEnvSource extends PropertySource<Map<String, String>> {
///   MyEnvSource(String name, Map<String, String> source) : super(name, source);
///
///   @override
///   bool containsProperty(String name) => source.containsKey(name);
///
///   @override
///   Object? getProperty(String name) => source[name];
/// }
///
/// final env = MyEnvSource('env', {'APP_ENV': 'prod'});
/// print(env.getProperty('APP_ENV')); // prod
/// ```
/// {@endtemplate}
abstract class PropertySource<T> {
  /// The unique name used to identify this property source.
  final String name;

  /// The underlying source object that holds the actual properties.
  final T source;

  /// {@macro property_source}
  PropertySource(this.name, this.source);

  /// Returns `true` if this source contains a property with the given [name].
  bool containsProperty(String name);

  /// Retrieves the value of the property with the given [name], or `null` if not present.
  Object? getProperty(String name);
}