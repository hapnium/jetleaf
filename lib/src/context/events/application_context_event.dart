import '../application_context.dart';
import 'application_event.dart';

/// {@template application_context_event}
/// A base class for all events that are published within the context of an [ApplicationContext].
///
/// This class is an extension of [ApplicationEvent] that ensures the source
/// of the event is always an [ApplicationContext]. It is intended to be subclassed
/// for specific types of application context lifecycle events such as context refresh,
/// close, or start.
///
/// ---
///
/// ### Example:
/// ```dart
/// class ContextRefreshedEvent extends ApplicationContextEvent {
///   ContextRefreshedEvent(ApplicationContext source) : super(source);
/// }
///
/// void handle(ContextRefreshedEvent event) {
///   final context = event.getSource();
///   print("Application context refreshed: $context");
/// }
/// ```
///
/// This abstraction allows for strongly typed event listeners specific to the lifecycle
/// of the JetLeaf application context.
/// {@endtemplate}
abstract class ApplicationContextEvent extends ApplicationEvent {
  /// {@macro application_context_event}
  ApplicationContextEvent(ApplicationContext source) : super(source);

  /// Returns the [ApplicationContext] that published this event.
  ///
  /// This overrides the base `source` accessor to provide
  /// a typed reference to the [ApplicationContext].
  @override
  ApplicationContext getSource() {
    return super.source as ApplicationContext;
  }
}