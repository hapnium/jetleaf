# 📋 LOGGING

A **flexible**, **extensible**, and **pluggable** structured logging library for Dart.

`logging` is part of the **JetLeaf Framework** and provides robust, developer-friendly logging with full control over how logs are captured, formatted, and presented. Inspired by Java/Kotlin-style structured logging, this library works seamlessly across console, file, or remote output targets.

---

## ✨ Features

✅ Multiple log levels: `TRACE`, `DEBUG`, `INFO`, `WARN`, `ERROR`, `FATAL`  
✅ Structured, human-readable, and colorized output  
✅ Customizable formatters via `LogPrinter`  
✅ Easily pluggable with `LoggerListener`  
✅ Supports tags, timestamps, stack traces, error objects  
✅ Composable logging steps via `LogStep`  
✅ Production-ready with zero dependencies

---

## 🧪 Example Usage

```dart
import 'package:jetleaf/logging.dart';

void main() {
  console.debug('Initializing system...');
  console.info('Server started at port 8080');
  console.error('Connection failed', error: Exception('Timeout'));
}
````

---

## 🖨️ Built-in Printer Types (`LogType`)

| Type                | Description                                          | Structured | Colorized |
| ------------------- | ---------------------------------------------------- | ---------- | --------- |
| `SIMPLE`            | One-line logs with emoji and tag support             | ❌          | ✔️        |
| `FLAT`              | Minimal plain output (message only)                  | ❌          | ❌         |
| `FLAT_STRUCTURED`   | One-line structured log with metadata                | ✔️         | ❌         |
| `PRETTY`            | Multi-line logs with visual styling                  | ❌          | ✔️        |
| `PRETTY_STRUCTURED` | Verbose, pretty multi-line logs with stack traces    | ✔️         | ✔️        |
| `PREFIX`            | Logs prefixed with tags or log levels, like `[INFO]` | ✔️         | ❌         |
| `FMT`               | `printf`-style formatted string logs                 | ❌          | ❌         |
| `HYBRID`            | Combines pretty printing with structured logging     | ✔️         | ✔️        |

---

## 🔧 Creating a Custom Log Printer

You can define your own log output style:

```dart
class MyCustomPrinter extends LogPrinter {
  @override
  List<String> log(LogRecord record) {
    return ['[${record.level.name}] ${record.message}'];
  }
}

final customLogger = Logger();
customLogger.addListener(LoggerListener.withPrinter(MyCustomPrinter()));
customLogger.info('Hello from custom logger!');
```

---

## 📦 Exported API

| Component        | Description                                      |
| ---------------- | ------------------------------------------------ |
| `LogLevel`       | Defines log severity (`INFO`, `ERROR`, etc.)     |
| `LogStep`        | Configures log composition (timestamp, error...) |
| `LogType`        | Enum of built-in printer styles                  |
| `LogPrinter`     | Interface for custom log formatting              |
| `LoggerListener` | Handles how logs are dispatched and styled       |
| `LogConfig`      | Controls global logger behavior                  |
| `Logger`         | The main class used for creating log entries     |
| `console`        | Singleton instance of `Logger` for quick use     |

---

## 🔌 Customization

You can fully customize the logging pipeline by replacing the default listener or changing the printer and log steps:

```dart
console.addListener(
  LoggerListener(
    level: LogLevel.DEBUG,
    printer: MyCustomPrinter(),
    config: LogConfig(
      steps: [LogStep.level, LogStep.message, LogStep.error],
    ),
  ),
);
```

---

## 📄 License

MIT License © JetLeaf Framework Authors

---

## 🚀 Part of JetLeaf

This library is part of the [`jetleaf`](https://github.com/hapnium/jetleaf) ecosystem – a modular, expressive, and modern backend framework for Dart.