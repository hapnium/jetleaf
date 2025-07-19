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

/// {@template event_object}
/// A base class for all framework-level events.
///
/// This class captures the origin of the event ([source]) and the time it occurred ([timestamp]).
/// Subclasses typically define the specific type of event (e.g., context refresh, startup, shutdown).
///
/// Events are generally published and consumed within an application event system,
/// allowing for decoupled communication between components.
///
/// ### Example
/// ```dart
/// class ApplicationStartedEvent extends EventObject {
///   ApplicationStartedEvent(Object source) : super(source);
/// }
///
/// final event = ApplicationStartedEvent(appContext);
/// print(event.getSource()); // appContext
/// print(event.getTimestamp()); // DateTime of creation
/// ```
///
/// See also:
/// - [EventListener]
/// - [ApplicationEventPublisher]
/// {@endtemplate}
abstract class EventObject {
  /// {@macro event_object}
  
  /// The object that originated (or published) the event.
  final Object source;

  /// The time at which the event was created.
  final DateTime timestamp;

  /// Creates a new [EventObject] with the given [source].
  EventObject(this.source) : timestamp = DateTime.now();

  /// Returns the source of the event.
  Object getSource() => source;

  /// Returns the timestamp of the event.
  DateTime getTimestamp() => timestamp;

  @override
  String toString() => '${runtimeType}(source=$source, timestamp=$timestamp)';
}