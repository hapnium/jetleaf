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

import 'application_context_event.dart';

/// {@template context_stopped_event}
/// Event published when the [ApplicationContext] is explicitly stopped.
///
/// This typically occurs when the context is paused without being closed or
/// destroyed. For example, in a long-running application, the context might
/// be stopped temporarily to conserve resources or halt scheduled tasks.
///
/// Listeners may use this event to perform cleanup, stop background processes,
/// or safely pause services that should not run during the stopped state.
///
/// ---
///
/// ### Example:
/// ```dart
/// class ShutdownLogger implements ApplicationListener<ContextStoppedEvent> {
///   @override
///   void onApplicationEvent(ContextStoppedEvent event) {
///     print("Application context stopped: ${event.getSource()}");
///   }
/// }
/// ```
///
/// The context can later be restarted by triggering a refresh or start event.
/// {@endtemplate}
abstract class ContextStoppedEvent extends ApplicationContextEvent {
  /// {@macro context_stopped_event}
  ContextStoppedEvent(super.source);
}