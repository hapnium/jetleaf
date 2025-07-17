import '../class.dart';
import '../interfaces/reflectable_annotation.dart';
import 'base_class_context.dart';

/// A reflective interface that provides metadata and dynamic access to a Dart class of type [T].
///
/// This interface allows inspection of class members (constructors, fields,
/// methods), type relationships (superclasses, interfaces), annotations, and
/// runtime instantiation of new instances.
///
/// Typically used in frameworks or tools that require runtime type inspection
/// or meta-programming (e.g., dependency injection, serialization, test frameworks).
abstract interface class ClassInfoContext implements BaseClassContext {
  /// Type of the field, wrapped in a [Class] object
  Class<Object> get clazz;

  /// All annotations present on this field
  List<ReflectableAnnotation> get annotations;
}