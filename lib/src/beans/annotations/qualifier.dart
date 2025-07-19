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

/// {@template qualifier}
/// Annotation used to indicate which specific bean to inject when multiple
/// candidates of the same type exist.
///
/// This is commonly used in conjunction with `@Autowired()` to disambiguate
/// between multiple beans of the same base type.
///
/// ### Example
/// ```dart
/// abstract class Notifier {
///   Future<void> send(String message);
/// }
///
/// @Service()
/// class NotificationService {
///   @Autowired()
///   @Qualifier(EmailNotifier)
///   late final Notifier emailNotifier;
///
///   @Autowired()
///   @Qualifier(SmsNotifier)
///   late final Notifier smsNotifier;
///
///   Future<void> sendNotification(String message, NotificationType type) async {
///     switch (type) {
///       case NotificationType.email:
///         await emailNotifier.send(message);
///         break;
///       case NotificationType.sms:
///         await smsNotifier.send(message);
///         break;
///     }
///   }
/// }
///
/// class EmailNotifier implements Notifier {
///   @override
///   Future<void> send(String message) async {
///     // send email logic
///   }
/// }
///
/// class SmsNotifier implements Notifier {
///   @override
///   Future<void> send(String message) async {
///     // send sms logic
///   }
/// }
/// ```
///
/// {@endtemplate}
@Target({TargetKind.classType, TargetKind.field, TargetKind.parameter})
class Qualifier extends ReflectableAnnotation {
  /// The class type to qualify the injection target.
  final Type value;

  /// {@macro qualifier}
  const Qualifier(this.value);

  @override
  String toString() => 'Qualifier(value: $value)';

  @override
  Type get annotationType => Qualifier;
}