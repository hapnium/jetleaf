# 🔍 Reflection Library

A powerful, type-safe, and extensible reflection system for Dart, inspired by Java's reflection and annotation APIs.

The `reflection` library brings full introspection and annotation support to Dart applications with a focus on structured metadata, runtime class representation, and customizable annotation behaviors. It is designed as a core part of the **JetLeaf Framework** but can be used standalone.

---

## ✨ Features

✅ Runtime class inspection with type safety  
✅ Full support for fields, methods, constructors, and parameters  
✅ Annotation system with support for meta-annotations  
✅ Custom annotation factories and builders  
✅ `Class<T>` wrapper with generic introspection APIs  
✅ Declarative and programmatic annotation access  
✅ Built-in exception handling and safety

---

## 🧪 Example Usage

```dart
final clazz = Class<MyClass>();

// Get all declared fields
for (final field in clazz.getFields().values) {
  print('${field.name}: ${field.type}');
}

// Get all methods
final methods = clazz.getMethods();
print('Method count: ${methods.length}');

// Access annotations
if (clazz.hasAnnotation<MyAnnotation>()) {
  final annotation = clazz.getAnnotation<MyAnnotation>();
  print('Found annotation: $annotation');
}
````

---

## 🔧 Core Components

### 📦 Class Inspection

* `Class<T>` – Type-safe wrapper for runtime class representation
* `RuntimeClass` – Variant that holds actual runtime `Type`
* `ClassContext` & `TypeDescriptor` – Internal metadata containers

### 🏷️ Annotations System

* `Annotation`, `MarkerAnnotation`, `SimpleAnnotation` – Core annotation interfaces
* `ReflectableAnnotation` – Base interface for custom annotations
* `AutoAnnotation` – Mixin for automatic registration
* `AnnotationFactory` & `AnnotationBuilder` – For dynamic annotation creation

### 🔍 Mirrors

* `ClassMirror`
* `MethodMirror`
* `FieldMirror`
* `ConstructorMirror`
* `ParameterMirror`

### 📚 Metadata Models

* `FieldInfo`
* `MethodInfo`
* `ConstructorInfo`
* `ParameterInfo`
* `TypeVariableInfo`

---

## 🧠 Custom Annotations

Define your own annotations:

```dart
class JsonField implements SimpleAnnotation {
  final String name;
  const JsonField(this.name);
}
```

Use it in a class:

```dart
class User {
  @JsonField('first_name')
  String firstName;
}
```

Then access it via reflection:

```dart
final clazz = Class<User>();
final field = clazz.getField('firstName');
final jsonMeta = field.getAnnotation<JsonField>();
print(jsonMeta.name); // prints: first_name
```

---

## 🚫 Exceptions

Includes specific exceptions for safe reflection:

* `ReflectionException`
* `AnnotationNotFoundException`
* `UnsupportedOperationException`

---

## 📦 Exports Overview

| Category    | Key Exports                                                             |
| ----------- | ----------------------------------------------------------------------- |
| Interfaces  | `AccessibleObject`, `AnnotatedElement`, `Member`, `Executable`, etc.    |
| Context     | `ClassContext`, `TypeDescriptor`                                        |
| Mirrors     | `ClassMirror`, `MethodMirror`, `FieldMirror`, etc.                      |
| Annotations | `Annotation`, `SimpleAnnotation`, `AutoAnnotation`, `AnnotationFactory` |
| Models      | `FieldInfo`, `MethodInfo`, `ParameterInfo`, etc.                        |
| Utilities   | `ReflectionUtils`, `Extension`, `Exceptions`, `Class`, `RuntimeClass`   |

---

## 🧱 Built for Hapnium

This library is a foundational component of the [`hapnium`](https://github.com/hapnium/jetleaf) framework but is modular and usable independently for reflection-heavy or annotation-driven Dart applications.

---

## 📄 License

MIT License © Hapnium