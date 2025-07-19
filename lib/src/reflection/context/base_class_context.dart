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

import '../interfaces/reflectable_annotation.dart';

/// A reflective interface that provides metadata and dynamic access to a Dart class of type [T].
///
/// This interface allows inspection of class members (constructors, fields,
/// methods), type relationships (superclasses, interfaces), annotations, and
/// runtime instantiation of new instances.
///
/// Typically used in frameworks or tools that require runtime type inspection
/// or meta-programming (e.g., dependency injection, serialization, test frameworks).
abstract interface class BaseClassContext {
  /// The simple name of the type (without generics or module prefix).
  ///
  /// Example:
  /// ```dart
  /// BaseClassContext<User>().simpleName => 'User'
  /// ```
  String get simpleName;

  /// The fully qualified name of the class, including library and class path.
  ///
  /// Example:
  /// `'my.package.MyClass'`
  String get qualifiedName;

  /// Checks whether this class has an annotation of type [A].
  ///
  /// [A] must extend [ReflectableAnnotation]. Returns `true` if at least one
  /// annotation of type [A] is present.
  ///
  /// Example:
  /// ```dart
  /// context.hasAnnotation<MyAnnotation>();
  /// ```
  bool hasAnnotation<A extends ReflectableAnnotation>();

  /// Retrieves the annotation of type [A] on this class, if it exists.
  ///
  /// Returns `null` if the annotation is not found. This method is type-safe,
  /// and [A] must extend [ReflectableAnnotation].
  ///
  /// Example:
  /// ```dart
  /// var annotation = context.getAnnotationByType<MyAnnotation>();
  /// ```
  A? getAnnotationByType<A extends ReflectableAnnotation>();
}