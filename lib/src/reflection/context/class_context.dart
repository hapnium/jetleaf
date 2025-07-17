import '../mirrors/class_mirror.dart';
import '../models/type_variable_info.dart';
import '../class.dart';
import '../models/constructor_info.dart';
import '../models/field_info.dart';
import '../models/method_info.dart';
import '../runtime_class.dart';
import 'base_class_context.dart';

/// An abstract reflective interface that provides metadata and dynamic access
/// to a Dart class of type [T].
///
/// This interface allows inspection of class members (constructors, fields,
/// methods), type relationships (superclasses, interfaces), annotations, and
/// runtime instantiation of new instances.
///
/// Typically used in frameworks or tools that require runtime type inspection
/// or meta-programming (e.g., dependency injection, serialization, test frameworks).
abstract interface class ClassContext<T> implements BaseClassContext {
  /// Whether the class is declared as `abstract`.
  bool get isAbstract;

  /// Whether the class represents an `enum`.
  bool get isEnum;

  /// Whether the class is private (name starts with `_`).
  ///
  /// Private classes are only visible within their own library.
  bool get isPrivate;

  /// Whether the class is a top-level class (not a nested/local class).
  bool get isTopLevel;

  /// Whether this type is an interface or mixin.
  ///
  /// This is typically `true` for abstract classes used solely for implementation
  /// inheritance or mixins.
  bool get isInterface;

  /// Returns the low-level [ClassMirror] associated with this class.
  ///
  /// Mirrors provide deeper runtime introspection capabilities.
  ClassMirror<T> get mirror;

  /// The underlying Dart type represented by this class.
  ///
  /// Example:
  /// ```dart
  /// BaseClassContext<User>().type => User
  /// ```
  Type get type;

  /// Creates a new instance of the class with the provided constructor arguments.
  ///
  /// Supports both positional and named parameters.
  ///
  /// Example:
  /// ```dart
  /// final user = BaseClassContext<User>().newInstance(['John'], {#age: 30});
  /// ```
  T newInstance([List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]);

  /// Creates a new instance by assigning values to fields directly (bypassing constructor).
  ///
  /// Useful in deserialization where constructors are not reflective or incomplete.
  ///
  /// Example:
  /// ```dart
  /// final user = BaseClassContext<User>().newInstanceWithFields({'name': 'Alice'});
  /// ```
  T newInstanceWithFields(Map<String, Object?> fieldValues);

  /// Compares this class with another for equality based on type identity.
  ///
  /// Equivalent to `this == other` semantically, but may use type information
  /// instead of just identity comparison.
  bool equals(Class<Object> other);

  /// Returns the direct superclass of this class, or `null` if there is none.
  ///
  /// This does not include interfaces or mixins.
  Class<Object>? getSuperclass();

  /// Returns the direct superinterfaces of this class, or `null` if there is none.
  Class<T>? getSuperClass<U>();

  /// Returns a list of superinterfaces (i.e., implemented interfaces or mixins).
  ///
  /// The list may be empty if the class does not implement any interfaces.
  List<Class<Object>> getSuperinterfaces();

  /// Returns `true` if this class is a subclass of [other].
  ///
  /// Includes transitive inheritance. Returns `false` if [other] is not in
  /// this class’s hierarchy.
  bool isSubclassOf(Class<Object> other);

  /// Returns `true` if this class is a subclass of [other].
  ///
  /// Includes transitive inheritance. Returns `false` if [other] is not in
  /// this class’s hierarchy.
  bool isSubTypeOf<U>();

  /// Returns `true` if [object] is an instance of this class.
  ///
  /// Use this method to perform runtime type checks using the reflective model.
  bool isInstance(Object? object);

  /// Returns `true` if this class is a subinterface of [other].
  ///
  /// Applies only to interfaces and mixins. For class-based inheritance,
  /// use [isSubclassOf].
  bool isSubinterfaceOf(Class<Object> other);

  /// Returns `true` if this class is the same as or a subclass or subinterface of [other].
  ///
  /// Similar to Dart’s `isAssignableFrom` semantic — [other] can be assigned from this class.
  bool isAssignableFrom(Class<Object> other);

  /// Returns a map of method names to method metadata for all declared methods.
  ///
  /// Declared methods are those defined in the class itself, excluding inherited ones.
  Map<String, ClassMethodInfo> getDeclaredMethods();

  /// Returns a map of method names to method metadata including inherited methods.
  ///
  /// This includes declared methods and those inherited from superclasses and interfaces.
  Map<String, ClassMethodInfo> getMethods();

  /// Returns metadata about a specific method by name, or `null` if not found.
  ///
  /// Includes both declared and inherited methods.
  ClassMethodInfo? getMethod(String name);

  /// Returns metadata about a specific field by name, or `null` if not found.
  ///
  /// Includes both declared and inherited fields.
  ClassFieldInfo? getField(String name);

  /// Returns a map of field names to metadata for fields declared in the class.
  ///
  /// Does not include fields inherited from superclasses or interfaces.
  Map<String, ClassFieldInfo> getDeclaredFields();

  /// Returns a map of field names to metadata for all accessible fields.
  ///
  /// Includes both declared and inherited fields.
  Map<String, ClassFieldInfo> getFields();

  /// Returns the metadata of a constructor by [name], or `null` if not found.
  ///
  /// If [name] is omitted or an empty string, it returns the default (unnamed) constructor.
  ClassConstructorInfo? getConstructor([String name = '']);

  /// Returns a map of constructor names to their metadata.
  ///
  /// The default (unnamed) constructor has an empty string (`''`) as the key.
  Map<String, ClassConstructorInfo> getConstructors();

  /// Creates a new instance of [T] using a named constructor.
  ///
  /// - [constructorName]: the name of the constructor.
  /// - [positionalArgs]: list of positional arguments.
  /// - [namedArgs]: map of named arguments, using [Symbol] keys.
  ///
  /// Throws if the constructor is not available or arguments do not match.
  T newInstanceNamed(String constructorName, [List<Object?> positionalArgs = const [], Map<Symbol, Object?> namedArgs = const {}]);

  /// Returns the list of type variable metadata for this class.
  ///
  /// Useful for inspecting generic parameter information, e.g. `T` in `List<T>`.
  List<ClassTypeVariableInfo> getTypeVariables();

  /// Returns the list of actual type arguments used in this instantiation.
  ///
  /// For example, if the class is `List<String>`, this will return `[Class<String>]`.
  List<Class<Object>> getTypeArguments();

  /// Returns `true` if this class declares generic type parameters.
  ///
  /// Example: `Map<K, V>` is generic, but `Map<String, int>` is not.
  bool get isGeneric;

  /// Returns `true` if this class is the original declaration (not a specialization).
  ///
  /// Example: For `Map<K, V>` returns `true`, but for `Map<String, int>` returns `false`.
  bool get isOriginalDeclaration;

  /// Returns the generic base class for this specialization.
  ///
  /// For example, calling this on `Map<String, int>` would return `Map<K, V>`.
  Class<T> getOriginalDeclaration();

  /// Returns the array type of this class.
  /// 
  /// {@macro runtime_class}
  RuntimeClass arrayType();

  /// Returns the object cast to this class.
  /// 
  /// **Type Parameters:**
  /// - [U]: The type to cast the object to.
  U cast<U>();

  /// Returns the list of enum values for this class.
  /// 
  /// **Type Parameters:**
  /// - [A]: The enum type.
  List<A> getEnumValues<A extends Enum>();
}