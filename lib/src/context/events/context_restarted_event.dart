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

/// {@template context_restarted_event}
/// Event published when the [ApplicationContext] is restarted.
///
/// This event is typically fired when the context is stopped and then started
/// again, signaling a full lifecycle reset rather than just a refresh.
///
/// It can be useful for components that need to release and reacquire resources,
/// reinitialize internal state, or log restart-specific metadata.
///
/// ---
///
/// ### Example:
/// ```dart
/// class RestartMonitor implements ApplicationListener<ContextRestartedEvent> {
///   @override
///   void onApplicationEvent(ContextRestartedEvent event) {
///     print("Application context restarted: ${event.getSource()}");
///   }
/// }
/// ```
///
/// {@endtemplate}
abstract class ContextRestartedEvent extends ApplicationContextEvent {
  /// {@macro context_restarted_event}
  ContextRestartedEvent(super.source);
}