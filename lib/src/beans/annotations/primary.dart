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

import 'package:jetleaf/reflection.dart' show ReflectableAnnotation;
import 'package:meta/meta_meta.dart';

/// {@template primary}
/// Annotation used to indicate that a bean is the primary candidate for autowiring.
///
/// When multiple beans of the same type are present in the container, the one
/// annotated with `@Primary` will be preferred by the dependency resolution mechanism.
///
/// ### Usage
/// ```dart
/// @Configuration()
/// class PaymentConfig {
///   @Bean()
///   @Primary()
///   PaymentProcessor stripeProcessor() => StripePaymentProcessor();
///
///   @Bean('paypalProcessor')
///   PaymentProcessor paypalProcessor() => PayPalPaymentProcessor();
/// }
/// ```
///
/// In the example above, if a `PaymentProcessor` is required, the `StripePaymentProcessor`
/// will be injected by default unless explicitly qualified.
///
/// {@endtemplate}
@Target({TargetKind.classType})
class Primary extends ReflectableAnnotation {
  /// {@macro primary}
  const Primary();

  @override
  String toString() => 'Primary()';

  @override
  Type get annotationType => Primary;
}