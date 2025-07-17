import 'package:jetleaf/reflection.dart';
import 'package:meta/meta_meta.dart';

/// {@template throws}
/// Declares the exception type that a method or constructor might throw.
///
/// This annotation is used for documentation and reflection purposes only.
/// It does not enforce exception behavior at runtime, but can be used by tools,
/// IDEs, or frameworks like JetLeaf to analyze or generate exception-related
/// metadata.
///
/// ---
///
/// ### Usage
/// ```dart
/// class MyService {
///   @Throws([MyException])
///   void riskyMethod() {
///     throw MyException('Failure');
///   }
/// }
/// ```
///
/// The annotated method can then be introspected using reflection to
/// determine what exceptions it declares.
///
/// > Multiple `@Throws(...)` annotations can be applied if desired,
/// > but Dart does not support repeatable annotations natively.
///
/// ---
///
/// ### Framework Use Case
/// Used internally in the JetLeaf framework to tag methods for tooling,
/// safety warnings, or to generate exception-related metadata.
///
/// {@endtemplate}
@Target({TargetKind.method, TargetKind.constructor})
class Throws extends ReflectableAnnotation {
  /// The type of exception this method or constructor may throw.
  final List<Type> exceptionTypes;

  /// {@macro throws}
  const Throws(this.exceptionTypes);

  @override
  Type get annotationType => Throws;
}