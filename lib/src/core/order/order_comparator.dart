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

import 'order_source_provider.dart';
import 'ordered.dart';
import 'priority_ordered.dart';

/// {@template order_comparator}
/// A comparator that sorts objects based on the [Ordered] and [PriorityOrdered] interfaces.
///
/// This is used throughout JetLeaf to impose deterministic, precedence-based ordering.
/// Objects that implement [PriorityOrdered] will come before those that only implement [Ordered].
///
/// If neither interface is implemented, objects will be ordered using
/// [Ordered.LOWEST_PRECEDENCE].
///
/// ---
///
/// ### 🔧 Example
/// ```dart
/// final items = [ComponentA(), ComponentB()];
/// OrderComparator.sortList(items);
/// ```
///
/// ---
///
/// ### 🔄 With Order Source Provider
/// ```dart
/// final comparator = OrderComparator.INSTANCE.withSourceProvider(mySourceProvider);
/// items.sort(comparator);
/// ```
///
/// {@endtemplate}
class OrderComparator implements Comparable<Object> {
  /// Singleton INSTANCE of the comparator.
  static final OrderComparator INSTANCE = OrderComparator();

  /// {@macro order_comparator}
  const OrderComparator();

  /// Returns a new comparator that uses the given [OrderSourceProvider]
  /// to determine order metadata indirectly from an associated source.
  ///
  /// {@macro order_comparator}
  Comparator<Object> withSourceProvider(OrderSourceProvider sourceProvider) {
    return (o1, o2) => _doCompare(o1, o2, sourceProvider);
  }

  /// Compares two objects using order metadata.
  ///
  /// Returns:
  /// - `-1` if [o1] should come before [o2]
  /// - `1` if [o2] should come before [o1]
  /// - `0` if order is equal
  int compare(Object? o1, Object? o2) => _doCompare(o1, o2, null);

  int _doCompare(Object? o1, Object? o2, OrderSourceProvider? provider) {
    final p1 = o1 is PriorityOrdered;
    final p2 = o2 is PriorityOrdered;

    if (p1 && !p2) return -1;
    if (p2 && !p1) return 1;

    final i1 = getOrder(o1, provider);
    final i2 = getOrder(o2, provider);
    return i1.compareTo(i2);
  }

  /// Resolves the order value of the given object.
  ///
  /// Uses the [provider] to look for alternative metadata, if provided.
  int getOrder(Object? obj, OrderSourceProvider? provider) {
    int? order;
    if (obj != null && provider != null) {
      final source = provider.getOrderSource(obj);
      if (source != null) {
        if (source is Iterable) {
          for (final s in source) {
            order = _findOrder(s);
            if (order != null) break;
          }
        } else {
          order = _findOrder(source);
        }
      }
    }
    return order ?? _getOrder(obj);
  }

  int _getOrder(Object? obj) => _findOrder(obj) ?? Ordered.LOWEST_PRECEDENCE;

  int? _findOrder(Object? obj) => obj is Ordered ? obj.order : null;

  /// Optionally override this to expose a numeric "priority" classification.
  ///
  /// By default, this returns `null`.
  int? getPriority(Object obj) => null;

  /// Sorts the given [list] using this comparator.
  static void sortList(List<Object> list) {
    if (list.length > 1) {
      list.sort(INSTANCE.compare);
    }
  }

  /// Alias for [sortList].
  static void sortArray(List<Object> array) => sortList(array);

  /// Sorts the given [value] if it's a `List<Object>`.
  ///
  /// Safe no-op for other types.
  static void sortIfNecessary(Object? value) {
    if (value is List<Object>) {
      sortList(value);
    }
  }

  @override
  int compareTo(Object other) {
    return compare(this, other);
  }
}