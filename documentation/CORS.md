# JetLeaf CORS Configuration

This package provides a flexible Cross-Origin Resource Sharing (CORS) configuration system for JetLeaf servers, inspired by Spring's CORS support. It allows you to define fine-grained CORS policies using a path-based strategy.

---

## 📦 Package

`package:jetleaf/cors.dart`

---

## ✨ Features

- Per-request CORS resolution via a strategy interface
- Path-based configuration using prefix matching
- Wildcard (`*`) support for headers, methods, and origins
- Supports credentials, exposed headers, and max-age
- Easy to plug into custom HTTP request pipelines

---

## 🧱 Core Components

### `CorsConfiguration`

Defines CORS policy parameters:

```dart
CorsConfiguration(
  allowedOrigins: ['https://example.com'],
  allowedMethods: ['GET', 'POST'],
  allowedHeaders: ['Authorization', 'Content-Type'],
  exposedHeaders: ['X-Custom-Header'],
  allowCredentials: true,
  maxAgeSeconds: 3600,
);
````

#### Fields:

| Field              | Description                        | Default                                       |
| ------------------ | ---------------------------------- | --------------------------------------------- |
| `allowedOrigins`   | List of allowed origin domains     | `['*']`                                       |
| `allowedMethods`   | Allowed HTTP methods               | `['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']` |
| `allowedHeaders`   | Allowed headers from client        | `['*']`                                       |
| `exposedHeaders`   | Headers exposed to browser         | `[]`                                          |
| `allowCredentials` | Enables cookies/auth headers       | `false`                                       |
| `maxAgeSeconds`    | Cache time for preflight responses | `86400`                                       |

---

### `CorsConfigurationSource`

An abstract interface for providing dynamic CORS configurations per request:

```dart
abstract interface class CorsConfigurationSource {
  CorsConfiguration? getCorsConfiguration(HttpRequest request);
}
```

You can implement this to return a configuration based on any request attribute.

---

### `PathBasedCorsConfigurationSource`

Default implementation that maps CORS policies to path prefixes:

```dart
final corsSource = PathBasedCorsConfigurationSource();

corsSource.register('/api/public', CorsConfiguration(allowedOrigins: ['*']));
corsSource.register('/api/secure', CorsConfiguration(
  allowedOrigins: ['https://myapp.com'],
  allowCredentials: true,
));
```

When a request comes in, it checks the URI path and applies the first matching configuration.

---

## 🚀 Usage

Plug `CorsConfigurationSource` into your HTTP pipeline:

```dart
void handleRequest(HttpRequest request) {
  final config = corsSource.getCorsConfiguration(request);

  if (config != null && request.method == 'OPTIONS') {
    // Handle preflight request
    request.response
      ..headers.set('Access-Control-Allow-Origin', config.allowedOrigins.first)
      ..headers.set('Access-Control-Allow-Methods', config.allowedMethods.join(','))
      ..headers.set('Access-Control-Allow-Headers', config.allowedHeaders.join(','))
      ..close();
    return;
  }

  // Apply CORS headers to actual request
  if (config != null) {
    request.response.headers.set('Access-Control-Allow-Origin', config.allowedOrigins.first);
    if (config.allowCredentials) {
      request.response.headers.set('Access-Control-Allow-Credentials', 'true');
    }
  }

  // Continue with your normal logic
}
```

---

## 📂 File Structure

```
lib/
├── cors.dart                // Export barrel
├── cors_configuration.dart  // CORS config data class
├── cors_configuration_source.dart  // Strategy interface
├── path_based_cors_configuration_source.dart  // Default impl
```

---

## 🛡️ License

Apache License 2.0