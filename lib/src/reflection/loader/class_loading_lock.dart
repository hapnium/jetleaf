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

/// {@template class_loading_lock}
/// A lock used to synchronize class loading operations in the system.
///
/// This class ensures that multiple threads trying to load the same class
/// do not cause race conditions or duplicate loads.
///
/// The lock uses the `className` as the key identifier, allowing you to 
/// lock loading operations based on a unique class name.
///
/// Example usage:
/// ```dart
/// final lock = ClassLoadingLock('package:example/example.dart');
///
/// // Store or retrieve from a map:
/// final lockMap = <ClassLoadingLock, Object>{};
/// lockMap.putIfAbsent(lock, () => Object());
///
/// // Used in a synchronized loading block:
/// synchronized(lockMap[lock]!, () {
///   // perform class loading logic
/// });
/// ```
/// {@endtemplate}
abstract class ClassLoadingLock {
  /// The fully qualified name of the class being locked for loading.
  final String className;

  /// {@macro class_loading_lock}
  ClassLoadingLock(this.className);
}