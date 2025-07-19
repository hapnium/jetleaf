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

/// {@template jetLeafApplication}
/// 
/// Jet annotation for main application class
/// 
/// This annotation marks the main application class and configures
/// auto-configuration, component scanning, and other application settings.
/// 
/// Example Usage:
/// ```dart
/// @JetLeafApplication()
/// class MyApplication {
///   static void main(List<String> args) {
///     Jet.run(MyApplication, args);
///   }
/// }
/// 
/// // With custom configuration
/// @JetLeafApplication(
///   scanPackages: ['package:mode/mode.dart'],
///   excludeClasses: [DataSourceAutoConfiguration],
/// )
/// class CustomApplication {
///   static void main(List<String> args) {
///     Jet.run(CustomApplication, args);
///   }
/// }
/// ```
/// 
/// Advanced Usage:
/// ```dart
/// void main(List<String> args) {
///   JetApplication.run(EnterpriseApplication, args);
/// }
/// 
/// @JetLeafApplication(
///   scanPackages: ['package:mode/mode.dart', 'package:jetleaf/jetleaf.dart'],
///   scanClasses: [CoreConfig, WebConfig],
///   excludeClasses: [
///     DataSourceAutoConfiguration,
///     SecurityAutoConfiguration,
///   ],
///   excludePackages: [
///     'package:mode/mode.dart'
///   ]
/// )
/// @EnableScheduling()
/// @EnableCaching()
/// class EnterpriseApplication {
/// }
/// ```
/// {@endtemplate}
@Target({TargetKind.classType})
class JetLeafApplication extends ReflectableAnnotation {
  /// Base packages to scan for components
  final List<String> scanPackages;
  
  /// Base package classes to derive scan packages from
  final List<Type> scanClasses;
  
  /// Auto-configuration classes to exclude
  final List<Type> excludeClasses;
  
  /// Auto-configuration class names to exclude
  final List<String> excludePackages;
  
  /// Whether to proxy @Bean methods
  final bool proxyBeanMethods;
  
  /// {@macro jetLeafApplication}
  const JetLeafApplication({
    this.scanPackages = const [],
    this.scanClasses = const [],
    this.excludeClasses = const [],
    this.excludePackages = const [],
    this.proxyBeanMethods = true,
  });
  
  @override
  String toString() => 'Jet('
    'scanPackages: $scanPackages, '
    'scanPackageClasses: $scanClasses, '
    'exclude: $excludeClasses, '
    'excludePackageClasses: $excludePackages, '
    'proxyBeanMethods: $proxyBeanMethods)';

  @override
  int get hashCode {
    return super.hashCode 
      ^ scanPackages.hashCode 
      ^ scanClasses.hashCode 
      ^ excludeClasses.hashCode 
      ^ excludePackages.hashCode 
      ^ proxyBeanMethods.hashCode;
  }

  @override
  bool operator ==(Object other) {
    if (other is JetLeafApplication) {
      return scanPackages == other.scanPackages &&
          scanClasses == other.scanClasses &&
          excludeClasses == other.excludeClasses &&
          excludePackages == other.excludePackages &&
          proxyBeanMethods == other.proxyBeanMethods;
    }

    return false;
  }
  
  @override
  Type get annotationType => JetLeafApplication;
}