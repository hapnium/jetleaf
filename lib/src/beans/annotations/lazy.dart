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

/// {@template lazy}
/// Annotation to indicate that a bean or component should be lazily initialized.
///
/// Lazily initialized beans are not created during application context startup,
/// but rather when they are first requested from the container. This is useful
/// for optimizing startup time or avoiding expensive object creation unless necessary.
///
/// ### Usage
/// ```dart
/// @Component()
/// @Lazy()
/// class ExpensiveService {
///   ExpensiveService() {
///     print('ExpensiveService initialized');
///   }
/// }
///
/// @Configuration()
/// class AppConfig {
///   @Bean()
///   @Lazy()
///   DataSource dataSource() => DataSource();
///
///   @Bean()
///   @Lazy(false) // Eager initialization
///   LoggerService logger() => LoggerService();
/// }
/// ```
///
/// The default behavior is `@Lazy(true)`. Use `@Lazy(false)` to explicitly disable laziness.
///
/// {@endtemplate}
@Target({TargetKind.classType})
class Lazy extends ReflectableAnnotation {
  /// Whether the bean should be lazily initialized.
  final bool value;

  /// {@macro lazy}
  const Lazy([this.value = true]);

  @override
  String toString() => 'Lazy(value: $value)';

  @override
  Type get annotationType => Lazy;
}