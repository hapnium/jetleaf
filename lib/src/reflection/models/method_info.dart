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

import '../context/class_info_context.dart';
import '../exceptions.dart';
import '../interfaces/reflectable_annotation.dart';
import '../mirrors/class_mirror.dart';
import '../mirrors/method_mirror.dart';
import '../class.dart';
import 'parameter_info.dart';

/// {@template method_info}
/// Provides metadata and reflective access to a class method using Jet Reflection.
/// 
/// Allows inspection of method properties (e.g. static, getter, setter),
/// parameters, return type, and annotations. You can also invoke the method
/// dynamically (instance or static).
/// 
/// Example:
/// ```dart
/// final method = ClassMirror.forType<MyClass>().getMethod('greet');
/// final info = ClassMethodInfo.fromJetMirror(method);
/// final result = info.invoke(instance, ['World']);
/// print(result); // Hello, World
/// ```
/// {@endtemplate}
class ClassMethodInfo implements ClassInfoContext {
  final MethodMirror _jetleafMirror;

  /// {@macro method_info}
  ClassMethodInfo.fromJetMirror(this._jetleafMirror);

  /// Whether the method is declared `static`
  bool get isStatic => _jetleafMirror.isStatic();

  /// Whether the method is abstract (no implementation)
  bool get isAbstract => _jetleafMirror.isAbstract();

  /// Whether the method is a getter
  bool get isGetter => _jetleafMirror.isGetter();

  /// Whether the method is a setter
  bool get isSetter => _jetleafMirror.isSetter();

  /// Whether the method is an operator (e.g. `+`, `==`)
  bool get isOperator => _jetleafMirror.isOperator();

  /// Always `false` for [ClassMethodInfo] since constructors are not methods.
  bool get isConstructor => false;

  /// Whether the method is private (starts with `_`)
  bool get isPrivate => _jetleafMirror.isPrivate();

  /// Whether the method is a regular method (not a getter, setter, or operator)
  bool get isRegular => _jetleafMirror.isRegularMethod();

  /// The symbol of the method.
  Symbol get symbol => _jetleafMirror.getSymbol();

  /// The return type of the method.
  ClassMirror<Object> getReturnType() => _jetleafMirror.getReturnType();

  /// The declaring class of the method.
  Class<Object> getDeclaringClass() => Class.fromMirror(_jetleafMirror.getDeclaringClass());

  /// List of parameters of the method
  List<ClassParameterInfo> get parameters => _jetleafMirror.getParameters().map((p) => ClassParameterInfo.fromJetMirror(p)).toList();

  /// Invokes the method on the provided [instance] with optional arguments.
  /// 
  /// [positionalArgs] are passed in order, and [namedArgs] must use [Symbol]s.
  /// 
  /// Example:
  /// ```dart
  /// methodInfo.invoke(obj, [arg1], {#named: value});
  /// ```
  Object? invoke(Object? instance, [List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _jetleafMirror.invoke(instance, positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  /// Invokes a static method with optional arguments.
  /// 
  /// Throws [IllegalTypeAccessException] if the method is not static.
  Object? invokeStatic([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    if (!isStatic) {
      throw IllegalTypeAccessException('Method $simpleName is not static');
    }
    try {
      return _jetleafMirror.invokeStatic(positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Class<Object> get clazz => Class.fromMirror(_jetleafMirror.getReturnType());

  @override
  String get simpleName => _jetleafMirror.getName();

  @override
  String get qualifiedName => _jetleafMirror.getQualifiedName();

  @override
  List<ReflectableAnnotation> get annotations => _jetleafMirror.getAnnotations();

  @override
  bool hasAnnotation<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return _jetleafMirror.isAnnotationPresent(annotationType);
    } catch (e) {
      return false;
    }
  }

  @override
  A? getAnnotationByType<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return _jetleafMirror.getAnnotation(annotationType);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'MethodInfo($simpleName)';
}