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

/// {@template context_started_event}
/// Event published when the [ApplicationContext] is started or restarted.
///
/// This event indicates that the context is now active and ready to process
/// requests, initialize beans, or resume tasks that may have been paused or
/// stopped.
///
/// It is typically used after a call to `start()` or when a previously stopped
/// context is reactivated.
///
/// ---
///
/// ### Example:
/// ```dart
/// class StartupLogger implements ApplicationListener<ContextStartedEvent> {
///   @override
///   void onApplicationEvent(ContextStartedEvent event) {
///     print("Application context started: ${event.getSource()}");
///   }
/// }
/// ```
///
/// {@endtemplate}
abstract class ContextStartedEvent extends ApplicationContextEvent {
  /// {@macro context_started_event}
  ContextStartedEvent(super.source);
}