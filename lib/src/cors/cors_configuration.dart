/// {@template cors_configuration}
/// Represents the CORS (Cross-Origin Resource Sharing) configuration for a web endpoint.
///
/// This class defines rules that determine how browsers and servers communicate
/// securely across different origins. It is typically used in HTTP servers to manage
/// cross-origin access to resources.
///
/// - `allowedOrigins`: List of domains allowed to access the server.
/// - `allowedMethods`: List of HTTP methods permitted (e.g., GET, POST).
/// - `allowedHeaders`: List of headers the client is allowed to use in requests.
/// - `allowCredentials`: Whether credentials like cookies and HTTP auth are allowed.
///
/// Example:
/// ```dart
/// CorsConfiguration(
///   allowedOrigins: ['https://example.com'],
///   allowedMethods: ['GET', 'POST'],
///   allowedHeaders: ['Authorization', 'Content-Type'],
///   allowCredentials: true,
///   exposedHeaders: ['Content-Type'],
///   maxAgeSeconds: 86400,
/// );
/// ```
/// {@endtemplate}
class CorsConfiguration {
  /// The list of allowed origin domains (e.g., `https://example.com`).
  final List<String> allowedOrigins;

  /// The list of allowed HTTP methods (e.g., `GET`, `POST`, etc.).
  final List<String> allowedMethods;

  /// The list of allowed HTTP headers.
  final List<String> allowedHeaders;

  /// A list of headers allowed to be exposed to the browser.
  final List<String> exposedHeaders;

  /// Whether to allow credentials (cookies, authorization headers).
  final bool allowCredentials;

  /// The time in seconds the browser should cache the CORS preflight response.
  final int maxAgeSeconds;

  /// Creates a new CORS configuration.
  ///
  /// Defaults:
  /// - `allowedOrigins`: `['*']` (all origins)
  /// - `allowedMethods`: `['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']`
  /// - `allowedHeaders`: `['*']` (all headers)
  /// - `allowCredentials`: `false`
  /// - `exposedHeaders`: `[]` (no headers)
  /// - `maxAgeSeconds`: `86400` (1 day)
  /// 
  /// {@macro cors_configuration}
  const CorsConfiguration({
    this.allowedOrigins = const ['*'],
    this.allowedMethods = const ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    this.allowedHeaders = const ['*'],
    this.exposedHeaders = const [],
    this.allowCredentials = false,
    this.maxAgeSeconds = 86400,
  });
}