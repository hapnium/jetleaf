import 'dart:mirrors' as mirrors;

import '../exceptions.dart';
import '../interfaces/annotated_element.dart';
import '../interfaces/reflectable_annotation.dart';
import 'class_mirror.dart';

/// {@template parameterMirror}
/// A mirror on a parameter, providing comprehensive reflection capabilities for method and constructor parameters.
/// 
/// ParameterMirror represents a single parameter of a method or constructor and provides
/// access to information about the parameter including its type, annotations,
/// default values, and parameter characteristics.
/// 
/// This class provides type-safe parameter reflection similar to Java's Parameter class
/// but adapted for Dart's parameter system including optional positional and named parameters.
/// 
/// **Example:**
/// ```dart
/// class Calculator {
///   int add(int a, [int b = 0]) => a + b;
///   
///   int multiply({required int x, int y = 1}) => x * y;
/// }
/// 
/// final calcClass = ClassMirror.forType<Calculator>();
/// final addMethod = calcClass.getMethod('add');
/// final parameters = addMethod.getParameters();
/// 
/// print(parameters[0].getName()); // 'a'
/// print(parameters[0].getType().getSimpleName()); // 'int'
/// print(parameters[0].isOptional()); // false
/// 
/// print(parameters[1].getName()); // 'b'
/// print(parameters[1].isOptional()); // true
/// print(parameters[1].hasDefaultValue()); // true
/// print(parameters[1].getDefaultValue()); // 0
/// ```
/// 
/// {@endtemplate}
class ParameterMirror extends AnnotatedElement {
  /// The underlying Dart ParameterMirror from dart:mirrors
  final mirrors.ParameterMirror _mirror;
  
  /// Cache for annotations to improve performance
  List<ReflectableAnnotation>? _annotationCache;
  
  /// {@macro parameterMirror}
  ParameterMirror._(this._mirror);
  
  /// Creates a ParameterMirror from a dart:mirrors ParameterMirror.
  /// 
  /// This is the primary factory method for creating ParameterMirror instances
  /// from the underlying Dart mirror system.
  /// 
  /// **Parameters:**
  /// - [mirror]: The dart:mirrors ParameterMirror to wrap
  /// 
  /// **Returns:** A new ParameterMirror instance
  /// 
  /// **Throws:**
  /// - [InvalidArgumentException] if the mirror is null or invalid
  static ParameterMirror fromDartMirror(mirrors.ParameterMirror mirror) {
    return ParameterMirror._(mirror);
  }
  
  // ========== Basic Parameter Information ==========
  
  /// Returns the name of the parameter.
  /// 
  /// If the parameter name is not available (which can happen in some cases
  /// with compiled code), this method returns a synthesized name.
  /// 
  /// **Returns:** The name of the parameter
  String getName() {
    return mirrors.MirrorSystem.getName(_mirror.simpleName);
  }
  
  /// Returns the simple name of the parameter.
  /// 
  /// This is an alias for [getName] for consistency with other mirror classes.
  /// 
  /// **Returns:** The simple name of the parameter
  String getSimpleName() => getName();
  
  /// Returns the qualified name of the parameter.
  /// 
  /// The qualified name includes the declaring executable and parameter name.
  /// 
  /// **Returns:** The qualified name of the parameter
  String getQualifiedName() {
    return mirrors.MirrorSystem.getName(_mirror.qualifiedName);
  }
  
  /// Returns a ClassMirror that identifies the declared type for the parameter.
  /// 
  /// **Returns:** A ClassMirror representing the declared type of the parameter
  ClassMirror<Object> getType() {
    final type = _mirror.type;
    if (type is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(type);
    }
    throw ClassInstantiationException('Parameter type is not a class');
  }
  
  /// Returns a ClassMirror that represents the declared type for the parameter.
  /// 
  /// This method returns the same as [getType] for compatibility with Java's API.
  /// In Dart, generic parameter types are the same as parameter types.
  /// 
  /// **Returns:** A ClassMirror representing the generic type of the parameter
  ClassMirror<Object> getGenericType() => getType();
  
  // ========== Parameter Characteristics ==========
  
  /// Returns true if this parameter is optional.
  /// 
  /// A parameter is optional if it can be omitted when calling the method or constructor.
  /// This includes both optional positional parameters (declared with []) and
  /// named parameters (declared with {}).
  /// 
  /// **Returns:** true if this parameter is optional, false otherwise
  bool isOptional() => _mirror.isOptional;
  
  /// Returns true if this parameter is a named parameter.
  /// 
  /// Named parameters are declared within curly braces {} and must be specified
  /// by name when calling the method or constructor.
  /// 
  /// **Returns:** true if this parameter is named, false otherwise
  bool isNamed() => _mirror.isNamed;
  
  /// Returns true if this parameter is a required named parameter.
  /// 
  /// A named parameter is required if it's declared with the 'required' keyword.
  /// 
  /// **Returns:** true if this parameter is a required named parameter, false otherwise
  bool isRequired() {
    // In Dart, a named parameter is required if it's named but not optional
    // or if it has no default value and is named
    return isNamed() && !hasDefaultValue() && !isOptional();
  }
  
  /// Returns true if this parameter has a default value.
  /// 
  /// A parameter has a default value if one was explicitly declared in the
  /// method or constructor signature.
  /// 
  /// **Returns:** true if this parameter has a default value, false otherwise
  bool hasDefaultValue() => _mirror.hasDefaultValue;
  
  /// Returns true if this parameter is final.
  /// 
  /// In Dart, parameters are implicitly final within the method body.
  /// 
  /// **Returns:** true if this parameter is final, false otherwise
  bool isFinal() => _mirror.isFinal;
  
  /// Returns true if this parameter represents a variable arguments parameter.
  /// 
  /// Dart doesn't have true varargs like Java, but this method returns true
  /// if the parameter is an optional positional parameter that could conceptually
  /// represent multiple values.
  /// 
  /// **Returns:** true if this parameter is varargs-like, false otherwise
  bool isVarArgs() {
    // In Dart, the closest thing to varargs is optional positional parameters
    return isOptional() && !isNamed();
  }
  
  /// Returns true if this parameter is synthetic.
  /// 
  /// A parameter is synthetic if it was introduced by the compiler and does
  /// not correspond to a parameter in the original source code.
  /// 
  /// **Returns:** true if this parameter is synthetic, false otherwise
  bool isSynthetic() {
    // In Dart, parameters are generally not synthetic unless compiler-generated
    return false;
  }
  
  // ========== Default Value Access ==========
  
  /// Returns the default value for this parameter.
  /// 
  /// If the parameter has no default value, this method returns null.
  /// The default value is returned as it would appear in the source code.
  /// 
  /// **Returns:** The default value for this parameter, or null if none exists
  /// 
  /// **Example:**
  /// ```dart
  /// void method([int x = 42, String y = 'hello']) {}
  /// 
  /// // For parameter x: getDefaultValue() returns 42
  /// // For parameter y: getDefaultValue() returns 'hello'
  /// ```
  Object? getDefaultValue() {
    if (!hasDefaultValue()) {
      return null;
    }
    
    final defaultValue = _mirror.defaultValue;
    return defaultValue?.reflectee;
  }
  
  /// Gets the default value with type safety.
  /// 
  /// This is a generic version of [getDefaultValue] that provides compile-time
  /// type safety for the return value.
  /// 
  /// **Type Parameters:**
  /// - [T]: The expected type of the default value
  /// 
  /// **Returns:** The default value cast to type T, or null if no default value
  /// 
  /// **Throws:**
  /// - [TypeError] if the default value cannot be cast to type T
  T? getDefaultValueTyped<T>() {
    final value = getDefaultValue();
    if (value == null) return null;
    if (value is T) return value as T;
    throw TypeError();
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
  
  // ========== Utility Methods ==========
  
  /// Returns the underlying dart:mirrors ParameterMirror.
  /// 
  /// This method provides access to the underlying Dart mirror for advanced
  /// use cases that require direct access to dart:mirrors functionality.
  /// 
  /// **Returns:** The underlying ParameterMirror
  mirrors.ParameterMirror get dartMirror => _mirror;
  
  // ========== Object Methods ==========
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ParameterMirror && other._mirror == _mirror;
  }
  
  @override
  int get hashCode => _mirror.hashCode;
  
  @override
  String toString() => 'ParameterMirror(${getName()})';
}