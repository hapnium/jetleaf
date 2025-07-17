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