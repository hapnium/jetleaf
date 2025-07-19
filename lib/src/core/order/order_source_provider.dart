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

/// {@template order_source_provider}
/// A strategy interface for providing an alternative source of order metadata
/// for a given object.
///
/// This is useful when sorting or prioritizing objects based on external metadata
/// rather than relying solely on their own [Ordered] or [PriorityOrdered] interface.
///
/// For example, an object may not directly implement [Ordered], but its order
/// may be derived from another associated object (its “order source”).
///
/// ---
///
/// ### ⚙️ How It Works:
/// - The provided [getOrderSource] method may return:
///   - A single object that implements [Ordered]
///   - An [Iterable] of multiple such objects
///   - `null` if no order source is available
///
/// ---
///
/// ### 📌 Example
/// ```dart
/// class BeanOrderSourceProvider extends OrderSourceProvider {
///   final Map<Object, Object> _orderSources;
///
///   BeanOrderSourceProvider(this._orderSources);
///
///   @override
///   Object? getOrderSource(Object obj) => _orderSources[obj];
/// }
/// ```
///
/// This allows indirect ordering via metadata while keeping the target class clean.
///
/// {@endtemplate}
abstract class OrderSourceProvider {
  /// {@macro order_source_provider}
  const OrderSourceProvider();

  /// {@macro order_source_provider}
  Object? getOrderSource(Object obj);
}