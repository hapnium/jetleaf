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

/// {@template cors_library}
/// A Dart CORS configuration module for the JetLeaf framework.
///
/// This library provides flexible configuration and source-based resolution
/// for Cross-Origin Resource Sharing (CORS) policies. It includes:
///
/// - [`CorsConfiguration`]: Defines allowed origins, methods, headers, and credentials.
/// - [`CorsConfigurationSource`]: Interface for dynamically resolving CORS config.
/// - [`PathBasedCorsConfigurationSource`]: Maps request paths to CORS configurations.
///
/// Example usage:
/// ```dart
/// final corsSource = PathBasedCorsConfigurationSource();
/// corsSource.register('/api', CorsConfiguration(
///   allowedOrigins: ['https://example.com'],
///   allowedMethods: ['GET', 'POST'],
///   allowCredentials: true,
/// ));
/// ```
///
/// This modular approach makes it easy to apply different CORS rules across
/// multiple endpoints in a structured and maintainable way.
/// {@endtemplate}
///
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library cors;

export 'src/cors/cors_configuration.dart';
export 'src/cors/cors_configuration_source.dart';
export 'src/cors/path_cors_configuration_source.dart';