# 🌱 JetLeaf Env

A full Dart implementation of Spring's `Environment` abstraction system, designed for the **JetLeaf** framework.  
Provides property resolution, layered property sources, profile management, and support for command-line arguments — all with Spring-style flexibility and structure.

---

## ✨ Features

- 🔍 Type-safe **property resolution**
- 🧱 Layered **property sources** (Map, Environment, CLI, etc.)
- 🛠️ **Mutable sources** with ordering
- 🧩 **Profile activation** support
- ⚙️ Customizable `Environment` types
- 🧪 Fully testable with in-memory configuration

---

## 📦 Included APIs

### 🔧 Property Resolver

| Class | Description |
|-------|-------------|
| `PropertyResolver` | Resolves properties by key, with support for default values and type conversion |
| `ConfigurablePropertyResolver` | Allows mutation and configuration of the resolver (e.g., placeholder resolution) |
| `PropertySourcesPropertyResolver` | Bridge between `PropertyResolver` and `PropertySources` |
| `AbstractPropertyResolver` | Base implementation with common behavior |

### 📚 Property Sources

| Class | Description |
|-------|-------------|
| `PropertySource<T>` | Represents a single property source (e.g. Map, CLI, system env) |
| `MapPropertySource` | Backed by a simple `Map<String, Object>` |
| `PropertiesPropertySource` | Java-style `.properties` support |
| `SystemEnvironmentPropertySource` | Reads from system environment variables |
| `SimpleCommandLinePropertySource` | Reads arguments from CLI using parser |
| `MutablePropertySources` | A modifiable, ordered list of property sources |

### 🌍 Environment

| Class | Description |
|-------|-------------|
| `Environment` | Read-only property access and profile inspection |
| `ConfigurableEnvironment` | Adds mutation and property source management |
| `AbstractEnvironment` | Base for environment implementations |
| `StandardEnvironment` | Default implementation used in JetLeaf |
| `EnvironmentCapable` | Marker interface for any class that exposes an `Environment` |

### 🧪 Command Line Support

| Class | Description |
|-------|-------------|
| `CommandLineArgs` | Internal representation of CLI options and non-options |
| `SimpleCommandLineArgsParser` | Parses `List<String>` into `CommandLineArgs` |

---

## 🚀 Usage

### Setup Environment

```dart
final env = StandardEnvironment();
env.propertySources.addFirst(
  MapPropertySource('custom', {'app.name': 'JetLeaf'})
);
````

### Access Properties

```dart
final name = env.getProperty('app.name'); // 'JetLeaf'
final port = env.getProperty<int>('server.port', defaultValue: 8080);
```

### Add CLI or System Env

```dart
final cliArgs = ['--server.port=9090', '--debug=true'];
env.propertySources.addLast(
  SimpleCommandLinePropertySource(cliArgs)
);

final system = SystemEnvironmentPropertySource();
env.propertySources.addLast(system);
```

### Working with Profiles

```dart
env.activeProfiles = ['dev'];
if (env.acceptsProfiles('dev')) {
  print('Running in dev mode');
}
```

---

## 🧪 Testing with Mutable Sources

```dart
final sources = MutablePropertySources();
sources.addFirst(MapPropertySource('test', {'env': 'test'}));

final resolver = PropertySourcesPropertyResolver(sources);
expect(resolver.getProperty('env'), 'test');
```

---

## 📁 Project Structure Suggestion

```
lib/
├── env.dart
└── src/
    └── env/
        ├── property_resolver/
        ├── property_source/
        ├── command_line/
        └── ...
```

---

## 📜 License

MIT License © JetLeaf Framework Authors