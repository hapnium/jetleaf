import 'method_info.dart';

/// {@template handler_method}
/// Represents a reference to a handler method and its associated bean (instance).
///
/// Used internally by the JetLeaf framework to invoke annotated methods
/// (such as those marked with `@MessageMapping`, `@Before`, `@After`, etc.)
/// via reflection.
///
/// The [bean] is the instance on which the method will be invoked,
/// and [method] is metadata about the method itself, retrieved via JetLeaf's reflection system.
///
/// ### Example:
/// ```dart
/// final handler = HandlerMethod(
///   bean: MyController(),
///   method: ClassInfo.of(MyController).getDeclaredMethod('handle')!,
///   pathVariables: {'id': '123'},
/// );
///
/// final result = handler.method.invoke(handler.bean, []);
/// ```
///
/// This class is useful for deferred method invocation, dynamic dispatch, or
/// storing references to controller/advice methods during registration.
/// {@endtemplate}
class HandlerMethod {
  /// The instance (bean) that owns the method.
  final Object bean;

  /// The reflective metadata about the method to be called.
  final ClassMethodInfo method;

  /// Path variables extracted from the request URI.
  final Map<String, String> pathVariables;

  /// {@macro handler_method}
  HandlerMethod({required this.bean, required this.method, this.pathVariables = const {}});

  /// Creates a new HandlerMethod with updated path variables.
  HandlerMethod withPathVariables(Map<String, String> newPathVars) {
    return HandlerMethod(
      bean: bean,
      method: method,
      pathVariables: newPathVars,
    );
  }
}