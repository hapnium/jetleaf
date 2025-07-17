import 'environment_parser_factory.dart';

/// {@template properties_parser}
/// A parser for `.properties` configuration files.
///
/// This parser supports simple key-value pairs with optional comments and unescaping of
/// basic escape sequences like `\\n`, `\\t`, etc.
///
/// Supported features:
/// - Comments starting with `#` or `!`
/// - Key-value pairs separated by `=` or `:`
/// - Simple escape sequences in values
///
/// Example:
/// ```properties
/// # Comment line
/// host=localhost
/// port=8080
/// greeting=Hello\\nWorld
/// ```
///
/// Usage:
/// ```dart
/// final parser = PropertiesParser();
/// final map = parser.parseSingle('key=value');
/// print(map['key']); // 'value'
/// ```
///
/// Throws [EnvironmentParsingException] if parsing fails.
/// {@endtemplate}
class PropertiesParser extends EnvironmentParserFactory {
  /// {@macro properties_parser}
  PropertiesParser();

  @override
  Map<String, Object> parseSingle(String content) {
    final result = <String, Object>{};
    final lines = content.split('\n');

    for (var line in lines) {
      line = line.trim();
      
      // Skip empty lines and comments
      if (line.isEmpty || line.startsWith('#') || line.startsWith('!')) {
        continue;
      }

      // Find the separator (= or :)
      int separatorIndex = -1;
      for (int i = 0; i < line.length; i++) {
        if (line[i] == '=' || line[i] == ':') {
          separatorIndex = i;
          break;
        }
      }

      if (separatorIndex == -1) continue;

      final key = line.substring(0, separatorIndex).trim();
      final value = line.substring(separatorIndex + 1).trim();

      if (key.isNotEmpty) {
        result[key] = _unescapeValue(value);
      }
    }

    return result;
  }

  /// Unescapes common sequences such as `\n`, `\r`, `\t`, and `\\`.
  ///
  /// This is useful for decoding `.properties` values that include escaped characters.
  ///
  /// Example:
  /// ```dart
  /// PropertiesParser._unescapeValue('Line\\nBreak') // => 'Line\nBreak'
  /// ```
  static String _unescapeValue(String value) {
    return value
        .replaceAll('\\n', '\n')
        .replaceAll('\\r', '\r')
        .replaceAll('\\t', '\t')
        .replaceAll('\\\\', '\\');
  }
}