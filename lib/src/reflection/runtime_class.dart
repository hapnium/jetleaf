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
import 'interfaces/reflectable_annotation.dart';
import 'mirrors/class_mirror.dart';
import 'mirrors/constructor_mirror.dart';
import 'mirrors/field_mirror.dart';
import 'mirrors/method_mirror.dart';
import 'models/constructor_info.dart';
import 'models/field_info.dart';
import 'models/method_info.dart';
import 'models/type_variable_info.dart';
import 'class.dart';

/// {@template runtime_class}
/// A runtime reflection class for dynamically handling types that may not be known at compile time.
///
/// `RuntimeClass` extends the generic `Class<Object>` and wraps a `Type` at runtime,
/// providing a consistent interface for reflective operations such as:
/// - Accessing type information
/// - Creating instances
/// - Getting the simple name of the type
///
/// This is especially useful when working with generic or dynamic types where you only
/// have access to a `Type` object (e.g., from runtime inference or dynamic decoding).
///
/// ### Use Cases:
/// - Dynamic deserialization (e.g., from JSON)
/// - Generic mapping utilities
/// - Runtime object construction
///
/// ### Example:
/// ```dart
/// final runtimeType = RuntimeClass(User);
/// print(runtimeType.type); // User
/// print(runtimeType.simpleName); // 'User'
/// ```
/// 
/// {@endtemplate}
final class RuntimeClass extends Class<Object> {
  /// Holds the runtime `Type` passed to the constructor.
  final Type _runtimeType;

  /// The dart:mirrors TypeMirror for direct reflection
  final mirrors.TypeMirror _mirror;
  
  /// The ClassMirror for direct reflection
  late final mirrors.ClassMirror _dartClassMirror;

  /// The ClassMirror for direct reflection
  late final ClassMirror _classMirror;
  
  /// Cached annotations for performance
  List<ReflectableAnnotation>? _cachedAnnotations;
  
  /// Cached methods for performance
  Map<String, ClassMethodInfo>? _cachedMethods;
  
  /// Cached fields for performance
  Map<String, ClassFieldInfo>? _cachedFields;
  
  /// Cached constructors for performance
  Map<String, ClassConstructorInfo>? _cachedConstructors;

  /// Creates a new `RuntimeClass` from the given TypeMirror.
  /// 
  /// It internally delegates to `Class.fromType(type)` to initialize the base reflection logic.
  /// 
  /// {@macro runtime_class}
  RuntimeClass(mirrors.TypeMirror mirror) 
    : _runtimeType = mirror.reflectedType, _mirror = mirror, super.fromType(mirror.reflectedType) {
    _dartClassMirror = mirrors.reflectClass(mirror.reflectedType);
    _classMirror = ClassMirror.fromDartMirror(_dartClassMirror);
  }

  /// Creates a new `RuntimeClass` from the given Type.
  /// 
  /// It internally delegates to `Class.fromType(type)` to initialize the base reflection logic.
  /// 
  /// {@macro runtime_class}
  RuntimeClass.fromType(Type type) : this(mirrors.reflectClass(type));

  @override
  Type get type => _runtimeType;

  @override
  String get simpleName => mirrors.MirrorSystem.getName(_mirror.simpleName);
  
  @override
  String get qualifiedName {
    final libraryName = mirrors.MirrorSystem.getName(_mirror.owner!.simpleName);
    return '$libraryName.$simpleName';
  }

  @override
  String get typeName => _runtimeType.toString();

  @override
  bool get isPrivate => _mirror.isPrivate;

  @override
  bool get isTopLevel => _mirror.isTopLevel;

  @override
  bool get isInterface => false;

  @override
  bool get isGeneric {
    return _mirror.typeArguments.isNotEmpty;
  }

  @override
  bool isArray() {
    // Check if this type is a List or subtype of List
    try {
      final listMirror = mirrors.reflectClass(List);
      return _mirror.isSubtypeOf(listMirror);
    } catch (e) {
      final typeString = _runtimeType.toString();
      return typeString.startsWith('List<') || typeString == 'List' || typeString.startsWith('_GrowableList<');
    }
  }

  @override
  bool isPrimitive() {
    return _runtimeType == bool || _runtimeType == int || _runtimeType == double || _runtimeType == String || _runtimeType == Null;
  }

  @override
  RuntimeClass arrayType() {
    if (!isArray()) {
      throw IllegalArgumentTypeException('$_runtimeType is not an array type.');
    }

    // Get type arguments from the ClassMirror
    final typeArgs = _mirror.typeArguments;
    if (typeArgs.isNotEmpty) {
      final elementTypeMirror = typeArgs.first;
      return RuntimeClass(elementTypeMirror);
    }

    // Fallback to Object if no type arguments
    return RuntimeClass(_mirror);
  }

  @override
  RuntimeClass? componentType() {
    if (!isArray()) {
      return null;
    }
    
    try {
      return arrayType();
    } catch (e) {
      return null;
    }
  }

  @override
  List<RuntimeClass> getTypeArguments() {
    final typeArgs = <RuntimeClass>[];
    
    for (final typeArg in _mirror.typeArguments) {
      typeArgs.add(RuntimeClass(typeArg));
    }
    
    return typeArgs;
  }

  @override
  RuntimeClass? getSuperclass() {
    final superclass = _dartClassMirror.superclass;
    if (superclass != null && superclass.reflectedType != Object) {
      return RuntimeClass(superclass);
    }
    return null;
  }

  @override
  List<RuntimeClass> getSuperinterfaces() {
    final interfaces = <RuntimeClass>[];
    
    for (final interface in _dartClassMirror.superinterfaces) {
      interfaces.add(RuntimeClass(interface));
    }
    
    return interfaces;
  }

  @override
  bool isSubclassOf(Class<Object> other) {
    if (other is RuntimeClass) {
      return _dartClassMirror.isSubclassOf(other._dartClassMirror);
    }
    
    try {
      final otherMirror = mirrors.reflectClass(other.type);
      return _dartClassMirror.isSubclassOf(otherMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isSubTypeOf<T>() {
    try {
      final targetMirror = mirrors.reflectClass(T);
      return _dartClassMirror.isSubclassOf(targetMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isAssignableFrom(Class<Object> other) {
    if (other is RuntimeClass) {
      return _dartClassMirror.isSubclassOf(other._dartClassMirror);
    }
    
    try {
      final otherMirror = mirrors.reflectClass(other.type);
      return otherMirror.isSubtypeOf(_dartClassMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  bool isInstance(Object? object) {
    if (object == null) return _runtimeType == Null;
    
    try {
      final objectMirror = mirrors.reflect(object);
      return objectMirror.type.isSubtypeOf(_dartClassMirror);
    } catch (e) {
      return false;
    }
  }

  @override
  Map<String, ClassMethodInfo> getDeclaredMethods() {
    if (_cachedMethods != null) {
      return Map.unmodifiable(_cachedMethods!);
    }

    final methods = <String, ClassMethodInfo>{};
    
    for (final declaration in _dartClassMirror.declarations.values) {
      if (declaration is mirrors.MethodMirror && !declaration.isConstructor) {
        final methodName = mirrors.MirrorSystem.getName(declaration.simpleName);
        methods[methodName] = _createMethodInfo(declaration);
      }
    }
    
    _cachedMethods = methods;
    return Map.unmodifiable(methods);
  }

  @override
  Map<String, ClassMethodInfo> getMethods() {
    final methods = <String, ClassMethodInfo>{};
    
    // Get methods from this class and all superclasses
    mirrors.ClassMirror? currentMirror = _dartClassMirror;
    
    while (currentMirror != null) {
      for (final declaration in currentMirror.declarations.values) {
        if (declaration is mirrors.MethodMirror && !declaration.isConstructor) {
          final methodName = mirrors.MirrorSystem.getName(declaration.simpleName);
          if (!methods.containsKey(methodName)) {
            methods[methodName] = _createMethodInfo(declaration);
          }
        }
      }
      currentMirror = currentMirror.superclass;
    }
    
    return methods;
  }

  @override
  ClassMethodInfo? getMethod(String name) {
    final methods = getMethods();
    return methods[name];
  }

  @override
  Map<String, ClassFieldInfo> getDeclaredFields() {
    if (_cachedFields != null) {
      return Map.unmodifiable(_cachedFields!);
    }

    final fields = <String, ClassFieldInfo>{};
    
    for (final declaration in _dartClassMirror.declarations.values) {
      if (declaration is mirrors.VariableMirror) {
        final fieldName = mirrors.MirrorSystem.getName(declaration.simpleName);
        fields[fieldName] = _createFieldInfo(declaration);
      }
    }
    
    _cachedFields = fields;
    return Map.unmodifiable(fields);
  }

  @override
  Map<String, ClassFieldInfo> getFields() {
    final fields = <String, ClassFieldInfo>{};
    
    // Get fields from this class and all superclasses
    mirrors.ClassMirror? currentMirror = _dartClassMirror;
    
    while (currentMirror != null) {
      for (final declaration in currentMirror.declarations.values) {
        if (declaration is mirrors.VariableMirror) {
          final fieldName = mirrors.MirrorSystem.getName(declaration.simpleName);
          if (!fields.containsKey(fieldName)) {
            fields[fieldName] = _createFieldInfo(declaration);
          }
        }
      }
      currentMirror = currentMirror.superclass;
    }
    
    return fields;
  }

  @override
  ClassFieldInfo? getField(String name) {
    final fields = getFields();
    return fields[name];
  }

  @override
  Map<String, ClassConstructorInfo> getConstructors() {
    if (_cachedConstructors != null) {
      return Map.unmodifiable(_cachedConstructors!);
    }

    final constructors = <String, ClassConstructorInfo>{};
    
    for (final declaration in _dartClassMirror.declarations.values) {
      if (declaration is mirrors.MethodMirror && declaration.isConstructor) {
        final constructorName = mirrors.MirrorSystem.getName(declaration.constructorName);
        final key = constructorName.isEmpty ? 'default' : constructorName;
        constructors[key] = _createConstructorInfo(declaration);
      }
    }
    
    _cachedConstructors = constructors;
    return Map.unmodifiable(constructors);
  }

  @override
  ClassConstructorInfo? getConstructor([String name = '']) {
    final constructors = getConstructors();
    final key = name.isEmpty ? 'default' : name;
    return constructors[key];
  }

  @override
  Object newInstance([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _classMirror.newInstance(positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Object newInstanceWithFields(Map<String, Object?> fieldValues) => _classMirror.newInstanceWithFields(fieldValues);

  @override
  Object newInstanceNamed(String constructorName, [List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _classMirror.newInstanceNamed(constructorName, positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  // Annotation methods
  @override
  List<ReflectableAnnotation> getAnnotations() {
    if (_cachedAnnotations != null) {
      return _cachedAnnotations!;
    }
    
    final annotations = <ReflectableAnnotation>[];
    
    for (final metadata in _dartClassMirror.metadata) {
      final annotation = metadata.reflectee;
      if (annotation is ReflectableAnnotation) {
        annotations.add(annotation);
      }
    }
    
    _cachedAnnotations = annotations;
    return annotations;
  }

  @override
  bool hasAnnotation<A extends ReflectableAnnotation>() {
    return getAnnotations().any((annotation) => annotation is A);
  }

  @override
  A? getAnnotationByType<A extends ReflectableAnnotation>() {
    for (final annotation in getAnnotations()) {
      if (annotation is A) {
        return annotation;
      }
    }
    return null;
  }

  @override
  String descriptorString() {
    if (isPrimitive()) {
      switch (_runtimeType) {
        case const (bool): return 'Z';
        case const (int): return 'I';
        case const (double): return 'D';
        case const (String): return 'Ljava/lang/String;';
        case const (Null): return 'V';
        default: return 'V';
      }
    }

    if (isArray()) {
      final component = componentType();
      return '[${component?.descriptorString() ?? 'Ljava/lang/Object;'}';
    }

    return 'L${qualifiedName.replaceAll('.', '/')};';
  }

  // Helper methods to create info objects
  ClassMethodInfo _createMethodInfo(mirrors.MethodMirror methodMirror) {
    return ClassMethodInfo.fromJetMirror(MethodMirror.fromDartMirror(methodMirror));
  }

  ClassFieldInfo _createFieldInfo(mirrors.VariableMirror fieldMirror) {
    return ClassFieldInfo.fromJetMirror(FieldMirror.fromDartMirror(fieldMirror));
  }

  ClassConstructorInfo _createConstructorInfo(mirrors.MethodMirror constructorMirror) {
    return ClassConstructorInfo.fromJetMirror(ConstructorMirror.fromDartMirror(constructorMirror));
  }

  @override
  List<ClassTypeVariableInfo> getTypeVariables() {
    final typeVariables = <ClassTypeVariableInfo>[];
    
    for (final typeVariable in _dartClassMirror.typeVariables) {
      typeVariables.add(ClassTypeVariableInfo(
        name: mirrors.MirrorSystem.getName(typeVariable.simpleName),
        qualifiedName: mirrors.MirrorSystem.getName(typeVariable.qualifiedName),
        upperBound: Class<Object>.fromObject(typeVariable.upperBound),
        annotations: typeVariable.metadata.map((m) => m.reflectee).whereType<ReflectableAnnotation>().toList(),
      ));
    }
    
    return typeVariables;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RuntimeClass && other._runtimeType == _runtimeType;
  }

  @override
  int get hashCode => _runtimeType.hashCode;

  @override
  String toString() => 'RuntimeClass<$_runtimeType>';

  /// Clears all cached data for this RuntimeClass instance.
  @override
  void clearCache() {
    _cachedAnnotations = null;
    _cachedMethods = null;
    _cachedFields = null;
    _cachedConstructors = null;
  }
}