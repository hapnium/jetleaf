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

import 'class_loading_lock.dart';

class ClassLoadingLockImpl implements ClassLoadingLock {
  @override
  final String className;

  ClassLoadingLockImpl(this.className);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClassLoadingLockImpl && other.className == className;
  }

  @override
  int get hashCode => className.hashCode;

  @override
  String toString() => 'ClassLoadingLockImpl($className)';
}