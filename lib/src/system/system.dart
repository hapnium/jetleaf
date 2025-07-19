import 'package:meta/meta.dart';

import 'compilation_mode.dart';
import 'abstract_system_interface.dart';
import 'system_info.dart';

/// {@template system_context}
/// Internal system context used by JetLeaf to store and delegate
/// environment details collected at startup.
///
/// This acts as a proxy to a [AbstractSystemInterface] instance, allowing global access
/// to system information like entrypoint path, compilation mode,
/// dependency count, and whether the app is running from `.dill`.
///
/// The actual [AbstractSystemInterface] instance is injected via the [system] setter
/// after detection. Accessing the context before initialization will
/// result in runtime errors.
///
/// This class is marked `@internal` and not intended for public use.
/// {@endtemplate}
@internal
class InternalSystemContext implements AbstractSystemInterface {
  late AbstractSystemInterface _system;

  /// {@macro system_context}
  InternalSystemContext._();

  /// Sets the backing [AbstractSystemInterface] implementation.
  ///
  /// Must be called during framework bootstrap before accessing
  /// any properties on [SYSTEM].
  set system(AbstractSystemInterface system) {
    this._system = system;
  }

  @override
  CompilationMode get mode => _system.mode;

  @override
  int get configurationCount => _system.configurationCount;

  @override
  int get dependencyCount => _system.dependencyCount;

  @override
  String get entrypoint => _system.entrypoint;

  @override
  bool get isIdeRun => _system.isIdeRun;

  @override
  bool get isRunningFromDill => _system.isRunningFromDill;

  @override
  String get launchCommand => _system.launchCommand;

  @override
  SystemInfo toSystemInfo() => _system.toSystemInfo();

  @override
  bool get watch => _system.watch;
}

/// {@macro system}
final InternalSystemContext System = InternalSystemContext._();