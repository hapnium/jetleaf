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

import '../../class.dart';
import '../class_loader.dart';

/// {@template class_loader_plugin}
/// Plugin interface for extending class loader functionality in JetLeaf.
///
/// Implementations of this interface can hook into the class loading lifecycle
/// to perform custom logic before and after a class is loaded, or during class loader
/// initialization and disposal.
///
/// This interface allows you to observe, modify, or react to class loading behavior.
/// For example, you can log class load events, register metrics, modify bytecode (if supported),
/// or enforce custom loading policies.
///
/// Plugins are registered using:
///
/// ```dart
/// final loader = MyCustomClassLoader();
/// loader.addPlugin(MyLoggingPlugin());
/// ```
///
/// {@endtemplate}
abstract class ClassLoaderPlugin {
  /// {@macro class_loader_plugin}
  const ClassLoaderPlugin();

  /// Called when the plugin is initialized and attached to the [classLoader].
  /// This method is invoked once at plugin registration time.
  void initialize(ClassLoader classLoader);

  /// Called before the specified class [className] is loaded.
  ///
  /// Use this to observe or block the loading of specific classes.
  void beforeClassLoad(String className);

  /// Called after the class with [className] has been loaded and resolved as [clazz].
  ///
  /// You can use this to perform post-processing, logging, or registration.
  void afterClassLoad(String className, Class<Object> clazz);

  /// Called when the class loader is being shut down or the plugin is being removed.
  ///
  /// You can use this to release any resources or clean up internal state.
  void dispose();
}