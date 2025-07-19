/// {@template compilation_mode}
/// Enumeration of Dart compilation modes.
///
/// Dart supports multiple runtime modes, each optimized for a different use case:
///
/// - [debug]: Used during development. Provides hot reload and assertions.
/// - [profile]: Used to analyze performance with minimal optimizations.
/// - [release]: Fully optimized mode for production deployment.
///
/// JetLeaf uses this enum to capture how the application was compiled and run
/// at startup time, typically via [SystemDetector].
///
/// Example:
/// ```dart
/// if (mode == CompilationMode.release) {
///   print('Production mode enabled');
/// }
/// ```
/// {@endtemplate}
enum CompilationMode {
  /// {@macro compilation_mode}
  debug,

  /// {@macro compilation_mode}
  profile,

  /// {@macro compilation_mode}
  release;

  @override
  String toString() => name;
}