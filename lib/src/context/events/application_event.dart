import 'event_object.dart';

/// {@template application_event}
/// A base class for application-specific events within the JetLeaf framework.
///
/// Extends [EventObject] and allows capturing the event creation time using
/// either the system clock or a custom clock function.
///
/// Subclasses of [ApplicationEvent] are used to represent meaningful events
/// in the lifecycle of an application, such as context initialization, refresh,
/// shutdown, etc.
///
/// ---
///
/// ### Example
/// ```dart
/// class ContextRefreshedEvent extends ApplicationEvent {
///   ContextRefreshedEvent(Object source) : super(source);
/// }
///
/// final event = ContextRefreshedEvent(appContext);
/// print(event.source); // appContext
/// print(event.timestamp); // time of creation
/// ```
///
/// {@endtemplate}
abstract class ApplicationEvent extends EventObject {
  /// {@macro application_event}

  /// The timestamp of when the event was created.
  ///
  /// This is useful for sorting or logging events based on their occurrence time.
  @override
  final DateTime timestamp;

  /// Creates a new [ApplicationEvent] with the system clock as timestamp.
  ///
  /// Uses `DateTime.now()` by default.
  ApplicationEvent(super.source) : timestamp = DateTime.now();

  /// Creates a new [ApplicationEvent] using a custom clock function.
  ///
  /// This is useful for testing or fine-grained control over timestamps.
  ///
  /// Example:
  /// ```dart
  /// final fixedClock = () => DateTime.utc(2023, 1, 1);
  /// final event = ApplicationEvent.withClock(appContext, fixedClock);
  /// ```
  ApplicationEvent.withClock(Object source, DateTime Function() clock) : timestamp = clock(), super(source);
}