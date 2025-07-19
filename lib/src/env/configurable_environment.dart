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

import 'environment.dart';
import 'property_source/mutable_property_sources.dart';

/// {@template configurable_environment}
/// A configurable extension of the [Environment] interface that allows mutation
/// of environment internals such as active profiles and property sources.
///
/// This interface exposes:
/// - `propertySources`: the mutable stack of [PropertySource]s used for
///   resolving properties.
/// - `setActiveProfiles`: to explicitly set the profiles considered active
///   during configuration.
/// - `setDefaultProfiles`: to define fallback profiles when no active profiles
///   are provided.
///
/// It is typically implemented by core environment types like
/// [AbstractEnvironment] and [StandardEnvironment].
///
/// ### Example usage:
///
/// ```dart
/// final env = StandardEnvironment();
///
/// env.setActiveProfiles(['dev']);
/// env.setDefaultProfiles(['default']);
///
/// env.propertySources.addLast(
///   MapPropertySource('app', {'debug': 'true'}),
/// );
///
/// print(env.getProperty('debug')); // true
/// ```
///
/// Use this interface when building frameworks or apps that require profile-based
/// configuration or dynamic property source injection.
/// {@endtemplate}
abstract class ConfigurableEnvironment implements Environment {
  /// The mutable property sources used by this environment.
  MutablePropertySources get propertySources;

  /// Sets the list of profiles to consider active.
  void setActiveProfiles(List<String> profiles);

  /// Sets the list of profiles to be used as fallback when no active ones are defined.
  void setDefaultProfiles(List<String> profiles);
}