/// {@template path_matching_exception}
/// Exception thrown when a URI or route path fails to match a defined template
/// in a path matcher.
///
/// Common scenarios include:
/// - Invalid placeholders
/// - Missing required path segments
/// - Mismatched patterns or formats
///
/// Useful for debugging route resolution and pattern-based matching systems.
/// {@endtemplate}
class PathMatchingException implements Exception {
  /// The error message describing what went wrong.
  final String message;

  /// {@macro path_matching_exception}
  PathMatchingException(this.message);

  @override
  String toString() => 'PathMatchingException: $message';
}