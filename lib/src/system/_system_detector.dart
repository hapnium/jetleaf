import 'dart:io';

import '_system.dart';
import 'compilation_mode.dart';
import 'abstract_system_interface.dart';
import 'system.dart';
import 'system_detector.dart';

/// {@template system_detector}
/// Discovers system-level data for JetLeaf and
/// creates a fully resolved [AbstractSystemInterface] instance.
///
/// This class is used internally during application bootstrap
/// to populate a [AbstractSystemInterface] instance that contains runtime
/// metadata such as:
/// - Compilation mode (debug, profile, release)
/// - Whether running from a `.dill` file
/// - Launch command
/// - Entrypoint
/// - IDE detection
/// - Watch mode status
///
/// Typically used via:
/// ```dart
/// final system = DefaultSystemDetector().detect(args);
/// ```
/// {@endtemplate}
class DefaultSystemDetector implements SystemDetector {
  /// {@macro system_detector}
  const DefaultSystemDetector();

  /// Detects the runtime environment and returns a [AbstractSystemInterface] instance.
  ///
  /// The returned [AbstractSystemInterface] contains key runtime information such as:
  /// - Whether the app is running from a `.dill` file
  /// - The Dart compilation mode
  /// - The launch command
  /// - IDE vs CLI launch
  /// - Watch mode status (if `--watch` was passed)
  ///
  /// [args] should be the raw CLI arguments passed to `main()`.
  @override
  AbstractSystemInterface detect(List<String> args) {
    final mode = _detectCompilationMode();
    final command = Platform.executableArguments.join(' ');
    final entry = Platform.script.toFilePath();
    final isDill = entry.endsWith('.dill');

    // Placeholder values for dependency/config counts.
    final result = DefaultSystem(
      isRunningFromDill: isDill,
      entrypoint: entry,
      mode: mode,
      isIdeRun: _detectIdeRun(),
      launchCommand: command,
      dependencyCount: 0,
      configurationCount: 0,
      watch: args.contains('--watch'),
    );

    System.system = result;
    return result;
  }

  /// Detects the current Dart compilation mode.
  ///
  /// Returns one of [CompilationMode.release], [CompilationMode.profile],
  /// or [CompilationMode.debug] based on VM environment flags.
  static CompilationMode _detectCompilationMode() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return CompilationMode.release;
    } else if (const bool.fromEnvironment('dart.vm.profile')) {
      return CompilationMode.profile;
    } else {
      return CompilationMode.debug;
    }
  }

  /// Returns `true` if the application was launched from an IDE.
  ///
  /// This is inferred by checking for VM service flags like
  /// `--enable-vm-service` or `--observe`.
  static bool _detectIdeRun() {
    final args = Platform.executableArguments.join(' ').toLowerCase();
    return args.contains('--enable-vm-service') || args.contains('--observe');
  }
}