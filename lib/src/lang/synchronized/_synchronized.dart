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

part of 'synchronized.dart';

/// {@template lock_registry}
/// A global registry for tracking monitor objects and their corresponding locks.
///
/// This registry ensures that a unique [`SynchronizedLock`] is assigned per monitor object.
/// It uses a [Finalizer] to automatically clean up locks when the monitor is garbage collected.
///
/// Internally, it maintains:
/// - A map of `Object -> SynchronizedLock`
/// - A finalizer to remove locks once the object is no longer used
/// {@endtemplate}
final _lockRegistry = _MonitorRegistry();

/// Internal map storing the association of monitor objects to their lock instances.
final Map<Object, SynchronizedLock> _locks = {};

/// {@template monitor_registry}
/// Registry that manages and returns locks for monitor objects.
///
/// This ensures one lock per object and attaches a finalizer to clean
/// up once the object is no longer referenced.
///
/// Example usage:
/// ```dart
/// final lock = _lockRegistry.getLock(someObject);
/// await lock.synchronized(() async {
///   // critical section
/// });
/// ```
/// {@endtemplate}
class _MonitorRegistry {
  final Finalizer<Object> _cleanup = Finalizer((key) {
    _locks.remove(key);
  });

  /// Retrieves or creates a [SynchronizedLock] associated with the given [monitor] object.
  SynchronizedLock getLock(Object monitor) {
    return _locks.putIfAbsent(monitor, () {
      final lock = SynchronizedLock();
      _cleanup.attach(monitor, monitor);
      return lock;
    });
  }
}