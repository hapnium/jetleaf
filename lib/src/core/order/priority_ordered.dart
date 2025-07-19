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

import 'ordered.dart';

/// {@template priority_ordered}
/// A special marker interface for [Ordered] objects that should be given
/// priority over other [Ordered] objects during sorting or processing.
///
/// This is typically used in systems where certain components (e.g., filters,
/// interceptors, processors) must be initialized or invoked before others,
/// even if they all implement [Ordered].
///
/// ---
///
/// ### ⚙️ Priority Semantics
/// - [PriorityOrdered] beans are always sorted and processed **before**
///   regular [Ordered] beans.
/// - Within each group (priority vs non-priority), ordering is still determined
///   by the `order` value.
///
/// ---
///
/// ### 📌 Example
/// ```dart
/// class CoreFilter implements PriorityOrdered {
///   @override
///   int get order => 0;
/// }
///
/// class CustomFilter implements Ordered {
///   @override
///   int get order => 0;
/// }
///
/// final filters = [CustomFilter(), CoreFilter()];
/// filters.sort((a, b) {
///   final aPriority = a is PriorityOrdered ? -1 : 0;
///   final bPriority = b is PriorityOrdered ? -1 : 0;
///   return aPriority.compareTo(bPriority) != 0
///       ? aPriority.compareTo(bPriority)
///       : a.order.compareTo(b.order);
/// });
/// ```
/// {@endtemplate}
abstract class PriorityOrdered implements Ordered {
  /// {@macro priority_ordered}
  const PriorityOrdered();
}