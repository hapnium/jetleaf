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

import 'package:jetleaf/reflection.dart';

import 'class_loader_plugin.dart';

/// {@template hot_reload_plugin}
/// Defines a plugin interface for handling class-level hot reload events
/// within the class loading system.
///
/// Implementations can listen for changes in loaded classes and
/// respond when a class is reloaded during runtime, such as reinitializing
/// state, refreshing caches, or applying updates to live objects.
///
/// This is useful for development-time class reloading or dynamic runtime systems.
/// {@endtemplate}
abstract class HotReloadPlugin extends ClassLoaderPlugin {
  /// {@macro hot_reload_plugin}
  const HotReloadPlugin();

  /// Called when a class identified by [className] is reloaded.
  ///
  /// The [clazz] parameter provides the new class reference that replaced
  /// the previous one during the hot reload.
  ///
  /// This method should perform any necessary updates or cleanup, such as:
  /// - reinitializing cached instances
  /// - re-registering the class in a type registry
  /// - notifying listeners or hooks
  ///
  /// Example:
  /// ```dart
  /// @override
  /// void onClassReloaded(String className, Class<Object> clazz) {
  ///   print('Reloaded: $className with new class reference: $clazz');
  /// }
  /// ```
  void onClassReloaded(String className, Class<Object> clazz);
}