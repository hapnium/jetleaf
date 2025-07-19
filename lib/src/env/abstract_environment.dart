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

import 'configurable_environment.dart';
import 'property_resolver/property_sources_property_resolver.dart';
import 'property_source/mutable_property_sources.dart';

/// {@template abstract_environment}
/// A base implementation of [ConfigurableEnvironment] that holds and manages
/// a collection of [PropertySource]s via [MutablePropertySources].
///
/// This class provides foundational behavior for environment-related features
/// such as property resolution, type conversion, and placeholder interpolation.
///
/// It initializes:
/// - an internal [MutablePropertySources] container,
/// - a default [ConfigurableConversionService],
/// - and delegates to the abstract [customizePropertySources] method for
/// further customization by subclasses.
///
/// ### How it works:
///
/// The [propertySources] field manages configuration sources. The constructor
/// creates an internal [PropertySourcesPropertyResolver] using that list and
/// binds a conversion service.
///
/// ### Example: Creating a Custom Environment
///
/// ```dart
/// class AppEnvironment extends AbstractEnvironment {
///   @override
///   void customizePropertySources(MutablePropertySources sources) {
///     sources.addLast(MapPropertySource('app', {
///       'env': 'production',
///       'debug': 'false',
///     }));
///   }
/// }
///
/// final env = AppEnvironment();
/// print(env.getProperty('env')); // production
/// ```
///
/// This base class is intended to be extended by concrete environment
/// implementations such as `StandardEnvironment`.
/// {@endtemplate}
abstract class AbstractEnvironment extends PropertySourcesPropertyResolver implements ConfigurableEnvironment {
  /// Holds all registered property sources for this environment.
  @override
  final MutablePropertySources propertySources = MutablePropertySources();

  /// {@macro abstract_environment}
  AbstractEnvironment() : super(MutablePropertySources()) {
    // Attach user-managed property sources to internal resolver
    super.propertySources.addAll(propertySources.toList());

    // Allow subclasses to define additional sources
    customizePropertySources(propertySources);
  }

  /// Called during construction to allow subclasses to register default property sources.
  ///
  /// Override this to register property sources like system env, application.properties, etc.
  void customizePropertySources(MutablePropertySources sources);
}