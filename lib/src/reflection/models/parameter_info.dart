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
import '../interfaces/reflectable_annotation.dart';
import '../mirrors/class_mirror.dart';
import '../class.dart';
import '../mirrors/parameter_mirror.dart';

/// {@template parameterInfo}
/// Provides metadata and utilities for a class parameter obtained via Jet Reflection.
/// 
/// Use this class to introspect a parameter's characteristics, annotations, and type,
/// or to dynamically invoke methods with parameters.
/// 
/// Example:
/// ```dart
/// final parameter = ClassMirror.forType<MyClass>().getMethod('greet').getParameters().first;
/// final info = ClassParameterInfo.fromJetMirror(parameter);
/// final type = info.getType();
/// ```
/// 
/// {@endtemplate}
class ClassParameterInfo implements ClassInfoContext {
  final ParameterMirror _jetleafMirror;
  
  /// {@macro parameterInfo}
  ClassParameterInfo.fromJetMirror(this._jetleafMirror);

  /// Whether the parameter is optional
  bool get isOptional => _jetleafMirror.isOptional();

  /// Whether the parameter is named
  bool get isNamed => _jetleafMirror.isNamed();

  /// Whether the parameter has a default value
  bool get hasDefaultValue => _jetleafMirror.hasDefaultValue();

  /// Whether the parameter is final
  bool get isFinal => _jetleafMirror.isFinal();

  /// Whether the parameter is required
  bool get isRequired => _jetleafMirror.isRequired();
  
  /// The default value of the parameter
  Object? get defaultValue => _jetleafMirror.getDefaultValue();

  @override
  String get simpleName => _jetleafMirror.getName();

  @override
  String get qualifiedName => _jetleafMirror.getQualifiedName();

  @override
  Class<Object> get clazz => Class.fromMirror(_jetleafMirror.getType());

  @override
  List<ReflectableAnnotation> get annotations => _jetleafMirror.getAnnotations();

  bool get isPositional => _jetleafMirror.dartMirror.isOptional;

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
  String toString() => 'ParameterInfo($simpleName)';
}