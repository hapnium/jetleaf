import '../int/int_stream.dart';
import 'double_stream.dart';
import '../../../optional.dart';
import '../int/_int_stream.dart';

/// Private implementation of [DoubleStream] that wraps an [Iterable] of doubles.
///
/// This implementation provides a way to create a [DoubleStream] from an
/// existing [Iterable] of doubles, and also provides methods for performing
/// operations on the stream.
///
/// [DoubleStreamImplementation] is designed to be used as a private
/// implementation of [DoubleStream], and should not be used directly.
///
/// See [DoubleStream] for more information on using streams of doubles.
class DoubleStreamImplementation implements DoubleStream {
  final Iterable<double> _source;
  final bool _parallel;
  final List<void Function()> _closeHandlers;

  DoubleStreamImplementation(this._source, [this._parallel = false, this._closeHandlers = const []]);

  factory DoubleStreamImplementation.of(Iterable<double> values) {
    return DoubleStreamImplementation(values);
  }

  factory DoubleStreamImplementation.empty() {
    return DoubleStreamImplementation(<double>[]);
  }

  @override
  Iterator<double> iterator() => _source.iterator;

  @override
  Iterable<double> iterable() => _source;

  @override
  bool isParallel() => _parallel;

  @override
  DoubleStream sequential() => _parallel ? DoubleStreamImplementation(_source, false, _closeHandlers) : this;

  @override
  DoubleStream parallel() => !_parallel ? DoubleStreamImplementation(_source, true, _closeHandlers) : this;

  @override
  DoubleStream unordered() => this; // For simplicity, return this

  @override
  DoubleStream onClose(void Function() closeHandler) {
    return DoubleStreamImplementation(_source, _parallel, [..._closeHandlers, closeHandler]);
  }

  @override
  void close() {
    for (final handler in _closeHandlers) {
      try {
        handler();
      } catch (e) {
        // Continue executing other handlers even if one fails
      }
    }
  }

  @override
  DoubleStream filter(bool Function(double) predicate) {
    return DoubleStreamImplementation(_source.where(predicate), _parallel, _closeHandlers);
  }

  @override
  DoubleStream map(double Function(double) mapper) {
    return DoubleStreamImplementation(_source.map(mapper), _parallel, _closeHandlers);
  }

  @override
  IntStream mapToInt(int Function(double) mapper) {
    return IntStreamImplementation(_source.map(mapper), _parallel, _closeHandlers);
  }

  @override
  DoubleStream flatMap(DoubleStream Function(double) mapper) {
    return DoubleStreamImplementation(
      _source.expand((element) => mapper(element).iterable()),
      _parallel,
      _closeHandlers,
    );
  }

  @override
  DoubleStream distinct() {
    return DoubleStreamImplementation(_source.toSet(), _parallel, _closeHandlers);
  }

  @override
  DoubleStream sorted() {
    final list = _source.toList()..sort();
    return DoubleStreamImplementation(list, _parallel, _closeHandlers);
  }

  @override
  DoubleStream peek(void Function(double) action) {
    return DoubleStreamImplementation(
      _source.map((element) {
        action(element);
        return element;
      }),
      _parallel,
      _closeHandlers,
    );
  }

  @override
  DoubleStream limit(int maxSize) {
    return DoubleStreamImplementation(_source.take(maxSize), _parallel, _closeHandlers);
  }

  @override
  DoubleStream skip(int n) {
    return DoubleStreamImplementation(_source.skip(n), _parallel, _closeHandlers);
  }

  @override
  DoubleStream takeWhile(bool Function(double) predicate) {
    return DoubleStreamImplementation(_source.takeWhile(predicate), _parallel, _closeHandlers);
  }

  @override
  DoubleStream dropWhile(bool Function(double) predicate) {
    return DoubleStreamImplementation(_source.skipWhile(predicate), _parallel, _closeHandlers);
  }

  @override
  void forEach(void Function(double) action) {
    _source.forEach(action);
  }

  @override
  void forEachOrdered(void Function(double) action) {
    _source.forEach(action); // In sequential context, same as forEach
  }

  @override
  List<double> toList() {
    return _source.toList();
  }

  @override
  double reduce(double identity, double Function(double, double) op) {
    return _source.fold(identity, op);
  }

  @override
  Optional<double> reduceOptional(double Function(double, double) op) {
    if (_source.isEmpty) {
      return Optional.empty<double>();
    }
    return Optional.of(_source.reduce(op));
  }

  @override
  double sum() {
    return _source.fold(0.0, (a, b) => a + b);
  }

  @override
  Optional<double> min() {
    if (_source.isEmpty) {
      return Optional.empty<double>();
    }
    return Optional.of(_source.reduce((a, b) => a < b ? a : b));
  }

  @override
  Optional<double> max() {
    if (_source.isEmpty) {
      return Optional.empty<double>();
    }
    return Optional.of(_source.reduce((a, b) => a > b ? a : b));
  }

  @override
  int count() {
    return _source.length;
  }

  @override
  Optional<double> average() {
    if (_source.isEmpty) {
      return Optional.empty<double>();
    }
    return Optional.of(sum() / count());
  }

  @override
  bool anyMatch(bool Function(double) predicate) {
    return _source.any(predicate);
  }

  @override
  bool allMatch(bool Function(double) predicate) {
    return _source.every(predicate);
  }

  @override
  bool noneMatch(bool Function(double) predicate) {
    return !_source.any(predicate);
  }

  @override
  Optional<double> findFirst() {
    return _source.isEmpty ? Optional.empty<double>() : Optional.of(_source.first);
  }

  @override
  Optional<double> findAny() {
    return findFirst(); // In sequential context, same as findFirst
  }
}