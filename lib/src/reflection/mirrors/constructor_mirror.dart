import 'dart:mirrors' as mirrors;

import '../exceptions.dart';
import '../interfaces/executable.dart';
import 'parameter_mirror.dart';
import '../interfaces/reflectable_annotation.dart';
import 'class_mirror.dart';

/// A mirror on a constructor, providing comprehensive reflection capabilities for constructors.
/// 
/// ConstructorMirror represents a single constructor on a class and provides
/// access to information about the constructor including its parameters,
/// annotations, and the ability to create new instances.
/// 
/// This class provides type-safe constructor reflection similar to Java's Constructor class
/// but adapted for Dart's constructor system including named constructors and factory constructors.
/// 
/// **Example:**
/// ```dart
/// class Person {
///   String name;
///   int age;
///   
///   Person(this.name, this.age);
///   
///   Person.withAge(this.age) : name = 'Unknown';
///   
///   factory Person.fromJson(Map<String, dynamic> json) {
///     return Person(json['name'], json['age']);
///   }
/// }
/// 
/// final personClass = ClassMirror.forType<Person>();
/// final defaultConstructor = personClass.getConstructor();
/// final namedConstructor = personClass.getConstructor('withAge');
/// 
/// print(defaultConstructor.getName()); // ''
/// print(namedConstructor.getName()); // 'withAge'
/// print(defaultConstructor.getParameterCount()); // 2
/// 
/// final person = defaultConstructor.newInstance(['John', 25]);
/// print(person.name); // 'John'
/// ```
class ConstructorMirror extends Executable {
  /// The underlying Dart MethodMirror from dart:mirrors (constructors are methods in Dart)
  final mirrors.MethodMirror _mirror;
  
  /// Cache for parameters to improve performance
  List<ParameterMirror>? _parameterCache;
  
  /// Cache for annotations to improve performance
  List<ReflectableAnnotation>? _annotationCache;
  
  /// Creates a ConstructorMirror from a dart:mirrors MethodMirror.
  /// 
  /// **Parameters:**
  /// - [mirror]: The underlying MethodMirror from dart:mirrors representing a constructor
  ConstructorMirror._(this._mirror) {
    if (!_mirror.isConstructor) {
      throw NoSuchConstructorException(_mirror.constructorName.toString(), _mirror.owner?.simpleName.toString() ?? '');
    }
  }
  
  /// Creates a ConstructorMirror from a dart:mirrors MethodMirror.
  /// 
  /// This is the primary factory method for creating ConstructorMirror instances
  /// from the underlying Dart mirror system.
  /// 
  /// **Parameters:**
  /// - [mirror]: The dart:mirrors MethodMirror to wrap (must be a constructor)
  /// 
  /// **Returns:** A new ConstructorMirror instance
  /// 
  /// **Throws:**
  /// - [NoSuchConstructorException] if the mirror is null, invalid, or doesn't represent a constructor
  static ConstructorMirror fromDartMirror(mirrors.MethodMirror mirror) {
    return ConstructorMirror._(mirror);
  }
  
  // ========== Basic Constructor Information ==========
  
  @override
  String getName() {
    final constructorName = mirrors.MirrorSystem.getName(_mirror.constructorName);
    return constructorName; // Empty string for default constructor
  }
  
  /// Returns the simple name of the constructor.
  /// 
  /// For the default constructor, this returns an empty string.
  /// For named constructors, this returns the constructor name.
  /// 
  /// **Returns:** The simple name of the constructor
  String getSimpleName() => getName();
  
  /// Returns the qualified name of the constructor.
  /// 
  /// The qualified name includes the declaring class name and constructor name.
  /// 
  /// **Returns:** The qualified name of the constructor
  String getQualifiedName() {
    final className = getDeclaringClass().getSimpleName();
    final constructorName = getName();
    return constructorName.isEmpty ? className : '$className.$constructorName';
  }
  
  @override
  ClassMirror<Object> getDeclaringClass() {
    final owner = _mirror.owner;
    if (owner is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(owner);
    }
    throw ClassInstantiationException(owner?.simpleName.toString() ?? '');
  }
  
  @override
  int getModifiers() {
    int modifiers = 0;
    if (isPrivate()) modifiers |= 0x0002; // PRIVATE
    if (isConst()) modifiers |= 0x1000; // Custom flag for const
    return modifiers;
  }
  
  // ========== Constructor Type Checks ==========
  
  /// Returns true if this constructor is const.
  /// 
  /// **Returns:** true if this constructor is const, false otherwise
  bool isConst() => _mirror.isConstConstructor;
  
  /// Returns true if this constructor is a factory constructor.
  /// 
  /// **Returns:** true if this constructor is a factory constructor, false otherwise
  bool isFactory() => _mirror.isFactoryConstructor;
  
  /// Returns true if this constructor is a generative constructor.
  /// 
  /// **Returns:** true if this constructor is a generative constructor, false otherwise
  bool isGenerative() => _mirror.isGenerativeConstructor;
  
  /// Returns true if this constructor is a redirecting constructor.
  /// 
  /// **Returns:** true if this constructor is a redirecting constructor, false otherwise
  bool isRedirecting() => _mirror.isRedirectingConstructor;
  
  @override
  bool isSynthetic() => _mirror.isSynthetic;
  
  /// Returns true if this constructor is private.
  /// 
  /// In Dart, a constructor is private if its name starts with an underscore.
  /// 
  /// **Returns:** true if this constructor is private, false otherwise
  bool isPrivate() => _mirror.isPrivate;
  
  @override
  bool isPrivateAccess() => isPrivate();
  
  /// Returns true if this is the default (unnamed) constructor.
  /// 
  /// **Returns:** true if this is the default constructor, false otherwise
  bool isDefault() => getName().isEmpty;
  
  // ========== Parameter Information ==========
  
  @override
  List<ParameterMirror> getParameters() {
    if (_parameterCache != null) {
      return List.unmodifiable(_parameterCache!);
    }
    
    final parameters = _mirror.parameters
        .map((param) => ParameterMirror.fromDartMirror(param))
        .toList();
    
    _parameterCache = parameters;
    return List.unmodifiable(parameters);
  }
  
  @override
  int getParameterCount() => _mirror.parameters.length;
  
  @override
  List<ClassMirror<Object>> getParameterTypes() {
    return getParameters()
        .map((param) => param.getType())
        .toList();
  }
  
  @override
  List<ClassMirror<Object>> getGenericParameterTypes() {
    // In Dart, generic parameter types are the same as parameter types
    return getParameterTypes();
  }
  
  @override
  bool isVarArgs() {
    // Dart doesn't have varargs in the same way as Java
    // Check if the last parameter is optional positional
    final params = _mirror.parameters;
    return params.isNotEmpty && params.last.isOptional && !params.last.isNamed;
  }
  
  // ========== Exception Information ==========
  
  @override
  List<ClassMirror<Exception>> getExceptionTypes() {
    // Dart doesn't have checked exceptions like Java
    // Return empty list for compatibility
    return [];
  }
  
  // ========== Annotation Methods ==========
  
  @override
  bool isAnnotationPresent<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotation(annotationType) != null;
  }
  
  @override
  T? getAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    final annotations = getAnnotations();
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        return annotation as T;
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
  List<T> getAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    final annotations = getAnnotations();
    final result = <T>[];
    
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        result.add(annotation as T);
      }
    }
    
    return result;
  }
  
  @override
  List<ReflectableAnnotation> getDeclaredAnnotations() {
    return getAnnotations();
  }
  
  @override
  List<T> getDeclaredAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotationsByType(annotationType);
  }
  
  @override
  T? getDeclaredAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotation(annotationType);
  }
  
  // ========== Instance Creation ==========
  
  /// Uses the constructor represented by this ConstructorMirror object to create
  /// and initialize a new instance of the constructor's declaring class.
  /// 
  /// **Parameters:**
  /// - [args]: Array of objects to be passed as arguments to the constructor call
  /// - [namedArgs]: Map of named arguments to be passed to the constructor call
  /// 
  /// **Returns:** A new object created by calling the constructor this object represents
  /// 
  /// **Throws:**
  /// - [IllegalTypeAccessException] if this Constructor object is enforcing access control
  /// - [IllegalArgumentTypeException] if the number of actual and formal parameters differ
  /// - [ClassInstantiationException] if the class that declares the underlying constructor
  ///   represents an abstract class
  T newInstance<T>([List<Object?> args = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (!canAccess()) {
      throw IllegalTypeAccessException(getQualifiedName());
    }
    
    final declaringClass = getDeclaringClass();
    if (declaringClass.isAbstract()) {
      throw AbstractClassInstantiationException(declaringClass.getSimpleName());
    }
    
    try {
      final classMirror = _mirror.owner as mirrors.ClassMirror;
      final constructorSymbol = _mirror.constructorName;
      final result = classMirror.newInstance(constructorSymbol, args, namedArgs);
      return result.reflectee;
    } catch (e) {
      if (e is NoSuchMethodError) {
        throw NoSuchClassMethodException(getQualifiedName(), declaringClass.getSimpleName());
      }
      if (e is NoSuchConstructorException) {
        throw IllegalArgumentTypeException('Invalid arguments for constructor ${getQualifiedName()}: $e');
      }
      throw ClassInstantiationException(declaringClass.getSimpleName());
    }
  }
  
  /// Creates a new instance with type safety.
  /// 
  /// This is a generic version of [newInstance] that provides compile-time
  /// type safety for the return value.
  /// 
  /// **Type Parameters:**
  /// - [T]: The expected return type
  /// 
  /// **Parameters:**
  /// - [args]: Array of objects to be passed as arguments to the constructor call
  /// - [namedArgs]: Map of named arguments to be passed to the constructor call
  /// 
  /// **Returns:** A new object of type T created by calling the constructor
  T newInstanceTyped<T>([List<Object?> args = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    final instance = newInstance(args, namedArgs);
    if (instance is T) {
      return instance;
    }

    throw TypeError();
  }
  
  // ========== String Representation ==========
  
  @override
  String toGenericString() {
    final buffer = StringBuffer();
    
    // Add modifiers
    if (isConst()) buffer.write('const ');
    if (isFactory()) buffer.write('factory ');
    
    // Add declaring class and constructor name
    final className = getDeclaringClass().getSimpleName();
    final constructorName = getName();
    if (constructorName.isEmpty) {
      buffer.write(className);
    } else {
      buffer.write('$className.$constructorName');
    }
    
    // Add parameters
    buffer.write('(');
    final params = getParameters();
    for (int i = 0; i < params.length; i++) {
      if (i > 0) buffer.write(', ');
      buffer.write('${params[i].getType().getSimpleName()} ${params[i].getName()}');
    }
    buffer.write(')');
    
    return buffer.toString();
  }
  
  /// Returns the underlying dart:mirrors MethodMirror.
  /// 
  /// This method provides access to the underlying Dart mirror for advanced
  /// use cases that require direct access to dart:mirrors functionality.
  /// 
  /// **Returns:** The underlying MethodMirror
  mirrors.MethodMirror get dartMirror => _mirror;
  
  // ========== Object Methods ==========
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConstructorMirror && other._mirror == _mirror;
  }
  
  @override
  int get hashCode => _mirror.hashCode;
  
  @override
  String toString() => 'ConstructorMirror(${getQualifiedName()})';
}