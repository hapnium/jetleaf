import 'application_context_event.dart';

/// {@template context_refreshed_event}
/// Event published when the [ApplicationContext] is refreshed or initialized.
///
/// This event is emitted after the application context has been fully configured,
/// all singleton beans have been instantiated, and the context is ready for use.
///
/// Listeners may use this event to perform actions once the application
/// is fully bootstrapped, such as triggering cache population, running
/// scheduled tasks, or initializing external services.
///
/// ---
///
/// ### Example:
/// ```dart
/// class StartupInitializer implements ApplicationListener<ContextRefreshedEvent> {
///   @override
///   void onApplicationEvent(ContextRefreshedEvent event) {
///     print("Context has been refreshed: ${event.getSource()}");
///   }
/// }
/// ```
///
/// This is usually the first lifecycle event emitted by the framework during startup.
/// {@endtemplate}
abstract class ContextRefreshedEvent extends ApplicationContextEvent {
  /// {@macro context_refreshed_event}
  ContextRefreshedEvent(super.source);
}