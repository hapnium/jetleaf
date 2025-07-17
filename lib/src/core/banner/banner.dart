import 'package:jetleaf/lang.dart';
import 'package:jetleaf/reflection.dart';

import '../../env/environment.dart';

/// {@template banner_interface}
/// A contract for printing a custom application banner during JetLeaf startup.
///
/// Implement this interface to display a textual banner (e.g., ASCII art, branding,
/// version info) at the beginning of your application's lifecycle.
///
/// Banners are typically printed to the console or to a `PrintStream`
/// immediately after environment and reflection initialization.
///
/// ---
///
/// ### 📦 Example Usage:
/// ```dart
/// class MyBanner implements Banner {
///   @override
///   void printBanner(Environment env, Class<Object> sourceClass, PrintStream printStream) {
///     printStream.writeln('🚀 Welcome to JetLeaf!');
///     printStream.writeln('Running ${sourceClass.name} in ${env.get("ENV") ?? "default"} mode');
///   }
/// }
/// ```
///
/// ---
///
/// Register your banner via the application launcher to customize startup output.
///
/// {@endtemplate}
abstract interface class Banner {
  /// {@macro banner_interface}
  ///
  /// Called during JetLeaf startup to render the banner.
  ///
  /// - [environment] gives access to environment variables
  /// - [sourceClass] is the main application entry class
  /// - [printStream] is the output stream where the banner should be written
  void printBanner(Environment environment, Class<Object> sourceClass, PrintStream printStream);
}