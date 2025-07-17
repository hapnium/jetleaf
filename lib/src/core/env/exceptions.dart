/// {@template dart_loading_exception}
/// Exception thrown when Dart file loading fails
/// 
/// This exception is thrown when an error occurs during the loading
/// of a Dart file, such as a syntax error or a missing required
/// import.
/// 
/// {@endtemplate}
class DartLoadingException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// {@macro dart_loading_exception}
  DartLoadingException(this.message);
}