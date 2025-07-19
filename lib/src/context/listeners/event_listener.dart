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

/// {@template event_listener}
/// A marker interface for event listeners within the JetLeaf application context.
///
/// Classes that implement [EventListener] are eligible to receive events
/// published by the framework, typically subclasses of [ApplicationEvent]
/// or custom domain-specific events.
///
/// Event listeners are typically discovered and invoked by the JetLeaf
/// event dispatcher system during application lifecycle events or domain triggers.
///
/// ---
///
/// ### Example Usage
/// ```dart
/// class MyListener implements EventListener {
///   void onApplicationStarted(ApplicationStartedEvent event) {
///     print('Application started at ${event.timestamp}');
///   }
/// }
/// ```
///
/// To enable automatic detection, register the listener in your application context.
/// {@endtemplate}
abstract interface class EventListener {}