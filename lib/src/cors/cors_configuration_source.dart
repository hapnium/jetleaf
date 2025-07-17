import 'dart:io';

import 'cors_configuration.dart';

/// {@template cors_configuration_source}
/// A strategy interface for providing CORS (Cross-Origin Resource Sharing)
/// configurations based on the incoming [HttpRequest].
///
/// Implementations of this interface determine the appropriate [CorsConfiguration]
/// to apply for a given request—typically based on request path, headers, or other metadata.
///
/// This is useful for dynamic or per-endpoint CORS policies.
///
/// Example:
/// ```dart
/// class MyCorsSource implements CorsConfigurationSource {
///   @override
///   CorsConfiguration? getCorsConfiguration(HttpRequest request) {
///     if (request.uri.path.startsWith('/api/')) {
///       return CorsConfiguration(
///         allowedOrigins: ['https://example.com'],
///         allowCredentials: true,
///       );
///     }
///     return null;
///   }
/// }
/// ```
/// {@endtemplate}
abstract interface class CorsConfigurationSource {
  /// Returns the [CorsConfiguration] for the given [HttpRequest], or `null`
  /// if CORS should not be applied.
  /// 
  /// {@macro cors_configuration_source}
  CorsConfiguration? getCorsConfiguration(HttpRequest request);
}