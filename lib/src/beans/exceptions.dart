/// {@template beans_exception}
/// Base exception type for all bean-related errors in JetLeaf.
///
/// This exception is typically thrown when a bean cannot be created,
/// resolved, injected, or initialized properly within the application context.
///
/// It acts as the root of the JetLeaf bean exception hierarchy and may be
/// subclassed to represent more specific errors (e.g., `NoSuchBeanDefinitionException`,
/// `BeanCreationException`, etc.).
///
/// ---
///
/// ### Example
/// ```dart
/// throw BeansException('Failed to create bean of type MyService');
/// ```
///
/// {@endtemplate}
class BeansException implements Exception {
  /// The error message describing the bean-related issue.
  final String message;

  /// {@macro beans_exception}
  const BeansException(this.message);

  @override
  String toString() => message;
}

/// {@template no_such_bean_definition_exception}
/// Exception thrown when a bean definition cannot be found in the application context.
///
/// This exception typically occurs when trying to retrieve a bean by its name or type
/// from the application context, but no matching bean definition is found.
///
/// ---
///
/// ### Example
/// ```dart
/// throw NoSuchBeanDefinitionException('No bean named "myBean" is defined');
/// ```
/// {@endtemplate}
class NoSuchBeanDefinitionException implements Exception {
  final String message;

  const NoSuchBeanDefinitionException(this.message);

  @override
  String toString() => message;
}

/// {@template no_unique_bean_definition_exception}
/// Exception thrown when multiple bean definitions are found for a given type in the application context.
///
/// This exception typically occurs when trying to retrieve a bean by its type from the application context,
/// but multiple matching bean definitions are found, making it ambiguous which bean to use.
///
/// ---
///
/// ### Example
/// ```dart
/// throw NoUniqueBeanDefinitionException('Multiple bean definitions found for type MyService');
/// ```
/// {@endtemplate}
class NoUniqueBeanDefinitionException implements Exception {
  final String message;

  const NoUniqueBeanDefinitionException(this.message);

  @override
  String toString() => message;
}

/// {@template unsupported_operation_exception}
/// Exception thrown when an operation is not supported.
///
/// This exception typically occurs when trying to perform an operation that is not
/// supported by the current implementation or context.
///
/// ---
///
/// ### Example
/// ```dart
/// throw UnsupportedOperationException('Operation not supported');
/// ```
/// {@endtemplate}
class UnsupportedOperationException implements Exception {
  final String message;

  const UnsupportedOperationException(this.message);

  @override
  String toString() => message;
}
