/// An interface representing an entity that has a type descriptor.
///
/// This is a Dart adaptation of the Java `TypeDescriptor` interface.
/// It provides methods to describe type information in a structured form,
/// useful for reflection or symbolic representation.
///
/// Based on the Java version introduced in JDK 12.
abstract interface class TypeDescriptor {
  /// Returns the descriptor string for this `TypeDescriptor` object.
  ///
  /// This string should follow a format similar to JVM type descriptors
  /// and can be used for symbolic type representation.
  ///
  /// See:
  /// - JVMS §4.3.2 Field Descriptors
  /// - JVMS §4.3.3 Method Descriptors
  ///
  /// Returns a descriptor string representing this type.
  String descriptorString();
}

/// Represents an entity with a field type descriptor.
///
/// Field descriptors typically describe primitive types, arrays, or
/// object types in a symbolic way.
abstract class TypeDescriptorOfField<F extends TypeDescriptorOfField<F>> implements TypeDescriptor {
  /// Whether this field descriptor represents an array type.
  bool isArray();

  /// Whether this field descriptor represents a primitive type
  /// (including `void`).
  bool isPrimitive();

  /// If this field descriptor is an array, returns its component type.
  ///
  /// Returns `null` if this descriptor is not an array.
  F? componentType();
}

/// Represents an entity with a method type descriptor.
///
/// This includes methods' return types and their parameter types.
abstract class TypeDescriptorOfMethod<F extends TypeDescriptorOfField<F>, M extends TypeDescriptorOfMethod<F, M>> implements TypeDescriptor {
  /// Returns the number of parameters for this method descriptor.
  int parameterCount();

  /// Returns the field type descriptor of the parameter at the given index.
  ///
  /// Throws [RangeError] if the index is out of bounds.
  F parameterType(int i);

  /// Returns the field type descriptor of the return type.
  F returnType();

  /// Returns a list of field type descriptors for the method parameters.
  List<F> parameterList();

  /// Returns an array (List) of field type descriptors for method parameters.
  ///
  /// Equivalent to [parameterList] but returns a raw array.
  List<F> parameterArray() => parameterList();

  /// Returns a copy of this method descriptor with a different return type.
  ///
  /// Throws [InvalidArgumentException] if `newReturn` is `null`.
  M changeReturnType(F newReturn);

  /// Returns a copy of this method descriptor with the type of a single
  /// parameter changed.
  ///
  /// Throws [RangeError] if `index` is out of bounds,
  /// or [InvalidArgumentException] if `paramType` is `null`.
  M changeParameterType(int index, F paramType);

  /// Returns a copy of this method descriptor with parameters in the
  /// range [start, end) removed.
  ///
  /// Throws [RangeError] if indices are invalid.
  M dropParameterTypes(int start, int end);

  /// Returns a copy of this method descriptor with parameters inserted
  /// at the specified position.
  ///
  /// Throws [InvalidArgumentException] if any argument is `null`,
  /// or [RangeError] if `pos` is invalid.
  M insertParameterTypes(int pos, List<F> paramTypes);
}

/// `ValueType` is the common superinterface for all type constructs in Dart.
///
/// This is a Dart adaptation of Java's `java.lang.reflect.Type`.
/// It is used to represent various kinds of types, including raw types,
/// parameterized types, array types, type variables, and primitive types,
/// in a reflective or symbolic manner.
///
/// This abstraction enables runtime inspection or analysis of types
/// without direct reliance on static declarations.
///
/// ### Java Language Specification (JLS) References:
/// - §4.1 The Kinds of Types and Values
/// - §4.2 Primitive Types and Values
/// - §4.3 Reference Types and Values
/// - §4.4 Type Variables
/// - §4.5 Parameterized Types
/// - §4.8 Raw Types
/// - §4.9 Intersection Types
/// - §10.1 Array Types
abstract class ValueType {
  /// Returns a string describing this type, including any generic
  /// parameters or array information.
  ///
  /// This is the Dart equivalent of Java's `getTypeName()` method.
  ///
  /// If not overridden, defaults to [toString()].
  String get typeName => toString();
}