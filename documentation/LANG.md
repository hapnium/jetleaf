# 🌐 JetLeaf Lang – Core Dart Utilities for JetLeaf

`lang` is the foundational module in the **JetLeaf** ecosystem. It brings together a comprehensive suite of utility classes, data structures, I/O abstractions, mathematical types, and stream operations—designed to feel familiar to developers coming from Java or Kotlin.

---

## 📦 What's Inside

### 🗂️ Collections
Efficient and customizable collection types:
- `ArrayList`, `LinkedList`
- `Stack`, `Queue`, `LinkedQueue`, `LinkedStack`
- `HashMap`, `HashSet`

### 🧬 Primitive Wrappers
Java-style primitive type wrappers:
- `Integer`, `Double`, `Float`, `Short`, `Long`
- `Character`, `Boolean`

### ⏱️ Time & Date
Inspired by `java.time`:
- `LocalDate`, `LocalTime`, `LocalDateTime`
- `ZonedDateTime`, `ZoneId`

### 🧮 Math
Support for arbitrarily large numbers:
- `BigInteger`, `BigDecimal`

### 🔁 Streams
Functional-style streaming API:
- `Stream<T>`, `IntStream`, `DoubleStream`, `GenericStream`
- Collectors, Stream builders, Auto-closeable streams

### 🧩 Extensions
Tons of powerful Dart extensions for:
- `String`, `int`, `double`, `bool`, `Iterable`, `List`, `Map`, `num`
- `DateTime`, `Duration`, `Type`, `dynamic`, etc.

### 🧵 I/O and Streams
Low-level and buffered I/O utilities:
- `ByteArray`, `Byte`, `ByteStream`
- `InputStream`, `OutputStream`
- `BufferedReader`, `BufferedWriter`
- `FileReader`, `FileWriter`, `FileInputStream`, `FileOutputStream`

### 🔧 Utilities
Other general-purpose utilities:
- `Optional<T>`
- `StringBuilder`
- `RegexUtils`
- `Instance` helper
- Custom `Exception` types
- Type aliases via `typedefs.dart`

---

## 🧠 Design Philosophy

- **Modular** – Cleanly separated components for collections, streams, time, I/O, math, and more.
- **Java-inspired** – API patterns modeled after familiar Java/Kotlin standards for easier onboarding.
- **Pure Dart** – No external dependencies, compatible with both VM and Flutter.
- **Interop-Friendly** – Plays well with other `JetLeaf` modules, including `jetson`, `security`, `reflect`, and more.

---

## 🚀 Getting Started

Add `lang` to your JetLeaf project:

```dart
import 'package:jetleaf/lang.dart';

final list = ArrayList<String>();
final optional = Optional.of("hello");
final now = LocalDateTime.now();
final stream = Stream.of([1, 2, 3]).map((e) => e * 2);
````

---

## 🧪 Example Use Cases

### 1. Java-style `Optional`

```dart
Optional<String> value = Optional.ofNullable(null);
print(value.orElse("default"));
```

### 2. Buffered File Reading

```dart
final reader = BufferedReader(FileReader('file.txt'));
final line = reader.readLine();
reader.close();
```

### 3. Stream API

```dart
final result = Stream.of([1, 2, 3, 4])
    .filter((x) => x % 2 == 0)
    .map((x) => x * 10)
    .toList(); // [20, 40]
```

### 4. Zoned Time

```dart
final time = ZonedDateTime.now(ZoneId.of('Africa/Lagos'));
print(time.toIsoString());
```

---

## 📚 Part of JetLeaf

This package is part of the [JetLeaf Framework](https://github.com/hapnium/jetleaf), an opinionated full-stack backend framework for Dart.

---

## 🔮 Coming Soon

* [ ] Stream parallelism
* [ ] Collection transformation pipelines
* [ ] Enhanced type safety across collection APIs
* [ ] Locale-sensitive time/date parsing

---

## 📄 License

MIT (or your custom license)

---

## 📫 Contributing

Pull requests and suggestions are welcome. Feel free to open issues or propose enhancements.