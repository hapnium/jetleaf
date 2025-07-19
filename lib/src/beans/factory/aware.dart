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

/// {@template aware}
/// A marker interface for JetLeaf framework lifecycle awareness.
///
/// This interface is used to signal that a class is "aware" of a specific
/// framework infrastructure component or context, such as environment,
/// bean factory, application context, or resource loader.
///
/// Implementing subinterfaces like `EnvironmentAware`, `BeanFactoryAware`,
/// or `ApplicationContextAware` allows JetLeaf to inject those components
/// automatically during context initialization.
///
/// This is inspired by Spring's Aware interfaces.
///
/// ### Example:
/// ```dart
/// class MyService implements EnvironmentAware {
///   late Environment environment;
///
///   @override
///   void setEnvironment(Environment env) {
///     environment = env;
///   }
/// }
/// ```
/// {@endtemplate}
abstract interface class Aware {
  /// {@macro aware}
  const Aware();
}