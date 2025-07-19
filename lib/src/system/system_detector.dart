import 'abstract_system_interface.dart';

/// {@template system_detector}
/// Strategy interface for detecting system information.
///
/// Used internally by JetLeaf during application startup to inspect
/// the runtime environment (such as compilation mode, launch method,
/// file type, watch mode, etc.) and produce a fully populated [AbstractSystemInterface]
/// instance.
///
/// Implementations of this interface encapsulate logic for interpreting
/// `Platform` values, environment flags, and CLI arguments.
///
/// Example usage:
/// ```dart
/// final detector = DefaultSystemDetector();
/// final system = detector.detect(args);
/// ```
/// {@endtemplate}
abstract class SystemDetector {
  /// {@macro system_detector}
  const SystemDetector();

  /// Detects and builds a new [AbstractSystemInterface] instance.
  ///
  /// [args] are the raw arguments passed to the application entrypoint.
  /// This method uses them in combination with platform-specific
  /// data to return a [AbstractSystemInterface] that describes the current runtime context.
  AbstractSystemInterface detect(List<String> args);
}