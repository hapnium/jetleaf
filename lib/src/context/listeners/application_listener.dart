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

import '../events/application_event.dart';
import 'event_listener.dart';

/// {@template application_listener}
/// A listener for a specific type of [ApplicationEvent].
///
/// Implementations of this interface receive strongly typed application events
/// during the lifecycle of the application, such as context refresh, shutdown,
/// or domain-specific triggers.
///
/// This is a typed variant of [EventListener] and is automatically detected
/// by the JetLeaf event dispatch system when registered in the application context.
///
/// ---
///
/// ### Example Usage
/// ```dart
/// class StartupListener implements ApplicationListener<ApplicationStartedEvent> {
///   @override
///   void onApplicationEvent(ApplicationStartedEvent event) {
///     print('Started at: ${event.timestamp}');
///   }
/// }
/// ```
///
/// Typically, listeners are invoked synchronously on the same thread that
/// publishes the event.
/// {@endtemplate}
abstract interface class ApplicationListener<E extends ApplicationEvent> implements EventListener {
  /// Handle an application event of type [E].
  ///
  /// This method will be called by the event publisher when an event of
  /// type [E] (or subtype) is dispatched.
  void onApplicationEvent(E event);
}