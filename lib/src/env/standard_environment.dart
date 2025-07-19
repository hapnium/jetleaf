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

import 'dart:io' show Platform;

import 'package:jetleaf/lang.dart';

import 'abstract_environment.dart';
import 'profiles/profiles.dart';
import 'property_source/mutable_property_sources.dart';
import 'property_source/system_environment_property_source.dart';

/// {@template standard_environment}
/// A concrete implementation of [AbstractEnvironment] that represents the
/// default runtime environment for most applications.
///
/// It supports:
/// - System environment variables via [Platform.environment]
/// - Active and default profile management
/// - Placeholder resolution and conversion via the parent class
///
/// This class automatically registers a [SystemEnvironmentPropertySource] under
/// the name `'systemEnvironment'`. It also maintains a set of active and default
/// profiles, which can be queried using [acceptsProfiles] and [matchesProfiles].
///
/// ### Example usage:
///
/// ```dart
/// final env = StandardEnvironment();
///
/// env.setActiveProfiles(['dev']);
/// env.setDefaultProfiles(['default']);
///
/// print(env.activeProfiles); // [dev]
/// print(env.getProperty('PATH')); // system environment variable
///
/// if (env.acceptsProfiles(Profiles.of(['dev']))) {
///   print('Running in dev mode');
/// }
/// ```
///
/// The default profile is always `'default'` unless overridden explicitly.
/// {@endtemplate}
class StandardEnvironment extends AbstractEnvironment {
  /// The name used to register the system environment property source.
  static const String SYSTEM_ENVIRONMENT_PROPERTY_SOURCE_NAME = 'systemEnvironment';

  /// The reserved name for the default profile.
  static const String RESERVED_DEFAULT_PROFILE_NAME = 'default';

  final List<String> _activeProfiles = [];
  final List<String> _defaultProfiles = [RESERVED_DEFAULT_PROFILE_NAME];

  /// {@macro standard_environment}
  StandardEnvironment();

  @override
  void customizePropertySources(MutablePropertySources propertySources) {
    this.propertySources.addAll(propertySources.toList());
    this.propertySources.addLast(
      SystemEnvironmentPropertySource(
        SYSTEM_ENVIRONMENT_PROPERTY_SOURCE_NAME,
        Platform.environment,
      ),
    );
  }

  @override
  bool acceptsProfiles(Profiles profiles) {
    return profiles.matches((profile) => _activeProfiles.contains(profile));
  }

  @override
  List<String> get activeProfiles => List.unmodifiable(_activeProfiles);

  @override
  List<String> get defaultProfiles => List.unmodifiable(_defaultProfiles);

  @override
  bool matchesProfiles(List<String> profileExpressions) {
    final Profiles profiles = Profiles.of(profileExpressions);
    return profiles.matches((profile) => _activeProfiles.contains(profile));
  }

  @override
  void setActiveProfiles(List<String> profiles) {
    _activeProfiles.clear();
    _activeProfiles.addAll(profiles);
  }

  @override
  void setDefaultProfiles(List<String> profiles) {
    _defaultProfiles.clear();
    _defaultProfiles.addAll(profiles);
  }

  @override
  void setEscapeCharacter(Character escapeCharacter) {
    this.escapeCharacter = escapeCharacter.value;
  }

  @override
  void setIgnoreUnresolvableNestedPlaceholders(bool ignoreUnresolvableNestedPlaceholders) {
    this.ignoreUnresolvableNestedPlaceholders = ignoreUnresolvableNestedPlaceholders;
  }

  @override
  void setPlaceholderPrefix(String placeholderPrefix) {
    this.placeholderPrefix = placeholderPrefix;
  }

  @override
  void setPlaceholderSuffix(String placeholderSuffix) {
    this.placeholderSuffix = placeholderSuffix;
  }

  @override
  void setRequiredProperties(List<String> requiredProperties) {
    this.requiredProperties = requiredProperties;
  }

  @override
  void setValueSeparator(String valueSeparator) {
    this.valueSeparator = valueSeparator;
  }
}