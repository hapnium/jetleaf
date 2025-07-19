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

import '../class.dart';
import '../interfaces/reflectable_annotation.dart';

/// {@template typeVariableInfo}
/// Provides metadata and utilities for a class type variable obtained via Jet Reflection.
/// 
/// Use this class to introspect a type variable's characteristics, annotations, and upper bound,
/// or to dynamically invoke methods with type variables.
/// 
/// Example:
/// ```dart
/// final typeVariable = ClassMirror.forType<MyClass>().getTypeVariable('T');
/// final info = ClassTypeVariableInfo.fromJetMirror(typeVariable);
/// final upperBound = info.getUpperBound();
/// ```
/// 
/// {@endtemplate}
class ClassTypeVariableInfo {
  final String name;
  final String qualifiedName;
  final Class<Object> upperBound;
  final List<ReflectableAnnotation> annotations;
  
  /// {@macro typeVariableInfo}
  ClassTypeVariableInfo({
    required this.name,
    required this.qualifiedName,
    required this.upperBound,
    required this.annotations,
  });
  
  @override
  String toString() => 'TypeVariableInfo($name)';
}