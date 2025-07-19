/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

/// {@template print_stream}
/// An abstract interface representing a stream for formatted text output.
///
/// This is analogous to Java’s `PrintStream`, and provides utility methods
/// for printing values with or without newlines, flushing buffered content,
/// and closing the stream.
///
/// Implementations of this interface can print to `stdout`, files, memory,
/// or any other sink that supports basic text streaming.
///
/// ---
///
/// ### 📦 Example Usage:
/// ```dart
/// class ConsolePrintStream implements PrintStream {
///   @override
///   void print(Object? obj) => stdout.print(obj ?? 'null');
///
///   @override
///   void println(Object? obj) => stdout.println(obj ?? 'null');
///
///   @override
///   void newline() => stdout.println();
///
///   @override
///   void flush() {} // No-op for stdout
///
///   @override
///   Future<void> close() async {} // Nothing to close
/// }
///
/// final stream = ConsolePrintStream();
/// stream.print('Hello');
/// stream.println(' World');
/// stream.newline();
/// await stream.close();
/// ```
/// {@endtemplate}
abstract class PrintStream {
  /// {@macro print_stream}
  ///
  /// Prints the string representation of [obj] to the stream without a newline.
  ///
  /// If [obj] is `null`, prints `'null'`.
  void print(Object? obj);

  /// {@macro print_stream}
  ///
  /// Prints the string representation of [obj] followed by a newline.
  ///
  /// If [obj] is `null`, prints `'null'` followed by a newline.
  void println([Object? obj]);

  /// {@macro print_stream}
  ///
  /// Writes a newline character to the stream.
  void newline();

  /// {@macro print_stream}
  ///
  /// Flushes any buffered output to the stream.
  void flush();

  /// {@macro print_stream}
  ///
  /// Closes the stream and releases any resources.
  ///
  /// Returns a [Future] that completes when the stream is fully closed.
  Future<void> close();
}