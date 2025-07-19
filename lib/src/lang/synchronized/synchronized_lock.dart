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

import 'dart:async';

import '../collections/queue.dart';
import '../exceptions.dart';

/// {@template synchronized_lock}
/// A reentrant async lock for critical section execution.
///
/// This class serializes access to an async [FutureOr] function
/// by maintaining a queue. Reentrancy is supported within the same [Zone].
///
/// Features:
/// - Queue-based task execution
/// - Optional reentrancy (based on Dart zones)
///
/// Example:
/// ```dart
/// final lock = SynchronizedLock();
///
/// await lock.synchronized(() async {
///   // Only one async block can execute here at a time
/// });
/// ```
/// {@endtemplate}
class SynchronizedLock {
  final Queue<_LockRequest> _queue = Queue();
  bool _isRunning = false;

  /// Tracks the [Zone] where the current task is executing.
  Zone? _currentZone;

  /// Tracks how many times the same zone has re-entered the lock.
  int _reentrantCount = 0;

  /// {@template synchronized_lock_synchronized}
  /// Executes the [action] within a synchronized block.
  ///
  /// Only one [action] may execute at a time per lock. If the current [Zone]
  /// has already acquired the lock, the function is treated as reentrant and allowed.
  ///
  /// Example:
  /// ```dart
  /// await lock.synchronized(() async {
  ///   // Do something
  /// });
  /// ```
  /// {@endtemplate}
  FutureOr<T> synchronizedAsync<T>(FutureOr<T> Function() action) {
    final completer = Completer<T>();
    final request = _LockRequest(() async {
      try {
        _currentZone = Zone.current;
        _reentrantCount++;
        final result = await action();
        completer.complete(result);
      } catch (e, s) {
        completer.completeError(e, s);
      } finally {
        _reentrantCount--;
        if (_reentrantCount == 0) _currentZone = null;
        _isRunning = false;
        _next();
      }
    });

    _queue.add(request);
    _maybeRun();
    return completer.future;
  }

  /// {@template synchronized_lock_synchronized_sync}
  /// Executes the [action] within a synchronized block.
  ///
  /// Only one [action] may execute at a time per lock. If the current [Zone]
  /// has already acquired the lock, the function is treated as reentrant and allowed.
  ///
  /// Example:
  /// ```dart
  /// lock.synchronized(() {
  ///   // Do something
  /// });
  /// ```
  /// {@endtemplate}
  T synchronized<T>(T Function() action) {
    T? result;
    Object? error;
    StackTrace? stack;

    final completer = Completer<void>();

    _queue.add(_LockRequest(() async {
      try {
        result = action();
      } catch (e, s) {
        error = e;
        stack = s;
      } finally {
        completer.complete();
      }
    }));

    _maybeRun();
    // Wait until this sync task completes.
    // Since sync tasks must run sync, we wait with .then synchronously.
    Future.wait([completer.future]);

    if (error != null) throw ReentrantSynchronizedException(error.toString(), stack); // rethrow
    return result as T;
  }

  void _maybeRun() {
    if (_isRunning) {
      // Reentrant call from same Zone
      if (_currentZone == Zone.current) {
        final task = _queue.removeLast();
        task.run();
      }
      return;
    }
    _next();
  }

  void _next() {
    if (_queue.isEmpty) return;
    _isRunning = true;
    final task = _queue.removeFirst();
    task.run();
  }
}

/// {@template lock_request}
/// Wraps a function call to be queued by [SynchronizedLock].
///
/// It stores a `FutureOr<void>`-returning callback and provides
/// a simple `.run()` call used by the lock queue.
/// {@endtemplate}
class _LockRequest {
  /// The actual logic to execute.
  final FutureOr<void> Function() run;

  /// {@macro lock_request}
  _LockRequest(this.run);
}