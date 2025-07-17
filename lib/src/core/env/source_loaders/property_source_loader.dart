import 'dart:async';

import 'package:jetleaf/env.dart';

import '../../logging/logger_factory.dart';

/// {@template property_source_loader}
/// Strategy interface for loading `PropertySource` instances from external configuration resources.
///
/// Implementations of this interface handle locating and parsing files from a base directory,
/// producing a list of [MapPropertySource]s that can be registered in the environment.
///
/// The [baseDirectory] defines the root path where the configuration files should be read from.
///
/// Example:
/// ```dart
/// final loader = JsonFilePropertySourceLoader('/config', 'application', loggerFactory);
/// final sources = loader.loadResources();
/// for (var source in sources) {
///   environment.propertySources.addLast(source);
/// }
/// ```
///
/// This abstraction allows loading properties from formats like `.json`, `.yaml`, `.properties`, etc.
/// {@endtemplate}
abstract class PropertySourceLoader {
  /// The root directory where configuration files are located.
  final String baseDirectory;

  /// The base name of the YAML file to load (e.g., `pubspec`, `application`)
  final String baseName;

  /// {@macro logger_factory}
  final LoggerFactory loggerFactory;

  /// {@macro property_source_loader}
  PropertySourceLoader(this.baseDirectory, this.baseName, this.loggerFactory);

  /// Loads a list of [MapPropertySource]s from the base directory.
  ///
  /// Each implementation should locate one or more files and return a list of parsed sources,
  /// each containing key-value pairs for property resolution.
  ///
  /// Throws [EnvironmentParsingException] if parsing fails.
  FutureOr<List<MapPropertySource>> loadResources();
}