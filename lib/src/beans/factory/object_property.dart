import 'package:jetleaf/core.dart';
import 'package:jetleaf/lang.dart';
import 'package:jetleaf/reflection.dart';

import '../annotations/throws.dart';
import '../exceptions.dart';
import 'object_factory.dart';

/// {@template object_provider}
/// A flexible, functional-style provider interface for retrieving and interacting with
/// beans or objects of a particular type.
///
/// This is an extension of [ObjectFactory] and [Iterable] that provides advanced options
/// for conditional retrieval, functional callbacks, filtering, and ordering.
///
/// ---
///
/// ### 🚀 Usage
///
/// ```dart
/// final ObjectProvider<MyService> provider = ...;
///
/// // Get the object, or throw if none or multiple exist
/// MyService service = provider.getObject();
///
/// // Get if available, or null if none exist
/// MyService? maybeService = provider.getIfAvailable();
///
/// // Get a default if not present
/// MyService service = provider.getIfAvailableOrDefault(() => MyService());
///
/// // Use a consumer if available
/// provider.ifAvailable((s) => s.start());
///
/// // Stream through all instances
/// provider.stream().forEach(print);
/// ```
///
/// ---
///
/// ### 🔍 Filtering and Ordering
/// You can stream all matching beans ordered by [Ordered] or [PriorityOrdered]:
///
/// ```dart
/// provider.orderedStream().forEach(print);
/// ```
///
/// Or with a custom type filter (using your [Class<T>] metadata):
///
/// ```dart
/// provider.orderedStreamWithFilter((clazz) => clazz.name.contains('MyType'));
/// ```
///
/// Note: By default, non-singletons are included. Support for filtering them is not yet implemented.
/// {@endtemplate}
abstract interface class ObjectProvider<T> implements ObjectFactory<T>, Iterable<T> {
  /// {@macro object_provider}

  /// A filter that accepts all classes.
  Predicate<Class<dynamic>> UNFILTERED = (clazz) => true;

  /// Retrieves the single object instance or throws if none or more than one found.
  ///
  /// {@macro Throws}
  /// - [NoSuchBeanDefinitionException] if no matching object exists.
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  @override
  @Throws([NoSuchBeanDefinitionException, NoUniqueBeanDefinitionException])
  T getObject() {
    final it = iterate();
    if (!it.moveNext()) {
      throw NoSuchBeanDefinitionException(this.toString());
    }
    final result = it.current;
    if (it.moveNext()) {
      throw NoUniqueBeanDefinitionException("${this.toString()} has more than 1 matching bean");
    }

    return result;
  }

  /// Retrieves the object with explicit arguments, if supported.
  ///
  /// By default, this operation is not supported and throws [UnsupportedOperationException].
  @Throws([UnsupportedOperationException])
  T getObjectWithArgs(List<Object?> args) => throw UnsupportedOperationException('Retrieval with arguments not supported');

  /// Retrieves the object if available, or returns `null` if none exist.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  T? getIfAvailable() {
    try {
      return getObject();
    } on NoUniqueBeanDefinitionException {
      rethrow;
    } on NoSuchBeanDefinitionException {
      return null;
    }
  }

  /// Retrieves the object if available, or calls [defaultSupplier] if not.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  T getIfAvailableOrDefault(Supplier<T> defaultSupplier) => getIfAvailable() ?? defaultSupplier.call();

  /// Executes [dependencyConsumer] if the object is available.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  void ifAvailable(Consumer<T> dependencyConsumer) {
    final dependency = getIfAvailable();
    if (dependency != null) {
      dependencyConsumer.call(dependency);
    }
  }

  /// Retrieves the object only if exactly one instance exists, or returns `null`.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  T? getIfUnique() {
    try {
      return getObject();
    } on NoSuchBeanDefinitionException {
      return null;
    }
  }

  /// Retrieves the object if unique, or calls [defaultSupplier] if not.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  T getIfUniqueOrDefault(Supplier<T> defaultSupplier) => getIfUnique() ?? defaultSupplier.call();

  /// Executes [dependencyConsumer] only if exactly one instance is available.
  ///
  /// {@macro Throws}
  /// - [NoUniqueBeanDefinitionException] if more than one matching object exists.
  void ifUnique(Consumer<T> dependencyConsumer) {
    final dependency = getIfUnique();
    if (dependency != null) {
      dependencyConsumer.call(dependency);
    }
  }

  /// Returns an [Iterator] over the available objects.
  Iterator<T> iterate() => stream().iterator();

  /// Returns a [GenericStream] of all available objects.
  GenericStream<T> stream() => GenericStream.of(this);

  /// Returns a stream of objects ordered by [OrderComparator].
  GenericStream<T> orderedStream() => stream().sorted(OrderComparator.INSTANCE.compare);

  /// Filters the stream using a [customFilter] and optional singleton-only flag.
  ///
  /// If [includeNonSingletons] is false, an [UnsupportedOperationException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// provider.streamWithFilter((clazz) => clazz.name.contains('Foo'));
  /// ```
  @Throws([UnsupportedOperationException])
  GenericStream<T> streamWithFilter(Predicate<Class<T>> customFilter, {bool includeNonSingletons = true}) {
    if (!includeNonSingletons) {
      throw UnsupportedOperationException('Only supports includeNonSingletons=true by default');
    }
    return stream()..where((obj) => customFilter(obj.runtimeType as Class<T>));
  }

  /// Filters and sorts the stream using [customFilter] and [OrderComparator].
  ///
  /// If [includeNonSingletons] is false, an [UnsupportedOperationException] is thrown.
  ///
  /// Example:
  /// ```dart
  /// provider.orderedStreamWithFilter((clazz) => clazz.hasAnnotation<@Special>());
  /// ```
  @Throws([UnsupportedOperationException])
  GenericStream<T> orderedStreamWithFilter(Predicate<Class<T>> customFilter, {bool includeNonSingletons = true}) {
    if (!includeNonSingletons) {
      throw UnsupportedOperationException('Only supports includeNonSingletons=true by default');
    }
    return orderedStream().where((obj) => customFilter(obj.runtimeType as Class<T>));
  }
}