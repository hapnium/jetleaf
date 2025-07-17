import 'package:jetleaf/lang.dart';

import 'property_source.dart';

/// {@template mutable_property_sources}
/// A mutable container for managing an ordered list of [PropertySource] objects.
///
/// This class allows adding, removing, and retrieving property sources dynamically
/// by name or position. It maintains the search order for property resolution,
/// where the first source added has the highest precedence during lookups.
///
/// This container is typically passed to a [PropertySourcesPropertyResolver]
/// to resolve environment or configuration properties.
///
/// ### Example usage:
///
/// ```dart
/// final sources = MutablePropertySources();
///
/// final defaults = MapPropertySource('defaults', {'debug': 'false'});
/// final env = MapPropertySource('env', {'debug': 'true'});
///
/// sources.addLast(defaults);
/// sources.addFirst(env); // env now has higher precedence
///
/// final value = sources.get('env')?.getProperty('debug'); // 'true'
///
/// sources.remove('defaults');
/// ```
///
/// ### Ordering Methods
/// You can control precedence using:
/// - [addFirst]
/// - [addLast]
/// - [addBefore]
/// - [addAfter]
///
/// This is particularly useful for layered configuration such as:
/// command-line args > environment variables > default config.
/// {@endtemplate}
class MutablePropertySources extends Iterable<PropertySource> {
  final List<PropertySource> _sources = [];

  /// {@macro mutable_property_sources}
  MutablePropertySources();

  /// Adds a [PropertySource] to the beginning of the list.
  ///
  /// Gives it the highest precedence during resolution.
  void addFirst(PropertySource source) {
    _sources.insert(0, source);
  }

  /// Adds a [PropertySource] to the end of the list.
  ///
  /// Gives it the lowest precedence.
  void addLast(PropertySource source) {
    _sources.add(source);
  }

  /// Inserts a [newSource] before the named [relativeSourceName] in the list.
  ///
  /// Throws if the referenced source is not found.
  void addBefore(String relativeSourceName, PropertySource newSource) {
    final index = _sources.indexWhere((s) => s.name == relativeSourceName);
    if (index == -1) throw Exception("No such property source: $relativeSourceName");
    _sources.insert(index, newSource);
  }

  /// Inserts a [newSource] after the named [relativeSourceName] in the list.
  ///
  /// Throws if the referenced source is not found.
  void addAfter(String relativeSourceName, PropertySource newSource) {
    final index = _sources.indexWhere((s) => s.name == relativeSourceName);
    if (index == -1) throw Exception("No such property source: $relativeSourceName");
    _sources.insert(index + 1, newSource);
  }

  /// Removes the [PropertySource] with the given [name].
  ///
  /// Returns `true` if the source was found and removed, `false` otherwise.
  bool remove(String name) {
    final index = _sources.indexWhere((s) => s.name == name);
    if (index == -1) return false;
    _sources.removeAt(index);
    return true;
  }

  /// Retrieves the [PropertySource] with the given [name], or `null` if not found.
  PropertySource? get(String name) {
    return _sources.find((s) => s.name == name);
  }

  /// Appends all the given [sources] to the list in order.
  void addAll(List<PropertySource> sources) {
    _sources.addAll(sources);
  }

  @override
  Iterator<PropertySource> get iterator => _sources.iterator;
}