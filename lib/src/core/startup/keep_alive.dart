import 'dart:async' show Completer;

import 'package:jetleaf/context.dart';

/// {@template keep_alive}
/// A lifecycle-aware component that keeps the Dart VM alive as long as
/// the [ApplicationContext] is running.
///
/// This is useful for command-line or server-based JetLeaf applications
/// that would otherwise terminate after context initialization.
///
/// The keep-alive mechanism listens to [ApplicationContextEvent]s and
/// starts an internal blocking thread on [ContextRefreshedEvent], and
/// releases it on [ContextClosedEvent].
///
/// ---
///
/// ### Example
/// ```dart
/// void main() {
///   final context = JetLeaf.run();
///   context.addApplicationListener(KeepAlive());
/// }
/// ```
///
/// {@endtemplate}
final class KeepAlive implements ApplicationListener<ApplicationContextEvent> {
  /// Internal completer used to block the thread until shutdown.
  Completer<void> completer = Completer<void>();

  /// {@macro keep_alive}
  KeepAlive();

  @override
  void onApplicationEvent(ApplicationContextEvent event) {
    if (event is ContextRefreshedEvent) {
      startKeepAliveThread();
    } else if (event is ContextClosedEvent) {
      stopKeepAliveThread();
    }
  }

  /// Starts the keep-alive thread by awaiting an uncompleted [Completer].
  ///
  /// This method will block the current execution thread until
  /// [stopKeepAliveThread] is called, making it suitable for use
  /// at the end of a `main()` method to prevent premature VM exit.
  void startKeepAliveThread() async {
    if (completer.isCompleted) {
      completer = Completer<void>();
    }

    await completer.future;
  }

  /// Stops the keep-alive thread, allowing the application to shut down.
  ///
  /// This completes the internal [Completer], releasing the await in
  /// [startKeepAliveThread] and allowing the process to exit gracefully.
  void stopKeepAliveThread() {
    if (completer.isCompleted) return;
    completer.complete();
  }
}