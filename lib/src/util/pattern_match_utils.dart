/// {@template pattern_match_utils}
/// Utility class for simple string pattern matching with wildcard support (`*`).
///
/// The `PatternMatchUtils` class provides static methods to match strings against
/// simple wildcard-based patterns. It supports case-sensitive and case-insensitive
/// matching, as well as bulk matching against multiple patterns.
///
/// A pattern may contain `*` which matches zero or more characters.
///
/// ## Examples:
/// ```dart
/// PatternMatchUtils.simpleMatch('com.*.service', 'com.myapp.service'); // true
/// PatternMatchUtils.simpleMatchIgnoreCase('HELLO*', 'helloWorld'); // true
/// PatternMatchUtils.simpleMatchMultiple(['a*', 'b*'], 'apple'); // true
/// ```
///
/// Useful for path matching, permission checks, or any lightweight pattern filtering.
/// {@endtemplate}
class PatternMatchUtils {
  /// {@template pattern_match_utils.simpleMatch}
  /// Matches the given [str] against the [pattern], optionally ignoring case.
  ///
  /// The pattern can contain `*` as a wildcard matching any number of characters.
  ///
  /// - Returns `true` if the string matches the pattern.
  /// - Returns `false` if either input is null or the pattern does not match.
  ///
  /// ## Example:
  /// ```dart
  /// PatternMatchUtils.simpleMatch('user/*/profile', 'user/john/profile'); // true
  /// PatternMatchUtils.simpleMatch('data-*', 'data-2025', true); // true (case-insensitive)
  /// ```
  /// {@endtemplate}
  static bool simpleMatch(String? pattern, String? str, [bool ignoreCase = false]) {
    if (pattern == null || str == null) return false;
    
    final p = ignoreCase ? pattern.toLowerCase() : pattern;
    final s = ignoreCase ? str.toLowerCase() : str;
    
    return _doMatch(p, s);
  }

  /// {@template pattern_match_utils.simpleMatchIgnoreCase}
  /// Matches the given [str] against the [pattern] in a case-insensitive way.
  ///
  /// This is equivalent to calling `simpleMatch(pattern, str, true)`.
  ///
  /// ## Example:
  /// ```dart
  /// PatternMatchUtils.simpleMatchIgnoreCase('Hello*', 'helloWorld'); // true
  /// ```
  /// {@endtemplate}
  static bool simpleMatchIgnoreCase(String? pattern, String? str) {
    return simpleMatch(pattern, str, true);
  }

  /// {@template pattern_match_utils.simpleMatchMultiple}
  /// Matches the given [str] against a list of [patterns].
  ///
  /// Returns `true` if any of the patterns match the string.
  ///
  /// ## Example:
  /// ```dart
  /// PatternMatchUtils.simpleMatchMultiple(['admin/*', 'user/*'], 'user/42'); // true
  /// ```
  /// {@endtemplate}
  static bool simpleMatchMultiple(List<String>? patterns, String? str) {
    if (patterns == null) return false;
    return patterns.any((pattern) => simpleMatch(pattern, str));
  }

  // Internal wildcard match logic. Does not require documentation.
  static bool _doMatch(String pattern, String str) {
    final firstIndex = pattern.indexOf('*');
    if (firstIndex == -1) {
      return pattern == str;
    }

    if (firstIndex == 0) {
      if (pattern.length == 1) return true;

      final nextIndex = pattern.indexOf('*', 1);
      if (nextIndex == -1) {
        final part = pattern.substring(1);
        return str.endsWith(part);
      }

      final part = pattern.substring(1, nextIndex);
      if (part.isEmpty) {
        return _doMatch(pattern.substring(nextIndex), str);
      }

      int partIndex = str.indexOf(part);
      while (partIndex != -1) {
        if (_doMatch(pattern.substring(nextIndex), str.substring(partIndex + part.length))) {
          return true;
        }
        partIndex = str.indexOf(part, partIndex + 1);
      }
      return false;
    }

    return str.length >= firstIndex &&
           str.startsWith(pattern.substring(0, firstIndex)) &&
           _doMatch(pattern.substring(firstIndex), str.substring(firstIndex));
  }
}