/// {@template system_library}
/// JetLeaf System Library
///
/// Provides core abstractions and utilities for detecting and interacting
/// with the runtime environment in which a JetLeaf application is running.
///
/// This includes:
/// - System introspection via [System]
/// - Runtime mode tracking via [CompilationMode]
/// - System metadata with [SystemInfo]
/// - Startup detection through [SystemDetector]
///
/// The [InternalSystemContext] is intentionally hidden from public API.
/// {@endtemplate}
library system;

export 'src/system/system.dart' hide InternalSystemContext;
export 'src/system/abstract_system_interface.dart';
export 'src/system/compilation_mode.dart';
export 'src/system/system_info.dart';
export 'src/system/system_detector.dart';