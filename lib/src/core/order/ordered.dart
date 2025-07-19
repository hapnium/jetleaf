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

/// {@template ordered}
/// A contract for objects that are assigned an order or precedence value.
///
/// This is typically used for sorting or prioritization where lower values have
/// higher priority (i.e., `0` is higher than `10`).
///
/// Framework components such as filters, interceptors, and plugins can implement
/// [Ordered] to control execution sequence.
///
/// ---
///
/// ### 🧭 Ordering Rules
/// - Lower values indicate higher priority
/// - Constants are provided for extreme values:
///   - [Ordered.HIGHEST_PRECEDENCE] = `-2^31` (highest possible priority)
///   - [Ordered.LOWEST_PRECEDENCE] = `2^31 - 1` (lowest possible priority)
///
/// ---
///
/// ### 📌 Example
/// ```dart
/// class MyFilter implements Ordered {
///   @override
///   int get order => 10;
/// }
///
/// final filters = [MyFilter(), AnotherFilter()];
/// filters.sort((a, b) => a.order.compareTo(b.order));
/// ```
/// {@endtemplate}
abstract class Ordered {
  /// {@macro ordered}
  const Ordered();

  /// The highest possible precedence value.
  static const int HIGHEST_PRECEDENCE = -0x80000000; // Integer.MIN_VALUE

  /// The lowest possible precedence value.
  static const int LOWEST_PRECEDENCE = 0x7FFFFFFF;  // Integer.MAX_VALUE

  /// {@macro ordered}
  int get order;
}