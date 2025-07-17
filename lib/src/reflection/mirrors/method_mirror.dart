import 'dart:mirrors' as mirrors;

import '../exceptions.dart';
import '../interfaces/executable.dart';
import '../interfaces/member.dart';
import 'parameter_mirror.dart';
import '../interfaces/reflectable_annotation.dart';
import 'class_mirror.dart';

/// A mirror on a method, providing comprehensive reflection capabilities for methods.
/// 
/// MethodMirror represents a single method on a class or interface and provides
/// access to information about the method including its parameters, return type,
/// annotations, and the ability to invoke the method.
/// 
/// This class provides type-safe method reflection similar to Java's Method class
/// but adapted for Dart's type system and calling conventions.
/// 
/// **Example:**
/// ```dart
/// class Calculator {
///   @Deprecated('Use addNumbers instead')
///   int add(int a, int b) => a + b;
///   
///   static int multiply(int a, int b) => a * b;
/// }
/// 
/// final calcClass = ClassMirror.forType<Calculator>();
/// final addMethod = calcClass.getMethod('add');
/// 
/// print(addMethod.getName()); // 'add'
/// print(addMethod.isStatic()); // false
/// print(addMethod.getParameterCount()); // 2
/// 
/// final calc = Calculator();
/// final result = addMethod.invoke(calc, [5, 3]);
/// print(result); // 8
/// ```
class MethodMirror extends Executable implements Member {
  /// The underlying Dart MethodMirror from dart:mirrors
  final mirrors.MethodMirror _mirror;
  
  /// Cache for parameters to improve performance
  List<ParameterMirror>? _parameterCache;
  
  /// Cache for annotations to improve performance
  List<ReflectableAnnotation>? _annotationCache;
  
  /// Creates a MethodMirror from a dart:mirrors MethodMirror.
  /// 
  /// **Parameters:**
  /// - [mirror]: The underlying MethodMirror from dart:mirrors
  MethodMirror._(this._mirror);
  
  /// Creates a MethodMirror from a dart:mirrors MethodMirror.
  /// 
  /// This is the primary factory method for creating MethodMirror instances
  /// from the underlying Dart mirror system.
  /// 
  /// **Parameters:**
  /// - [mirror]: The dart:mirrors MethodMirror to wrap
  /// 
  /// **Returns:** A new MethodMirror instance
  /// 
  /// **Throws:**
  /// - [InvalidArgumentException] if the mirror is null or invalid
  static MethodMirror fromDartMirror(mirrors.MethodMirror mirror) {
    return MethodMirror._(mirror);
  }
  
  // ========== Basic Method Information ==========
  
  @override
  String getName() {
    return mirrors.MirrorSystem.getName(_mirror.simpleName);
  }
  
  /// Returns the simple name of the method.
  /// 
  /// **Returns:** The simple name of the method
  String getSimpleName() => getName();

  /// Returns the simple symbol of the method.
  /// 
  /// **Returns:** The simple symbol of the method
  Symbol getSymbol() => _mirror.simpleName;
  
  /// Returns the qualified name of the method.
  /// 
  /// The qualified name includes the declaring class name.
  /// 
  /// **Returns:** The qualified name of the method
  String getQualifiedName() {
    return mirrors.MirrorSystem.getName(_mirror.qualifiedName);
  }
  
  @override
  ClassMirror<Object> getDeclaringClass() {
    final owner = _mirror.owner;
    if (owner is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(owner);
    }
    throw ClassInstantiationException('Method owner is not a class');
  }
  
  /// Returns a ClassMirror that represents the formal return type of the method.
  /// 
  /// **Returns:** A ClassMirror representing the return type
  ClassMirror<Object> getReturnType() {
    final returnType = _mirror.returnType;
    if (returnType is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(returnType);
    }
    throw ClassInstantiationException('Return type is not a class');
  }
  
  @override
  int getModifiers() {
    int modifiers = 0;
    if (isStatic()) modifiers |= 0x0008; // STATIC
    if (isAbstract()) modifiers |= 0x0400; // ABSTRACT
    if (isFinal()) modifiers |= 0x0010; // FINAL
    if (_mirror.isPrivate) modifiers |= 0x0002; // PRIVATE
    return modifiers;
  }
  
  // ========== Method Type Checks ==========
  
  /// Returns true if this method is static.
  /// 
  /// **Returns:** true if this method is static, false otherwise
  bool isStatic() => _mirror.isStatic;
  
  /// Returns true if this method is abstract.
  /// 
  /// **Returns:** true if this method is abstract, false otherwise
  bool isAbstract() => _mirror.isAbstract;
  
  /// Returns true if this method is final.
  /// 
  /// In Dart, methods are final if they cannot be overridden.
  /// 
  /// **Returns:** true if this method is final, false otherwise
  bool isFinal() {
    // In Dart, static methods and private methods are effectively final
    return _mirror.isStatic || _mirror.isPrivate;
  }
  
  /// Returns true if this method is a getter.
  /// 
  /// **Returns:** true if this method is a getter, false otherwise
  bool isGetter() => _mirror.isGetter;
  
  /// Returns true if this method is a setter.
  /// 
  /// **Returns:** true if this method is a setter, false otherwise
  bool isSetter() => _mirror.isSetter;
  
  /// Returns true if this method is an operator.
  /// 
  /// **Returns:** true if this method is an operator, false otherwise
  bool isOperator() => _mirror.isOperator;
  
  /// Returns true if this method is a regular method.
  /// 
  /// A regular method is one that is not a getter, setter, or constructor.
  /// 
  /// **Returns:** true if this method is a regular method, false otherwise
  bool isRegularMethod() => _mirror.isRegularMethod;
  
  @override
  bool isSynthetic() => _mirror.isSynthetic;
  
  /// Returns true if this method is private.
  /// 
  /// In Dart, a method is private if its name starts with an underscore.
  /// 
  /// **Returns:** true if this method is private, false otherwise
  bool isPrivate() => _mirror.isPrivate;
  
  @override
  bool isPrivateAccess() => isPrivate();
  
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
  
  // ========== Method Invocation ==========
  
  /// Invokes the underlying method represented by this MethodMirror object,
  /// on the specified object with the specified parameters.
  /// 
  /// **Parameters:**
  /// - [obj]: The object the underlying method is invoked from
  /// - [args]: The arguments used for the method call
  /// - [namedArgs]: The named arguments used for the method call
  /// 
  /// **Returns:** The result of dispatching the method represented by this object
  /// 
  /// **Throws:**
  /// - [IllegalTypeAccessException] if this Method object is enforcing access control
  /// - [IllegalArgumentTypeException] if the method is an instance method and the specified
  ///   object argument is not an instance of the class or interface declaring the method
  /// - [InvalidArgumentException] if the number of actual and formal parameters differ
  Object? invoke(Object? obj, [List<Object?> args = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (!canAccess()) {
      throw IllegalTypeAccessException(getName());
    }
    
    try {
      if (isStatic()) {
        // For static methods, invoke on the class
        final classMirror = _mirror.owner as mirrors.ClassMirror;
        final result = classMirror.invoke(_mirror.simpleName, args, namedArgs);
        return result.reflectee;
      } else {
        // For instance methods, invoke on the object
        if (obj == null) {
          throw IllegalArgumentTypeException('Cannot invoke instance method on null object');
        }
        
        final instanceMirror = mirrors.reflect(obj);
        final result = instanceMirror.invoke(_mirror.simpleName, args, namedArgs);
        return result.reflectee;
      }
    } catch (e) {
      print(e);
      if (e is NoSuchMethodError) {
        throw NoSuchClassMethodException(getName(), getDeclaringClass().getSimpleName());
      }
      if (e is ArgumentError) {
        throw IllegalArgumentTypeException('Invalid arguments for method ${getName()}: $e');
      }
      rethrow;
    }
  }
  
  /// Invokes the underlying static method represented by this MethodMirror object
  /// with the specified parameters.
  /// 
  /// This is a convenience method for invoking static methods without needing
  /// to pass null as the object parameter.
  /// 
  /// **Parameters:**
  /// - [args]: The arguments used for the method call
  /// - [namedArgs]: The named arguments used for the method call
  /// 
  /// **Returns:** The result of dispatching the static method
  /// 
  /// **Throws:**
  /// - [IllegalStateException] if this method is not static
  /// - [IllegalTypeAccessException] if this Method object is enforcing access control
  /// - [InvalidArgumentException] if the number of actual and formal parameters differ
  Object? invokeStatic([List<Object?> args = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (!isStatic()) {
      throw IllegalArgumentTypeException('Method ${getName()} is not static');
    }
    
    return invoke(null, args, namedArgs);
  }
  
  // ========== String Representation ==========
  
  @override
  String toGenericString() {
    final buffer = StringBuffer();
    
    // Add modifiers
    if (isStatic()) buffer.write('static ');
    if (isAbstract()) buffer.write('abstract ');
    if (isFinal()) buffer.write('final ');
    
    // Add return type
    buffer.write('${getReturnType().getSimpleName()} ');
    
    // Add declaring class and method name
    buffer.write('${getDeclaringClass().getSimpleName()}.${getName()}');
    
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
    return other is MethodMirror && other._mirror == _mirror;
  }
  
  @override
  int get hashCode => _mirror.hashCode;
  
  @override
  String toString() => 'MethodMirror(${getName()})';
}