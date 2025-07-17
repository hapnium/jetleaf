import 'application_context_event.dart';

/// {@template context_closed_event}
/// Event published when an [ApplicationContext] is closed.
///
/// This indicates that the application context is shutting down,
/// and all managed beans should release resources, stop background tasks,
/// or perform any necessary cleanup before termination.
///
/// This event is typically fired at the end of the application lifecycle,
/// right before the context is destroyed.
///
/// ---
///
/// ### Example:
/// ```dart
/// class MyShutdownListener implements ApplicationListener<ContextClosedEvent> {
///   @override
///   void onApplicationEvent(ContextClosedEvent event) {
///     print("Shutting down context: ${event.getSource()}");
///   }
/// }
/// ```
///
/// Registered [ApplicationListener]s can listen for this event
/// to trigger disposal or teardown logic.
/// {@endtemplate}
abstract class ContextClosedEvent extends ApplicationContextEvent {
  /// {@macro context_closed_event}
  ContextClosedEvent(super.source);
}