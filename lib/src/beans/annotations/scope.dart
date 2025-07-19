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
import 'package:meta/meta_meta.dart';

/// {@template scope}
/// Annotation that specifies the scope of a bean within the JetLeaf container.
///
/// Use this to indicate whether a new instance should be created for each injection
/// (`ScopeType.prototype`) or a single shared instance should be used (`ScopeType.singleton`).
///
/// You can also configure proxy behavior using the [proxyMode] parameter.
///
/// ### Example:
/// ```dart
/// @Component()
/// @Scope(ScopeType.singleton)
/// class SingletonService {
///   // This service is shared across all injections
/// }
///
/// @Component()
/// @Scope(ScopeType.prototype, proxyMode: ScopedProxyMode.targetClass)
/// class PrototypeService {
///   // A new instance is created for each injection point
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.classType})
class Scope extends ReflectableAnnotation {
  /// Scope name
  final ScopeType value;
  
  /// Scoped proxy mode
  final ScopedProxyMode proxyMode;
  
  /// {macro scope}
  const Scope(this.value, {this.proxyMode = ScopedProxyMode.defaultMode});
  
  @override
  String toString() => 'Scope(value: $value, proxyMode: $proxyMode)';

  @override
  Type get annotationType => Scope;
}

/// ScopedProxyMode defines the proxy behavior for scoped beans.
/// 
/// This enum provides options for creating proxies in different styles:
/// - `defaultMode`: Uses the framework's default proxy mechanism.
/// - `targetClass`: Creates a proxy by subclassing the target class, allowing method interception.
/// - `interfaces`: Creates a proxy implementing the interfaces of the target class.
enum ScopedProxyMode {
  /// Default scoped proxy mode
  defaultMode,
  
  /// Target class scoped proxy mode
  targetClass,
  
  /// Interface scoped proxy mode
  interfaces,

  /// No scoped proxy mode
  no,
}

/// Scope types for beans.
///
/// The available scope types are:
///
/// - `singleton`: One instance per application context.
/// - `prototype`: One instance per request.
enum ScopeType {
  /// Singleton scope
  singleton,
  
  /// Prototype scope
  prototype
}