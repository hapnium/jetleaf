import '../class.dart';
import '../context/class_info_context.dart';
import '../interfaces/reflectable_annotation.dart';
import '../mirrors/class_mirror.dart';
import '../mirrors/constructor_mirror.dart';
import 'parameter_info.dart';

/// {@template constructorInfo}
/// Provides metadata and utilities for a class constructor obtained via Jet Reflection.
/// 
/// Use this class to introspect a constructor's characteristics, annotations, and parameters,
/// or to dynamically instantiate objects.
/// 
/// Example:
/// ```dart
/// final constructor = MyClass.getConstructors().first;
/// final info = ClassConstructorInfo.fromJetMirror(constructor);
/// final instance = info.newInstance([arg1, arg2]);
/// ```
/// 
/// {@endtemplate}
class ClassConstructorInfo implements ClassInfoContext {
  final ConstructorMirror _jetleafMirror;

  /// {@macro constructorInfo}
  /// Creates a [ClassConstructorInfo] from a [ConstructorMirror].
  ClassConstructorInfo.fromJetMirror(this._jetleafMirror);

  /// Whether the constructor is declared as `const`
  bool get isConst => _jetleafMirror.isConst();

  /// Whether this is a `factory` constructor
  bool get isFactory => _jetleafMirror.isFactory();

  /// Whether this is a generative constructor (not factory or redirecting)
  bool get isGenerative => _jetleafMirror.isGenerative();

  /// Whether this is a redirecting constructor (e.g., `Foo.redirect() : this.other();`)
  bool get isRedirecting => _jetleafMirror.isRedirecting();

  /// Whether the constructor is private (starts with `_`)
  bool get isPrivate => _jetleafMirror.isPrivate();

  /// Whether the constructor is the unnamed (default) one
  bool get isDefault => _jetleafMirror.isDefault();

  /// Parameters of this constructor
  List<ClassParameterInfo> get parameters => _jetleafMirror.getParameters().map((p) => ClassParameterInfo.fromJetMirror(p)).toList();

  /// Creates a new instance using this constructor with the provided arguments.
  /// 
  /// [positionalArgs] are matched in order to constructor parameters.
  /// [namedArgs] should use [Symbol]s matching parameter names.
  Object newInstance([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]) {
    try {
      return _jetleafMirror.newInstance(positionalArgs, namedArgs);
    } catch (e) {
      rethrow;
    }
  }

  @override
  String get simpleName => _jetleafMirror.getSimpleName();

  @override
  String get qualifiedName => _jetleafMirror.getQualifiedName();

  @override
  Class<Object> get clazz => Class.fromType(_jetleafMirror.runtimeType);

  @override
  List<ReflectableAnnotation> get annotations => _jetleafMirror.getAnnotations();

  @override
  bool hasAnnotation<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return _jetleafMirror.isAnnotationPresent(annotationType);
    } catch (e) {
      return false;
    }
  }

  @override
  A? getAnnotationByType<A extends ReflectableAnnotation>() {
    try {
      final annotationType = ClassMirror.forType<A>();
      return _jetleafMirror.getAnnotation(annotationType);
    } catch (e) {
      return null;
    }
  }

  @override
  String toString() => 'ConstructorInfo($simpleName)';
}