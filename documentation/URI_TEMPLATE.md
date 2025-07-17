# 🌐 jetleaf_uri

A zero-dependency Dart utility for parsing, matching, expanding, and normalizing URI templates — perfect for routing, dynamic URL generation, and robust path comparisons in JetLeaf and general Dart projects.

---

## ✨ Features

- 🔄 **Template Matching** – Extract variables from paths (e.g. `/users/{id}`)
- 🔧 **Template Expansion** – Generate full paths from variable maps
- 🧹 **Path Normalization** – Clean and standardize messy URLs
- 🧭 **Full URL Normalization** – Canonicalizes scheme, host, port, path, query, and fragment
- 🔒 **Safe and Typed API** – Fully null-safe and exception-based error handling

---

## 📦 Installation

```yaml
dependencies:
  jetleaf: ^1.0.0
```

---

## 🧰 Basic Usage

### 🔹 Match a Path

```dart
final template = UriTemplate('/users/{id}/orders/{orderId}');
final result = template.match('/users/42/orders/99');

print(result); // {id: 42, orderId: 99}
```

### 🔸 Expand a Template

```dart
final template = UriTemplate('/docs/{section}/{page}');
final path = template.expand({'section': 'guide', 'page': 'intro'});

print(path); // /docs/guide/intro
```

### 🧽 Normalize a Path

```dart
final clean = UriTemplate.normalizePath('///api//v1/users/');
print(clean); // /api/v1/users
```

### 🌍 Normalize a Full URL

```dart
final url = 'HTTP://Example.com:80/users?id=2&name=John';
final normalized = UriTemplate.normalize(url);

print(normalized); // http://example.com/users?id=2&name=John
```

---

## 🚨 Error Handling

### `PathMatchingException`

Thrown during template expansion if a required variable is missing:

```dart
try {
  final template = UriTemplate('/items/{id}');
  template.expand({}); // Missing "id"
} catch (e) {
  print(e); // PathMatchingException: Missing required URI template variable: id
}
```

---

## 📘 API Reference

### `class UriTemplate`

| Method                | Description                                                          |
| --------------------- | -------------------------------------------------------------------- |
| `match(path)`         | Match a path and extract template variables as `Map<String, String>` |
| `expand(variables)`   | Expand a template into a full path using a map                       |
| `normalizePath(path)` | Clean up raw paths (slashes, trailing, etc.)                         |
| `normalize(url)`      | Normalize an entire URI (scheme, path, query, fragment, etc.)        |
| `matches(a, b)`       | Returns `true` if normalized versions of two URLs are equal          |

### `class PathMatchingException`

| Field        | Description                         |
| ------------ | ----------------------------------- |
| `message`    | Error message detailing the problem |
| `toString()` | Standard Dart exception formatting  |

---

## 📚 Why Use This?

`jetleaf_uri` is ideal for:

* Building custom web routers
* Dynamic URL generation for APIs and templates
* Slug and ID extraction
* Normalizing external input (e.g., redirects or incoming URLs)

---

## 🧪 Testing

This package is fully tested and CI-ready. To run tests:

```bash
dart test
```

---

## 📄 License

MIT License © 2025 [Hapnium](https://hapnium.com)

---

## 👤 Author

**Evaristus Adimonyemma**
Email: [evaristusadimonyemma@hapnium.com](mailto:evaristusadimonyemma@hapnium.com)
Website: [https://hapnium.com](https://hapnium.com)