/// {@template reflectionException}
/// Base class for all reflection-related exceptions.
/// 
/// This class serves as the parent for all exceptions that can be thrown
/// during reflection operations, providing a common interface for handling
/// reflection errors.
/// 
/// {@endtemplate}
abstract class ReflectionException implements Exception {
  /// The error message
  final String message;
  
  /// The underlying cause of this exception, if any.
  final Object? cause;

  /// {@macro reflectionException}
  ReflectionException(this.message, {this.cause});
  
  @override
  String toString() => 'ReflectionException: $message';
}

/// {@template abstractClassInstantiationException}
/// Thrown when an application tries to reflectively create an instance
/// of an abstract class.
/// 
/// This exception is thrown when attempting to instantiate a class that
/// is declared as abstract, which is not allowed in Dart.
/// 
/// {@endtemplate}
class AbstractClassInstantiationException extends ReflectionException {
  /// The name of the abstract class that couldn't be instantiated.
  final String className;
  
  /// {@macro abstractClassInstantiationException}
  AbstractClassInstantiationException(this.className) : super('Cannot instantiate abstract class: $className');
  
  @override
  String toString() => 'AbstractClassInstantiationException: Cannot instantiate abstract class: $className';
}

/// {@template noSuchClassMethodException}
/// Thrown when a particular method cannot be found.
/// 
/// This exception is thrown when attempting to access a method that
/// doesn't exist on the target class or when the method signature
/// doesn't match the expected parameters.
/// 
/// {@endtemplate}
class NoSuchClassMethodException extends ReflectionException {
  /// The name of the method that couldn't be found.
  final String methodName;
  
  /// The class where the method was expected to be found.
  final String className;
  
  /// {@macro noSuchClassMethodException}
  NoSuchClassMethodException(this.methodName, this.className) : super('Method "$methodName" not found in class "$className"');
  
  @override
  String toString() => 'NoSuchMethodException: Method "$methodName" not found in class "$className"';
}

/// {@template noSuchMethodConstructorException}
/// Thrown when a particular constructor cannot be found.
/// 
/// This exception is thrown when attempting to access a constructor that
/// doesn't exist on the target class or when the constructor signature
/// doesn't match the expected parameters.
/// 
/// {@endtemplate}
class NoSuchConstructorException extends ReflectionException {
  /// The name of the constructor that couldn't be found.
  final String constructorName;
  
  /// The class where the constructor was expected to be found.
  final String className;
  
  /// {@macro noSuchMethodConstructorException}
  NoSuchConstructorException(this.constructorName, this.className) : super('Constructor "$constructorName" not found in class "$className"');
  
  @override
  String toString() => 'NoSuchConstructorException: Constructor "$constructorName" not found in class "$className"';
}

/// {@template noSuchClassFieldException}
/// Thrown when a particular field cannot be found.
/// 
/// This exception is thrown when attempting to access a field that
/// doesn't exist on the target class or when access is denied due
/// to visibility restrictions.
/// 
/// {@endtemplate}
class NoSuchFieldException extends ReflectionException {
  /// The name of the field that couldn't be found.
  final String fieldName;
  
  /// The class where the field was expected to be found.
  final String className;
  
  /// {@macro noSuchClassFieldException}
  NoSuchFieldException(this.fieldName, this.className) : super('Field "$fieldName" not found in class "$className"');
  
  @override
  String toString() => 'NoSuchFieldException: Field "$fieldName" not found in class "$className"';
}

/// {@template illegalTypeAccessException}
/// Thrown when an application tries to access or modify a field, or
/// to call a method that it does not have access to.
/// 
/// This exception is thrown when attempting to access private members
/// without proper permissions or when security restrictions prevent
/// the requested operation.
/// 
/// {@endtemplate}
class IllegalTypeAccessException extends ReflectionException {
  /// The name of the member that couldn't be accessed.
  final String memberName;
  
  /// {@macro illegalTypeAccessException}
  IllegalTypeAccessException(this.memberName) : super('Cannot access member: $memberName');
  
  @override
  String toString() => 'IllegalAccessException: Cannot access member: $memberName';
}

/// {@template classInstantiationException}
/// 
/// Thrown when an application tries to create an instance of a class
/// using the newInstance method in class Class, but the specified
/// class object cannot be instantiated.
/// 
/// This exception can be thrown for various reasons, such as the class
/// being an interface, an abstract class, an array class, a primitive
/// type, or void; or the class has no nullary constructor.
/// 
/// {@endtemplate}
class ClassInstantiationException extends ReflectionException {
  /// The name of the class that couldn't be instantiated.
  final String? className;

  final String? error;
  
  /// {@macro classInstantiationException}
  ClassInstantiationException(this.error, [this.className]) : super(error ?? 'Cannot instantiate class: $className');

  /// The error message.
  String get detailedMessage => error ?? 'Cannot instantiate class: $className';

  final String _key = "InstantiationException: ";
  
  @override
  String toString() => '$_key${detailedMessage.replaceAll(_key, "")}';
}

/// {@template illegalArgumentTypeException}
/// Thrown when a method is passed an illegal or inappropriate argument.
/// 
/// This exception is thrown during reflection operations when the
/// provided arguments don't match the expected types or when invalid
/// values are passed to reflection methods.
/// 
/// {@endtemplate}
class IllegalArgumentTypeException extends ReflectionException {
  /// {@macro illegalArgumentTypeException}
  IllegalArgumentTypeException(super.message);
  
  @override
  String toString() => 'IllegalArgumentException: $message';
}

/// {@template reflectionSecurityException}
/// Thrown to indicate that a security violation has occurred.
/// 
/// This exception is thrown when attempting to perform reflection
/// operations that are not allowed due to security restrictions.
/// 
/// {@endtemplate}
class ReflectionSecurityException extends ReflectionException {
  /// {@macro reflectionSecurityException}
  ReflectionSecurityException(super.message);
  
  @override
  String toString() => 'SecurityError: $message';
}

/// {@template beanException}
/// Thrown to indicate that a bean violation has occurred.
/// 
/// This exception is thrown when attempting to perform reflection
/// operations that are not allowed due to bean restrictions.
/// 
/// {@endtemplate}
class BeanException extends ReflectionException {
  /// {@macro beanException}
  BeanException(super.message);

  @override
  String toString() => "BeanException: $message";
}