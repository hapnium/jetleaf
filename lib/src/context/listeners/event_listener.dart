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