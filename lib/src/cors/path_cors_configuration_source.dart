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

import 'dart:io';

import 'cors_configuration.dart';
import 'cors_configuration_source.dart';

/// {@template path_based_cors_configuration_source}
/// A [CorsConfigurationSource] implementation that resolves CORS configurations
/// based on path patterns.
///
/// This class allows you to register specific [CorsConfiguration] instances
/// tied to URL path prefixes. When a request is received, the class checks if
/// the request path starts with any of the registered patterns and returns the
/// corresponding configuration.
///
/// This is useful for applying different CORS rules to different parts of an API.
///
/// Example:
/// ```dart
/// final corsSource = PathBasedCorsConfigurationSource();
/// corsSource.register('/api/public', CorsConfiguration(allowedOrigins: ['*']));
/// corsSource.register('/api/secure', CorsConfiguration(
///   allowedOrigins: ['https://myapp.com'],
///   allowCredentials: true,
/// ));
/// ```
/// {@endtemplate}
class PathBasedCorsConfigurationSource implements CorsConfigurationSource {
  final Map<String, CorsConfiguration> _configMap = {};

  /// {@macro path_based_cors_configuration_source}
  PathBasedCorsConfigurationSource();

  /// Registers a [CorsConfiguration] for a specific path prefix.
  ///
  /// When a request URI path starts with [pathPattern], the associated [config]
  /// will be returned by [getCorsConfiguration].
  void register(String pathPattern, CorsConfiguration config) {
    _configMap[pathPattern] = config;
  }

  /// Returns the [CorsConfiguration] that matches the request path prefix,
  /// or `null` if no match is found.
  /// 
  /// {@macro cors_configuration}
  @override
  CorsConfiguration? getCorsConfiguration(HttpRequest request) {
    final path = request.uri.path;
    for (final entry in _configMap.entries) {
      if (path.startsWith(entry.key)) {
        return entry.value;
      }
    }

    return null;
  }
}