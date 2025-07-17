/// {@template annotation}
/// A common interface implemented by all Dart annotations.
///
/// Note that extending this interface manually does **not** make a class an annotation.
/// This interface exists purely to provide reflective access and type checks
/// on annotations. For further information on annotations and their metadata,
/// refer to the Dart documentation on annotations.
///
/// Originally adapted from Java's `java.lang.annotation.Annotation`.
/// 
/// {@endtemplate}
abstract class Annotation {
  /// {@macro annotation}
  const Annotation();

  /// Checks whether the given object is logically equivalent to this annotation.
  ///
  /// Logical equivalence means:
  /// - Same runtime type (implements same annotation interface)
  /// - All fields/members of both annotations are equal
  ///
  /// Value comparison rules:
  /// - Primitive types: compared via `==`
  /// - `double`/`float`: compared via `.equals`, treating `NaN == NaN`, and `0.0 != -0.0`
  /// - Strings, Classes, Enums, and other annotations: compared via `.equals`
  /// - Arrays: compared via deep equality (like `ListEquality`) for respective element types
  ///
  /// Returns `true` if equivalent, `false` otherwise.
  bool equals(Object other);

  /// Returns a hash code consistent with equality definition.
  ///
  /// Hash is calculated as the sum of hash codes of all members (including default values).
  /// For each member, hash is:
  /// `(127 * memberName.hashCode) ^ memberValue.hashCode`
  ///
  /// The value hash code rules:
  /// - Primitives: use wrapper hash codes (e.g., `int.hashCode`)
  /// - Enums, Strings, Classes, Annotations: `.hashCode`
  /// - Arrays/lists: use deep hash from list contents
  @override
  int get hashCode;

  /// Returns a string representation of this annotation.
  ///
  /// Example format:
  /// ```
  ///   @example.Annotation(key="value", flag=true)
  /// ```
  /// Actual representation may differ by implementation.
  @override
  String toString();
  
  @override
  bool operator ==(Object other) {
    return this == other;
  }
  
  // /// Returns the annotation type/interface this instance represents.
  // ///
  // /// This is equivalent to getting the runtime type of the annotation
  // /// interface itself (not the implementation or proxy).
  // ///
  // /// For example:
  // /// ```dart
  // /// annotation.annotationType == MyAnnotation
  // /// ```
  // Class<T> annotationType<T extends Annotation>();
}