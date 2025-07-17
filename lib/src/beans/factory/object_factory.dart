import '../annotations/throws.dart';
import '../exceptions.dart';

/// {@template object_factory}
/// A generic factory interface for producing instances of a given type [T].
///
/// Used by JetLeaf and dependency injection containers to lazily create or
/// retrieve instances of objects—especially in scenarios where you want to
/// delay instantiation until explicitly requested.
///
/// Implementations may return new instances each time, or cache and return
/// the same instance (singleton-style).
///
/// ---
///
/// ### Example
/// ```dart
/// class MyFactory implements ObjectFactory<Foo> {
///   @override
///   Foo getObject() => Foo();
/// }
///
/// final factory = MyFactory();
/// final foo = factory.getObject();
/// ```
///
/// In more complex scenarios, the factory might retrieve from a container:
/// ```dart
/// class BeanFactoryObjectFactory implements ObjectFactory<MyService> {
///   final BeanFactory factory;
///
///   BeanFactoryObjectFactory(this.factory);
///
///   @override
///   MyService getObject() => factory.getBean<MyService>();
/// }
/// ```
/// {@endtemplate}
abstract interface class ObjectFactory<T> {
  /// {@macro object_factory}
  const ObjectFactory();

  /// Returns an instance of the object managed by this factory.
  ///
  /// May throw a [BeansException] if the object could not be created or retrieved.
  ///
  /// {@macro throws}
  @Throws([BeansException])
  T getObject();
}