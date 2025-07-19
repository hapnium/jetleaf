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
import '../mirrors/field_mirror.dart';
import '../mirrors/class_mirror.dart';
import '../class.dart';

/// {@template fieldInfo}
/// Provides metadata and access utilities for a class field obtained via Jet Reflection.
/// 
/// This includes metadata such as type, visibility, and annotations, and allows
/// dynamic reading and writing of both instance and static fields.
/// 
/// Example:
/// ```dart
/// final field = MyClass.getFields().firstWhere((f) => f.name == 'id');
/// final info = ClassFieldInfo.fromJetMirror(field);
/// final value = info.getValue(instance);
/// ```
/// 
/// {@endtemplate}
class ClassFieldInfo implements ClassInfoContext {
  final FieldMirror _jetleafMirror;

  /// {@macro fieldInfo}
  /// Creates a [ClassFieldInfo] from a [FieldMirror].
  ClassFieldInfo.fromJetMirror(this._jetleafMirror);

  /// Whether the field is declared as `static`
  bool get isStatic => _jetleafMirror.isStatic();

  /// Whether the field is declared as `final`
  bool get isFinal => _jetleafMirror.isFinal();

  /// Whether the field is declared as `const`
  bool get isConst => _jetleafMirror.isConst();

  /// Whether the field is private (starts with `_`)
  bool get isPrivate => _jetleafMirror.isPrivate();

  /// Gets the value of this field from the given [instance].
  /// 
  /// Throws [Exception] if access fails.
  Object? getValue(Object? instance) {
    try {
      return _jetleafMirror.get(instance);
    } catch (e) {
      rethrow;
    }
  }

  /// Sets the value of this field on the given [instance].
  /// 
  /// Throws [Exception] if access fails or if the field is `final`.
  void setValue(Object? instance, Object? value) {
    try {
      _jetleafMirror.set(instance, value);
    } catch (e) {
      rethrow;
    }
  }

  /// Gets the value of this static field.
  /// 
  /// Throws [IllegalTypeAccessException] if the field is not static.
  Object? getStaticValue() {
    if (!isStatic) {
      throw IllegalTypeAccessException('Field $simpleName is not static');
    }
    try {
      return _jetleafMirror.getStatic();
    } catch (e) {
      rethrow;
    }
  }

  /// Sets the value of this static field.
  /// 
  /// Throws [IllegalTypeAccessException] if the field is not static.
  void setStaticValue(Object? value) {
    if (!isStatic) {
      throw IllegalTypeAccessException('Field $simpleName is not static');
    }
    try {
      _jetleafMirror.setStatic(value);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String get simpleName => _jetleafMirror.getName();

  @override
  String get qualifiedName => _jetleafMirror.getQualifiedName();

  @override
  Class<Object> get clazz => Class.fromMirror(_jetleafMirror.getType());

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
  String toString() => 'FieldInfo($simpleName)';
}