import '../class.dart';
import '../interfaces/reflectable_annotation.dart';

/// {@template typeVariableInfo}
/// Provides metadata and utilities for a class type variable obtained via Jet Reflection.
/// 
/// Use this class to introspect a type variable's characteristics, annotations, and upper bound,
/// or to dynamically invoke methods with type variables.
/// 
/// Example:
/// ```dart
/// final typeVariable = ClassMirror.forType<MyClass>().getTypeVariable('T');
/// final info = ClassTypeVariableInfo.fromJetMirror(typeVariable);
/// final upperBound = info.getUpperBound();
/// ```
/// 
/// {@endtemplate}
class ClassTypeVariableInfo {
  final String name;
  final String qualifiedName;
  final Class<Object> upperBound;
  final List<ReflectableAnnotation> annotations;
  
  /// {@macro typeVariableInfo}
  ClassTypeVariableInfo({
    required this.name,
    required this.qualifiedName,
    required this.upperBound,
    required this.annotations,
  });
  
  @override
  String toString() => 'TypeVariableInfo($name)';
}