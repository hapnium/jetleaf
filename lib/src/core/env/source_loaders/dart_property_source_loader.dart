import 'dart:async';
import 'dart:io';

import 'package:jetleaf/env.dart';
import 'package:jetleaf/logging.dart';

import '../dart_loader/configuration_extractor.dart';
import '../exceptions.dart';
import 'property_source_loader.dart';

/// {@template dart_property_source_loader}
/// Loads `MapPropertySource` instances from Dart-based configuration files
/// found in the `resources` directory of the given [baseDirectory].
///
/// This loader works by using [ConfigurationExtractor] to dynamically extract
/// environment configurations defined in Dart files and transform them into
/// structured property sources, each tagged with a specific profile.
///
/// Typical usage includes integrating user-defined Dart classes for environment
/// settings during application startup.
///
/// Example:
/// ```dart
/// final loader = DartPropertySourceLoader('/app', 'application', loggerFactory);
/// final sources = await loader.loadResources();
/// environment.propertySources.addAll(sources);
/// ```
///
/// Directory structure expected:
/// ```
/// /app/resources/
///   ├── dev_config.dart
///   └── prod_config.dart
/// ```
///
/// Each Dart file should define profile-specific settings via the extractor.
///
/// Throws [DartLoadingException] if loading fails.
/// {@endtemplate}
class DartPropertySourceLoader extends PropertySourceLoader {
  /// Prefix used for log messages.
  final String LOG_PREFIX = 'DartPropertySourceLoader';

  /// Extractor responsible for parsing Dart configuration classes.
  final ConfigurationExtractor _extractor;

  /// {@macro dart_property_source_loader}
  DartPropertySourceLoader(super.baseDirectory, super.baseName, super.loggerFactory) 
    : _extractor = ConfigurationExtractor(loggerFactory);

  @override
  FutureOr<List<MapPropertySource>> loadResources() {
    List<MapPropertySource> result = [];
    _load().then((value) => value.forEach((profile, env) => result.add(MapPropertySource(profile, env))));

    return result;
  }

  /// Internal method that scans and extracts environment configurations from Dart resources.
  ///
  /// - Searches the `resources/` subdirectory.
  /// - Invokes [_extractor.extractFromDirectory] to obtain all configurations.
  /// - Groups configurations by profile.
  ///
  /// Returns an immutable map: `Map<profile, properties>`.
  ///
  /// Logs status updates and errors using [loggerFactory].
  Future<Map<String, Map<String, Object>>> _load() async {
    final resourceDir = Directory('$baseDirectory/resources');

    if (!resourceDir.existsSync()) {
      loggerFactory.add(LogLevel.WARN, 'Resources directory not found: ${resourceDir.path}');
      return {};
    }

    final result = <String, Map<String, Object>>{};

    try {
      // Extract all configurations from the directory
      final configurations = await _extractor.extractFromDirectory(resourceDir);

      // Process each configuration and add to cache
      for (final config in configurations) {
        result.addAll({config.profile: config.properties});
        loggerFactory.add(LogLevel.DEBUG, 'Loaded ${config.properties.length} properties for profile: ${config.profile}');
      }

      loggerFactory.add(LogLevel.INFO, 'Successfully loaded ${configurations.length} configurations from ${result.length} profiles');
    } catch (e) {
      loggerFactory.add(LogLevel.ERROR, 'Error loading configurations: $e');
      
      throw DartLoadingException('Failed to load configurations: $e');
    }

    return Map.unmodifiable(result);
  }
}