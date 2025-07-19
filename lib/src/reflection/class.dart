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

import 'dart:mirrors' as mirrors;

import 'exceptions.dart';
import 'context/class_context.dart';
import 'interfaces/annotated_element.dart';
import 'interfaces/reflectable_annotation.dart';
import 'context/type_descriptor.dart';
import 'mirrors/class_mirror.dart';
import 'models/constructor_info.dart';
import 'models/field_info.dart';
import 'models/method_info.dart';
import 'models/type_variable_info.dart';
import 'runtime_class.dart';

/// A comprehensive wrapper around the Jet Reflection system that provides
/// easy access to all the capabilities of the reflection framework.
/// 
/// The `Class<T>` represents a runtime type and provides methods to:
/// - Inspect annotations and metadata
/// - Access class hierarchy information
/// - Examine methods, fields, and constructors
/// - Create instances dynamically
/// - Perform type checking and comparisons
/// - Extract generic type arguments
/// 
/// This class implements multiple interfaces to provide a complete
/// reflection API similar to Java's Class<?> but adapted for Dart.
/// 
/// Example usage:
/// ```dart
/// @MyAnnotation('example')
/// class MyClass {
///   String field = 'value';
///   void method() {}
/// }
/// 
/// final clazz = Class<MyClass>();
/// print(clazz.simpleName); // 'MyClass'
/// print(clazz.hasAnnotation<MyAnnotation>()); // true
/// final instance = clazz.newInstance();
/// 
/// // Generic type extraction
/// final listClass = Class<List<Address>>();
/// final elementTypes = listClass.getTypeArguments(); // [Class<Address>]
/// ```
base class Class<T> implements AnnotatedElement, TypeDescriptorOfField<Class>, ValueType, ClassContext<T> {
  /// The underlying ClassMirror from the Jet Reflection system
  late final ClassMirror<T> _classMirror;

  /// Cached annotations for performance
  List<ReflectableAnnotation>? _cachedAnnotations;

  /// Cached methods for performance
  Map<String, ClassMethodInfo>? _cachedMethods;

  /// Cached fields for performance
  Map<String, ClassFieldInfo>? _cachedFields;

  /// Cached constructors for performance
  Map<String, ClassConstructorInfo>? _cachedConstructors;

  /// Creates a Class instance for type T.
  /// 
  /// This constructor uses the Jet Reflection system to obtain reflection
  /// information about the type T at runtime.
  Class() {
    try {
      _classMirror = ClassMirror.forType<T>();
    } catch (e) {
      throw ClassInstantiationException('Cannot create Class for type $T: $e');
    }
  }

  /// Creates a Class instance from a Type object.
  /// 
  /// This allows creating Class instances dynamically when you have
  /// a Type object but not the compile-time generic parameter.
  Class.fromType(Type type) {
    try {
      _classMirror = ClassMirror.forTypeObject(type) as ClassMirror<T>;
    } catch (e) {
      throw ClassInstantiationException('Cannot create Class for type $type: $e');
    }
  }

  /// Creates a Class instance from a Dart ClassMirror.
  /// 
  /// This is useful when you already have a Dart ClassMirror and want
  /// to wrap it in a Class instance.
  Class.reflectType(Type type) {
    try {
      _classMirror = ClassMirror.fromDartMirror(mirrors.reflectClass(type));
    } catch (e) {
      throw ClassInstantiationException('Cannot create Class for type $type: $e');
    }
  }

  /// Creates a Class instance from an object.
  /// 
  /// This allows creating Class instances dynamically when you have
  /// an object but not the compile-time generic parameter.
  Class.fromObject(Object object) {
    try {
      _classMirror = ClassMirror.forObject(object) as ClassMirror<T>;
    } catch (e) {
      throw ClassInstantiationException('Cannot create Class for object $object: $e');
    }
  }

  /// Creates a Class instance from a ClassMirror.
  /// 
  /// This is useful when you already have a ClassMirror and want
  /// to wrap it in a Class instance.
  Class.fromMirror(ClassMirror<T> mirror) : _classMirror = mirror;

  /// Creates a Class instance from a Dart ClassMirror.
  /// 
  /// This is useful when you already have a Dart ClassMirror and want
  /// to wrap it in a Class instance.
  Class.fromDartMirror(mirrors.ClassMirror mirror) : _classMirror = ClassMirror.fromDartMirror(mirror);

  @override
  String get simpleName => _classMirror.getSimpleName();

  @override
  String get qualifiedName => _classMirror.getCanonicalName();

  @override
  Type get type {
    try {
      return _classMirror.getType();
    } catch (e) {
      throw UnsupportedError('Type not available for this class: $e');
    }
  }

  @override
  ClassMirror<T> get mirror => _classMirror;

  @override
  bool get isAbstract => _classMirror.isAbstract();

  @override
  bool get isEnum => _classMirror.isEnum();

  @override
  bool get isPrivate => _classMirror.isPrivate();

  @override
  bool get isTopLevel => !_classMirror.isPrivate();

  @override
  bool get isInterface => _classMirror.isInterface();

  @override
  bool isAnnotationPresent<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return _classMirror.isAnnotationPresent(annotationType);
  }

  @override
  List<A> getEnumValues<A extends Enum>() {
    final values = <A>[];

    for (final decl in mirror.dartMirror.declarations.values) {
      if (decl is mirrors.VariableMirror && decl.isStatic && decl.isFinal) {
        final value = mirror.dartMirror.getField(decl.simpleName).reflectee;
        if (value.runtimeType == A) {
          values.add(value as A);
        }
      }
    }

    return values;
  }

  @override
  A? getAnnotation<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return _classMirror.getAnnotation(annotationType);
  }

  @override
  List<ReflectableAnnotation> getAnnotations() {
    if (_cachedAnnotations != null) {
      return _cachedAnnotations!;
    }
    _cachedAnnotations = _classMirror.getAnnotations();
    return _cachedAnnotations!;
  }

  @override
  List<A> getAnnotationsByType<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return _classMirror.getAnnotationsByType(annotationType);
  }

  @override
  List<ReflectableAnnotation> getDeclaredAnnotations() {
    return _classMirror.getDeclaredAnnotations();
  }

  @override
  List<A> getDeclaredAnnotationsByType<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return _classMirror.getDeclaredAnnotationsByType(annotationType);
  }

  @override
  A? getDeclaredAnnotation<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return _classMirror.getDeclaredAnnotation(annotationType);
  }

  @override
  bool hasAnnotation<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return isAnnotationPresent(annotationType);
    } catch (e) {
      return false;
    }
  }

  @override
  A? getAnnotationByType<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return getAnnotation(annotationType);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Class<Object>> getTypeArguments() {
    try {
      // Extract type arguments from the underlying Dart mirror
      final dartTypeArgs = _classMirror.dartMirror.typeArguments;
      
      if (dartTypeArgs.isEmpty) {
        return <Class<Object>>[];
      }
      
      final typeArguments = <Class<Object>>[];
      
      for (final typeArg in dartTypeArgs) {
        try {
          final reflectedType = typeArg.reflectedType;
          
          // Skip dynamic and void types
          if (reflectedType == dynamic || reflectedType.toString() == 'void') {
            continue;
          }
          
          // Create Class instance from the reflected type
          final classInstance = Class<Object>.fromType(reflectedType);
          typeArguments.add(classInstance);
          
        } catch (e) {
          print('Warning: Could not resolve type argument: $e');
          // Continue with other type arguments
        }
      }
      
      return typeArguments;
      
    } catch (e) {
      print('Error extracting type arguments: $e');
      return <Class<Object>>[];
    }
  }

  @override
  RuntimeClass arrayType() {
    if (!isArray()) {
      throw IllegalArgumentTypeException('$type is not an array type.');
    }
    
    // Fallback: try to extract directly from dart mirror
    try {
      final dartTypeArgs = _classMirror.dartMirror.typeArguments;
      if (dartTypeArgs.isNotEmpty) {
        return RuntimeClass(dartTypeArgs.first);
      }
    } catch (e) {
      print('Fallback extraction failed: $e');
    }
    
    // Last resort fallback
    return RuntimeClass(this._classMirror.dartMirror);
  }

  // Enhanced componentType that uses the improved type argument extraction
  @override
  Class<T>? componentType() {
    if (!isArray()) {
      return null;
    }
    
    final typeArgs = getTypeArguments();
    if (typeArgs.isNotEmpty) {
      // Try to cast to Class<T> if possible
      try {
        return typeArgs.first as Class<T>?;
      } catch (e) {
        // If casting fails, return null
        return null;
      }
    }
    
    return null;
  }

  // Helper method to check if this is a generic type
  @override
  bool get isGeneric {
    try {
      final dartTypeArgs = _classMirror.dartMirror.typeArguments;
      return dartTypeArgs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Enhanced method to get the raw type (without generics)
  Class<Object> getRawType() {
    try {
      // Get the raw type string and create a Class from it
      final typeString = type.toString();
      
      // Extract the base type name (before any generic parameters)
      String rawTypeName;
      if (typeString.contains('<')) {
        rawTypeName = typeString.substring(0, typeString.indexOf('<'));
      } else {
        rawTypeName = typeString;
      }
      
      // Handle common types
      switch (rawTypeName) {
        case 'List':
          return Class<Object>.fromType(List);
        case 'Set':
          return Class<Object>.fromType(Set);
        case 'Map':
          return Class<Object>.fromType(Map);
        case 'Iterable':
          return Class<Object>.fromType(Iterable);
        default:
          return this as Class<Object>;
      }
    } catch (e) {
      return this as Class<Object>;
    }
  }

  // Method to check if this type has specific type arguments
  bool hasTypeArgument<A>() {
    final typeArgs = getTypeArguments();
    return typeArgs.any((arg) => arg.type == A);
  }

  // Method to get a specific type argument by index
  Class<Object>? getTypeArgument(int index) {
    final typeArgs = getTypeArguments();
    if (index >= 0 && index < typeArgs.length) {
      return typeArgs[index];
    }
    return null;
  }

  // Method to get type arguments as a map (useful for Map<K,V> types)
  Map<String, Class<Object>> getTypeArgumentsAsMap() {
    final typeArgs = getTypeArguments();
    final result = <String, Class<Object>>{};
    
    // For Map types, typically K, V
    if (isSubTypeOf<Map>() && typeArgs.length >= 2) {
      result['K'] = typeArgs[0]; // Key type
      result['V'] = typeArgs[1]; // Value type
    }
    // For single generic types like List<T>, Set<T>
    else if (typeArgs.isNotEmpty) {
      result['T'] = typeArgs[0];
    }
    
    return result;
  }

  @override
  String descriptorString() {
    if (isPrimitive()) {
      switch (type) {
        case const (bool): return 'Z';
        case const (int): return 'I';
        case const (double): return 'D';
        case const (String): return 'Ljava/lang/String;';
        case const (Null): return 'V'; // void
        default: return 'V';
      }
    }
    if (isArray()) {
      final component = componentType();
      return '[${component?.descriptorString() ?? 'Ljava/lang/Object;'}';
    }
    return 'L${qualifiedName.replaceAll('.', '/')};';
  }

  @override
  bool isArray() {
    try {
      final listClass = ClassMirror.forType<List>();
      return _classMirror.isSubclassOf(listClass);
    } catch (e) {
      final typeString = type.toString();
      return typeString.startsWith('List<') || type == List;
    }
  }

  @override
  bool isPrimitive() {
    return type == bool || type == int || type == double || type == String || type == Null;
  }

  @override
  String get typeName => type.toString();

  @override
  Class<Object>? getSuperclass() {
    try {
      final superclass = _classMirror.getSuperclass();
      return superclass != null ? Class.fromMirror(superclass) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Class<T>? getSuperClass<U>() {
    try {
      final superclass = _classMirror.getSuperClass<T>();
      return superclass != null ? Class.fromMirror(superclass) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  List<Class<Object>> getSuperinterfaces() {
    try {
      final interfaces = _classMirror.getInterfaces();
      return interfaces.map((interface) => Class.fromMirror(interface)).toList();
    } catch (e) {
      return <Class<Object>>[];
    }
  }

  @override
  bool isSubinterfaceOf(Class<Object> other) {
    try {
      return _classMirror.isSubclassOf(other._classMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isSubclassOf(Class<Object> other) {
    try {
      return _classMirror.isSubclassOf(other._classMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isSubTypeOf<U>() {
    try {
      return _classMirror.isSubclassOf(ClassMirror.forType<U>());
    } catch (e) {
      return false;
    }
  }

  @override
  U cast<U>() {
    return _classMirror.dartMirror.reflectedType as U;
  }

  @override
  bool isAssignableFrom(Class<Object> other) {
    try {
      return _classMirror.isAssignableFrom(other._classMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isInstance(Object? object) {
    if (object == null) return type == Null;
    try {
      return _classMirror.isInstance(object);
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, ClassMethodInfo> getDeclaredMethods() {
    if (_cachedMethods != null) {
      return Map.unmodifiable(_cachedMethods!);
    }
    try {
      final jetleafMethods = _classMirror.getDeclaredMethods();
      final methods = <String, ClassMethodInfo>{};
      for (final entry in jetleafMethods.entries) {
        methods[entry.key] = ClassMethodInfo.fromJetMirror(entry.value);
      }
      _cachedMethods = methods;
      return Map.unmodifiable(methods);
    } catch (e) {
      return <String, ClassMethodInfo>{};
    }
  }

  @override
  Map<String, ClassMethodInfo> getMethods() {
    try {
      final jetleafMethods = _classMirror.getMethods();
      final methods = <String, ClassMethodInfo>{};
      for (final entry in jetleafMethods.entries) {
        methods[entry.key] = ClassMethodInfo.fromJetMirror(entry.value);
      }
      return methods;
    } catch (e) {
      return <String, ClassMethodInfo>{};
    }
  }

  @override
  ClassMethodInfo? getMethod(String name) {
    try {
      final jetleafMethod = _classMirror.getMethod(name);
      return ClassMethodInfo.fromJetMirror(jetleafMethod);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, ClassFieldInfo> getFields() {
    try {
      final classFields = _classMirror.getFields();
      final fields = <String, ClassFieldInfo>{};
      for (final entry in classFields.entries) {
        fields[entry.key] = ClassFieldInfo.fromJetMirror(entry.value);
      }

      return fields;
    } catch (e) {
      return <String, ClassFieldInfo>{};
    }
  }

  @override
  Map<String, ClassFieldInfo> getDeclaredFields() {
    if (_cachedFields != null) {
      return Map.unmodifiable(_cachedFields!);
    }

    try {
      final classFields = _classMirror.getDeclaredFields();
      final fields = <String, ClassFieldInfo>{};
      for (final entry in classFields.entries) {
        fields[entry.key] = ClassFieldInfo.fromJetMirror(entry.value);
      }

      _cachedFields = fields;
      return Map.unmodifiable(fields);
    } catch (e) {
      return <String, ClassFieldInfo>{};
    }
  }

  @override
  ClassFieldInfo? getField(String name) {
    try {
      final jetleafField = _classMirror.getField(name);
      return ClassFieldInfo.fromJetMirror(jetleafField);
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, ClassConstructorInfo> getConstructors() {
    if (_cachedConstructors != null) {
      return Map.unmodifiable(_cachedConstructors!);
    }
    try {
      final jetleafConstructors = _classMirror.getConstructors();
      final constructors = <String, ClassConstructorInfo>{};
      for (final entry in jetleafConstructors.entries) {
        constructors[entry.key] = ClassConstructorInfo.fromJetMirror(entry.value);
      }
      _cachedConstructors = constructors;
      return Map.unmodifiable(constructors);
    } catch (e) {
      return <String, ClassConstructorInfo>{};
    }
  }

  @override
  ClassConstructorInfo? getConstructor([String name = '']) {
    final constructors = getConstructors();
    return constructors[name.isEmpty ? 'default' : name];
  }

  @override
  T newInstance([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _classMirror.newInstance(positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  T newInstanceWithFields(Map<String, Object?> fieldValues) => _classMirror.newInstanceWithFields(fieldValues);

  @override
  T newInstanceNamed(String constructorName, [List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _classMirror.newInstanceNamed(constructorName, positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  List<ClassTypeVariableInfo> getTypeVariables() {
    return <ClassTypeVariableInfo>[];
  }

  @override
  bool get isOriginalDeclaration => true;

  @override
  Class<T> getOriginalDeclaration() {
    return this;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Class && other._classMirror == _classMirror;
  }

  @override
  int get hashCode => _classMirror.hashCode;

  @override
  String toString() => 'Class<$typeName>';

  @override
  bool equals(Class<Object> other) {
    return this == other;
  }

  /// Clears all cached data for this Class instance.
  void clearCache() {
    _cachedAnnotations = null;
    _cachedMethods = null;
    _cachedFields = null;
    _cachedConstructors = null;
  }
}