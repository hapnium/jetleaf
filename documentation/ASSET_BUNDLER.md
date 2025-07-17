# 🗂️ JetLeaf Asset Bundler

A configurable, zero-dependency asset loader for Dart and JetLeaf-based projects. This package provides a unified interface to load static assets (e.g. HTML templates, JSON config files) from Dart packages, with built-in caching, error handling, and cross-environment support.

---

## ✨ Features

- 📦 Load assets from any Dart package
- ⚡ Caching for improved performance
- 💥 Graceful error handling with [BundlerException]
- 🧪 Compatible with `pub.dev`, local packages, CLI apps, and JetLeaf
- 🔍 Dynamic package root resolution
- 🔁 Clear internal caches to force reloads
- ✅ Fully typed and extensible API

---

## 🚀 Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  jetleaf: ^1.0.0
```

---

## 🧰 Usage

### 🔹 Load an Asset from JetLeaf

```dart
import 'package:jetleaf/bundler.dart';

final html = await jetLeafBundler.load('resources/html/404.html');
```

### 🔸 Load from a Custom Package

```dart
final bundler = rootBundler('my_package');
final config = await bundler.load('assets/config/settings.json');
```

### 🔍 Check for Asset Existence

```dart
final exists = await bundler.exists('templates/email.html');
```

### ♻️ Clear Cache

```dart
bundler.clearCache();
```

---

## 🧪 Example

```dart
void main() async {
  final bundler = JetLeafBundler.forPackage('my_package');
  
  if (await bundler.exists('templates/index.html')) {
    final html = await bundler.load('templates/index.html');
    print(html);
  } else {
    print('Template not found');
  }
}
```

---

## 📦 API Overview

### `JetLeafBundler`

```dart
final bundler = JetLeafBundler.forPackage('my_package');
```

* `.load(path)`: Loads asset as a string
* `.exists(path)`: Checks if asset exists
* `.clearCache()`: Clears cached asset content
* `.getPackageRoot()`: Returns the root path of the resolved package
* `.packageName`: Returns the package name

### `BundlerManager`

> Internal class that handles URI resolution, file reads, root detection, and caching.

### `BundlerException`

```dart
throw BundlerException('File missing', 'path/to/file.html', originalError);
```

A detailed exception with `assetPath`, `message`, and optional `cause`.

### `BundlerInterface`

Abstract contract for all bundler implementations.

---

## 🛠️ Internals

* Tries multiple resolution strategies:

  * Dart `package:` URIs via `Isolate.resolvePackageUri`
  * Local filesystem lookups (for CLI builds or dev mode)
  * Platform script-based probing (for monorepos and sandboxed apps)
* Supports `.pub-cache` structures
* Automatically deduplicates asset reads via internal caching

---

## 📄 License

MIT License © 2024 [Hapnium](https://hapnium.com)

---

## 👤 Author

**Evaristus Adimonyemma**
Email: [evaristusadimonyemma@hapnium.com](mailto:evaristusadimonyemma@hapnium.com)
Website: [https://hapnium.com](https://hapnium.com)