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

import 'package:meta/meta.dart';

import '../exceptions.dart';
import '../interfaces/annotated_element.dart';
import '../interfaces/annotation.dart';
import '../interfaces/reflectable_annotation.dart';
import 'constructor_mirror.dart';
import 'field_mirror.dart';
import 'method_mirror.dart';

/// A mirror on a Dart class, providing comprehensive reflection capabilities.
/// 
/// ClassMirror provides access to information about a class including its
/// annotations, methods, fields, constructors, and type hierarchy. It serves
/// as the primary entry point for class-level reflection operations.
/// 
/// This class is designed to be type-safe while providing powerful reflection
/// capabilities similar to Java's Class<?> but adapted for Dart's type system.
/// 
/// **Type Parameters:**
/// - [T]: The type of the class being reflected
/// 
/// **Example:**
/// ```dart
/// @Entity('users')
/// class User {
///   String name;
///   int age;
///   User(this.name, this.age);
/// }
/// 
/// final userClass = ClassMirror.forType<User>();
/// print(userClass.getSimpleName()); // 'User'
/// print(userClass.isAnnotationPresent(ClassMirror.forType<Entity>())); // true
/// 
/// final user = userClass.newInstance(['John', 25]);
/// print(user.name); // 'John'
/// ```
class ClassMirror<T> extends Annotation implements AnnotatedElement {
  /// The underlying Dart ClassMirror from dart:mirrors
  @protected
  final mirrors.ClassMirror _mirror;

  /// Cache for annotations to improve performance
  @protected
  List<ReflectableAnnotation>? _annotationCache;

  /// Cache for methods to improve performance
  @protected
  Map<String, MethodMirror>? _methodCache;

  /// Cache for fields to improve performance
  @protected
  Map<String, FieldMirror>? _fieldCache;

  /// Cache for constructors to improve performance
  @protected
  Map<String, ConstructorMirror>? _constructorCache;

  /// Creates a ClassMirror from a dart:mirrors ClassMirror.
  /// 
  /// This is a private constructor that is used by the factory method
  /// [fromDartMirror].
  /// 
  /// **Parameters:**
  /// - [mirror]: The underlying ClassMirror from dart:mirrors
  ClassMirror(this._mirror);

  /// Creates a ClassMirror from a dart:mirrors ClassMirror.
  /// 
  /// **Parameters:**
  /// - [mirror]: The underlying ClassMirror from dart:mirrors
  /// 
  /// **Returns:** A ClassMirror reflecting the specified type
  factory ClassMirror.fromDartMirror(mirrors.ClassMirror mirror) {
    return ClassMirror(mirror);
  }

  /// Creates a ClassMirror for the specified type.
  /// 
  /// This is the primary factory method for creating ClassMirror instances.
  /// It uses Dart's reflection system to obtain information about the type T.
  /// 
  /// **Type Parameters:**
  /// - [U]: The type to create a mirror for
  /// 
  /// **Returns:** A ClassMirror reflecting the specified type
  /// 
  /// **Throws:**
  /// - [ClassInstantiationException] if the type cannot be reflected
  /// 
  /// **Example:**
  /// ```dart
  /// final stringClass = ClassMirror.forType<String>();
  /// final listClass = ClassMirror.forType<List<int>>();
  /// ```
  static ClassMirror<U> forType<U>() {
    try {
      final mirror = mirrors.reflectClass(U);
      return ClassMirror<U>(mirror);
    } catch (e) {
      throw ClassInstantiationException('Cannot create ClassMirror for type $U: $e');
    }
  }

  /// Creates a ClassMirror from a Type object.
  /// 
  /// This method allows creating ClassMirror instances when you have a Type
  /// object at runtime but don't know the compile-time generic parameter.
  /// 
  /// **Parameters:**
  /// - [type]: The Type object to create a mirror for
  /// 
  /// **Returns:** A ClassMirror reflecting the specified type
  /// 
  /// **Throws:**
  /// - [ClassInstantiationException] if the type cannot be reflected
  static ClassMirror<Type> forTypeObject(Type type) {
    try {
      final mirror = mirrors.reflectClass(type);
      return ClassMirror<Type>(mirror);
    } catch (e) {
      throw ClassInstantiationException('Cannot create ClassMirror for type $type: $e');
    }
  }

  /// Creates a ClassMirror for an object instance.
  /// 
  /// This method creates a ClassMirror for the runtime type of the given object.
  /// 
  /// **Parameters:**
  /// - [object]: The object to get the class mirror for
  /// 
  /// **Returns:** A ClassMirror reflecting the runtime type of the object
  /// 
  /// **Throws:**
  /// - [ClassInstantiationException] if the object is null or cannot be reflected
  static ClassMirror<Object> forObject(Object object) {
    try {
      final instanceMirror = mirrors.reflect(object);
      return ClassMirror<Object>(instanceMirror.type);
    } catch (e) {
      throw ClassInstantiationException('Cannot create ClassMirror for object $object: $e');
    }
  }

  // ========== Basic Class Information ==========

  /// Returns the simple name of the underlying class.
  /// 
  /// The simple name is the name of the class without any package or
  /// library qualifiers. For example, the simple name of 'dart:core.String'
  /// is 'String'.
  /// 
  /// **Returns:** The simple name of the underlying class
  String getSimpleName() => mirrors.MirrorSystem.getName(_mirror.simpleName);

  /// Returns the canonical name of the underlying class.
  /// 
  /// The canonical name is the fully qualified name of the class,
  /// including package and library information.
  /// 
  /// **Returns:** The canonical name of the underlying class
  String getCanonicalName() => mirrors.MirrorSystem.getName(_mirror.qualifiedName);

  /// Returns the name of the underlying class.
  /// 
  /// This is an alias for [getCanonicalName] for consistency with Java's API.
  /// 
  /// **Returns:** The name of the underlying class
  String getName() => getCanonicalName();

  /// Returns the Type object that represents this class.
  /// 
  /// **Returns:** The Type object representing this class
  Type getType() {
    if (_mirror.hasReflectedType) {
      return _mirror.reflectedType;
    }
    throw UnsupportedError('Type not available for this mirror');
  }

  /// Determines if this Class object represents an abstract class.
  /// 
  /// **Returns:** true if this class is abstract, false otherwise
  bool isAbstract() => _mirror.isAbstract;

  /// Determines if this Class object represents an enum type.
  /// 
  /// **Returns:** true if this class is an enum, false otherwise
  bool isEnum() => _mirror.isEnum;

  /// Determines if this Class object represents a private class.
  /// 
  /// In Dart, a class is considered private if its name starts with an underscore.
  /// 
  /// **Returns:** true if this class is private, false otherwise
  bool isPrivate() => _mirror.isPrivate;

  /// Determines if this Class object represents an interface.
  /// 
  /// In Dart, this typically means the class is abstract and has no implementation.
  /// 
  /// **Returns:** true if this class represents an interface, false otherwise
  bool isInterface() {
    return _mirror.isAbstract && _mirror.declarations.values
      .whereType<mirrors.MethodMirror>()
      .where((m) => !m.isConstructor && !m.isStatic)
      .every((m) => m.isAbstract);
  }

  // ========== Type Hierarchy ==========

  /// Returns the ClassMirror representing the direct superclass of this class.
  /// 
  /// If this class represents Object, an interface, a primitive type, or void,
  /// then null is returned. If this class represents an array class then the
  /// ClassMirror object representing class Object is returned.
  /// 
  /// **Returns:** The direct superclass of this class, or null if none exists
  ClassMirror<Object>? getSuperclass() {
    final superclass = _mirror.superclass;
    return superclass != null ? ClassMirror<Object>(superclass) : null;
  }

  /// Returns the ClassMirror representing the direct superclass of this class.
  /// 
  /// **Returns:** The direct superclass of this class, or null if none exists
  ClassMirror<U>? getSuperClass<U>() {
    final superclass = _mirror.superclass;
    return superclass != null ? ClassMirror<U>(superclass) : null;
  }

  /// Returns the ClassMirrors representing the direct superinterfaces of this class.
  /// 
  /// If this class represents a class, then the return value is a list
  /// containing objects representing all interfaces directly implemented by the class.
  /// 
  /// **Returns:** A list of ClassMirrors representing the direct superinterfaces
  List<ClassMirror<Object>> getInterfaces() {
    return _mirror.superinterfaces.map((interface) => ClassMirror<Object>(interface)).toList();
  }

  /// Determines if this Class object represents a subclass of the specified class.
  /// 
  /// **Parameters:**
  /// - [cls]: The ClassMirror object to be checked
  /// 
  /// **Returns:** true if this class is a subclass of the specified class
  bool isSubclassOf<U>(ClassMirror<U> cls) {
    return _mirror.isSubclassOf(cls._mirror);
  }

  /// Determines if the class or interface represented by this Class object
  /// is either the same as, or is a superclass or superinterface of, the
  /// class or interface represented by the specified Class parameter.
  /// 
  /// **Parameters:**
  /// - [cls]: The ClassMirror object to be checked
  /// 
  /// **Returns:** true if this class is assignable from the specified class
  bool isAssignableFrom<u>(ClassMirror<u> cls) {
    return cls._mirror.isAssignableTo(_mirror);
  }

  /// Determines if the specified Object is assignment-compatible with the
  /// object represented by this Class.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to check
  /// 
  /// **Returns:** true if obj is an instance of this class
  bool isInstance(Object? obj) {
    if (obj == null) return false;
    try {
      final objMirror = mirrors.reflect(obj);
      return objMirror.type.isSubtypeOf(_mirror);
    } catch (e) {
      return false;
    }
  }

  // ========== Method Access ==========
  
  /// Returns a MethodMirror object that reflects the specified public member
  /// method of the class or interface represented by this Class object.
  /// 
  /// **Parameters:**
  /// - [name]: The name of the method
  /// - [parameterTypes]: The list of parameter types (optional for overload resolution)
  /// 
  /// **Returns:** The MethodMirror object for the specified method
  /// 
  /// **Throws:**
  /// - [NoSuchClassMethodException] if a matching method is not found
  MethodMirror getMethod(String name, [List<ClassMirror<Object>>? parameterTypes]) {
    final methods = getMethods();
    final method = methods[name];
    
    if (method == null) {
      throw NoSuchClassMethodException(name, getSimpleName());
    }
    
    // If parameter types are specified, check for exact match
    if (parameterTypes != null) {
      final methodParamTypes = method.getParameterTypes();
      if (methodParamTypes.length != parameterTypes.length) {
        throw NoSuchClassMethodException(name, getSimpleName());
      }
      
      for (int i = 0; i < parameterTypes.length; i++) {
        if (methodParamTypes[i] != parameterTypes[i]) {
          throw NoSuchClassMethodException(name, getSimpleName());
        }
      }
    }
    
    return method;
  }
  
  /// Returns a Map containing MethodMirror objects reflecting all the public
  /// methods of the class or interface represented by this Class object.
  /// 
  /// **Returns:** A Map of method names to MethodMirror objects
  Map<String, MethodMirror> getMethods() {
    if (_methodCache != null) {
      return Map.unmodifiable(_methodCache!);
    }
    
    final methods = <String, MethodMirror>{};
    
    // Add instance methods
    for (final entry in _mirror.instanceMembers.entries) {
      final methodMirror = entry.value;
      if (!methodMirror.isConstructor) {
        final name = mirrors.MirrorSystem.getName(entry.key);
        methods[name] = MethodMirror.fromDartMirror(methodMirror);
      }
    }
    
    // Add static methods
    for (final entry in _mirror.staticMembers.entries) {
      final methodMirror = entry.value;
      if (!methodMirror.isConstructor) {
        final name = mirrors.MirrorSystem.getName(entry.key);
        methods[name] = MethodMirror.fromDartMirror(methodMirror);
      }
    }
    
    _methodCache = methods;
    return Map.unmodifiable(methods);
  }
  
  /// Returns a Map containing MethodMirror objects reflecting all the methods
  /// declared by the class or interface represented by this Class object.
  /// 
  /// This includes public, protected, default (package) access, and private
  /// methods, but excludes inherited methods.
  /// 
  /// **Returns:** A Map of method names to MethodMirror objects
  Map<String, MethodMirror> getDeclaredMethods() {
    final methods = <String, MethodMirror>{};
    
    for (final entry in _mirror.declarations.entries) {
      final declaration = entry.value;
      if (declaration is mirrors.MethodMirror && !declaration.isConstructor) {
        final name = mirrors.MirrorSystem.getName(entry.key);
        methods[name] = MethodMirror.fromDartMirror(declaration);
      }
    }
    
    return methods;
  }
  
  // ========== Field Access ==========
  
  /// Returns a FieldMirror object that reflects the specified public member
  /// field of the class or interface represented by this Class object.
  /// 
  /// **Parameters:**
  /// - [name]: The name of the field
  /// 
  /// **Returns:** The FieldMirror object for the specified field
  /// 
  /// **Throws:**
  /// - [NoSuchFieldException] if a field with the specified name is not found
  FieldMirror getField(String name) {
    final fields = getFields();
    final field = fields[name];
    
    if (field == null) {
      throw NoSuchFieldException(name, getSimpleName());
    }
    
    return field;
  }
  
  /// Returns a Map containing FieldMirror objects reflecting all the accessible
  /// public fields of the class or interface represented by this Class object.
  /// 
  /// **Returns:** A Map of field names to FieldMirror objects
  Map<String, FieldMirror> getFields() {
    if (_fieldCache != null) {
      return Map.unmodifiable(_fieldCache!);
    }
    
    final fields = <String, FieldMirror>{};
    
    // Get all variable declarations
    for (final entry in _mirror.declarations.entries) {
      final declaration = entry.value;
      if (declaration is mirrors.VariableMirror) {
        final name = mirrors.MirrorSystem.getName(entry.key);
        fields[name] = FieldMirror.fromDartMirror(declaration);
      }
    }
    
    _fieldCache = fields;
    return Map.unmodifiable(fields);
  }
  
  /// Returns a Map containing FieldMirror objects reflecting all the fields
  /// declared by the class or interface represented by this Class object.
  /// 
  /// This includes public, protected, default (package) access, and private
  /// fields, but excludes inherited fields.
  /// 
  /// **Returns:** A Map of field names to FieldMirror objects
  Map<String, FieldMirror> getDeclaredFields() {
    return getFields(); // In Dart, declared fields are the same as all fields
  }
  
  // ========== Constructor Access ==========
  
  /// Returns a ConstructorMirror object that reflects the specified public
  /// constructor of the class represented by this Class object.
  /// 
  /// **Parameters:**
  /// - [name]: The name of the constructor (empty string for default constructor)
  /// - [parameterTypes]: The list of parameter types (optional for overload resolution)
  /// 
  /// **Returns:** The ConstructorMirror object for the specified constructor
  /// 
  /// **Throws:**
  /// - [NoSuchClassMethodException] if a matching constructor is not found
  ConstructorMirror getConstructor([String name = '', List<ClassMirror<Object>>? parameterTypes]) {
    final constructors = getConstructors();
    final constructorKey = name.isEmpty ? 'default' : name;
    final constructor = constructors[constructorKey];
    
    if (constructor == null) {
      throw NoSuchClassMethodException(name.isEmpty ? '<init>' : name, getSimpleName());
    }
    
    // If parameter types are specified, check for exact match
    if (parameterTypes != null) {
      final constructorParamTypes = constructor.getParameterTypes();
      if (constructorParamTypes.length != parameterTypes.length) {
        throw NoSuchClassMethodException(name.isEmpty ? '<init>' : name, getSimpleName());
      }
      
      for (int i = 0; i < parameterTypes.length; i++) {
        if (constructorParamTypes[i] != parameterTypes[i]) {
          throw NoSuchClassMethodException(name.isEmpty ? '<init>' : name, getSimpleName());
        }
      }
    }
    
    return constructor;
  }
  
  /// Returns a Map containing ConstructorMirror objects reflecting all the
  /// public constructors of the class represented by this Class object.
  /// 
  /// **Returns:** A Map of constructor names to ConstructorMirror objects
  Map<String, ConstructorMirror> getConstructors() {
    if (_constructorCache != null) {
      return Map.unmodifiable(_constructorCache!);
    }
    
    final constructors = <String, ConstructorMirror>{};
    
    for (final entry in _mirror.declarations.entries) {
      final declaration = entry.value;
      if (declaration is mirrors.MethodMirror && declaration.isConstructor) {
        final constructorName = mirrors.MirrorSystem.getName(declaration.constructorName);
        final key = constructorName.isEmpty ? 'default' : constructorName;
        constructors[key] = ConstructorMirror.fromDartMirror(declaration);
      }
    }
    
    _constructorCache = constructors;
    return Map.unmodifiable(constructors);
  }
  
  /// Returns a Map containing ConstructorMirror objects reflecting all the
  /// constructors declared by the class represented by this Class object.
  /// 
  /// **Returns:** A Map of constructor names to ConstructorMirror objects
  Map<String, ConstructorMirror> getDeclaredConstructors() {
    return getConstructors(); // In Dart, declared constructors are the same as all constructors
  }
  
  // ========== Instance Creation ==========
  
  /// Creates a new instance of the class represented by this Class object.
  /// 
  /// The class is instantiated as if by a new expression with an empty
  /// argument list. The class is initialized if it has not already been initialized.
  /// 
  /// **Returns:** A newly allocated instance of the class represented by this object
  /// 
  /// **Throws:**
  /// - [ClassInstantiationException] if this Class represents an abstract class,
  ///   an interface, an array class, a primitive type, or void
  /// - [IllegalTypeAccessException] if the class or its nullary constructor is not accessible
  T newInstance([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (isAbstract()) {
      throw AbstractClassInstantiationException(getSimpleName());
    }
    
    try {
      final instanceMirror = _mirror.newInstance(Symbol(''), positionalArgs, namedArgs);
      return instanceMirror.reflectee as T;
    } catch (e) {
      if (e is NoSuchMethodError) {
        throw NoSuchClassMethodException('<init>', getSimpleName());
      }
      throw ClassInstantiationException(getSimpleName());
    }
  }
  
  /// Creates a new instance using a named constructor.
  /// 
  /// **Parameters:**
  /// - [constructorName]: The name of the constructor to use
  /// - [positionalArgs]: Positional arguments for the constructor
  /// - [namedArgs]: Named arguments for the constructor
  /// 
  /// **Returns:** A newly allocated instance of the class
  /// 
  /// **Throws:**
  /// - [NoSuchClassMethodException] if the specified constructor doesn't exist
  /// - [ClassInstantiationException] if the instance cannot be created
  T newInstanceNamed(String constructorName, [List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (isAbstract()) {
      throw AbstractClassInstantiationException(getSimpleName());
    }
    
    try {
      final instanceMirror = _mirror.newInstance(Symbol(constructorName), positionalArgs, namedArgs);
      return instanceMirror.reflectee as T;
    } catch (e) {
      if (e is NoSuchMethodError) {
        throw NoSuchClassMethodException(constructorName, getSimpleName());
      }
      throw ClassInstantiationException(getSimpleName());
    }
  }

  /// Creates a new instance of the class using field values.
  /// 
  /// **Parameters:**
  /// - [fieldValues]: A map of field names to values
  /// 
  /// **Returns:** A newly allocated instance of the class
  /// 
  /// **Throws:**
  /// - [ClassInstantiationException] if the instance cannot be created
  T newInstanceWithFields(Map<String, Object?> fieldValues) {
    if (isAbstract()) {
      throw AbstractClassInstantiationException(getSimpleName());
    }
    
    try {
      final instanceMirror = _mirror.newInstance(Symbol(''), [], fieldValues.map((key, value) => MapEntry(Symbol(key), value)));
      return instanceMirror.reflectee as T;
    } catch (e) {
      throw ClassInstantiationException(getSimpleName());
    }
  }
  
  // ========== Utility Methods ==========
  
  /// Casts an object to the class or interface represented by this Class object.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to be cast
  /// 
  /// **Returns:** The object after casting, or null if obj is null
  /// 
  /// **Throws:**
  /// - [TypeError] if the object cannot be cast to this type
  T? cast(Object? obj) {
    if (obj == null) return null;
    if (isInstance(obj)) {
      return obj as T;
    }
    throw TypeError();
  }

  /// Returns the underlying dart:mirrors ClassMirror.
  /// 
  /// This method provides access to the underlying Dart mirror for advanced
  /// use cases that require direct access to dart:mirrors functionality.
  /// 
  /// **Returns:** The underlying ClassMirror
  mirrors.ClassMirror get dartMirror => _mirror;

  // ========== Annotation Methods ==========

  @override
  bool isAnnotationPresent<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return getAnnotation(annotationType) != null;
  }

  @override
  A? getAnnotation<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    final annotations = getAnnotations();
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        return annotation as A;
      }
    }
    return null;
  }

  @override
  List<ReflectableAnnotation> getAnnotations() {
    if (_annotationCache != null) {
      return List.unmodifiable(_annotationCache!);
    }

    final annotations = <ReflectableAnnotation>[];
    for (final instanceMirror in _mirror.metadata) {
      if (instanceMirror.hasReflectee) {
        final reflectee = instanceMirror.reflectee;
        if (reflectee is ReflectableAnnotation) {
          annotations.add(reflectee);
        }
      }
    }

    _annotationCache = annotations;
    return List.unmodifiable(annotations);
  }

  @override
  List<A> getAnnotationsByType<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    final annotations = getAnnotations();
    final result = <A>[];
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        result.add(annotation as A);
      }
    }
    return result;
  }

  @override
  List<ReflectableAnnotation> getDeclaredAnnotations() {
    // In Dart, declared annotations are the same as all annotations
    // since annotation inheritance is not supported
    return getAnnotations();
  }

  @override
  List<A> getDeclaredAnnotationsByType<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return getAnnotationsByType(annotationType);
  }

  @override
  A? getDeclaredAnnotation<A extends ReflectableAnnotation>(ClassMirror<A> annotationType) {
    return getAnnotation(annotationType);
  }

  // ========== Object Methods ==========

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassMirror && other._mirror == _mirror;
  }

  @override
  int get hashCode => _mirror.hashCode;

  @override
  String toString() => 'ClassMirror<$T>(${getSimpleName()})';

  @override
  bool equals(Object other) {
    return this == other;
  }

  @override
  bool hasAnnotation<U extends ReflectableAnnotation>() {
    return getAnnotation<U>(ClassMirror.forType<U>()) != null;
  }
}