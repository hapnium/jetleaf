/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

/// Helper class for resolving placeholders in text
class PropertyPlaceholderHelper {
  final String _placeholderPrefix;
  final String _placeholderSuffix;
  final String? _valueSeparator;
  final String? _escapeCharacter;
  final bool _ignoreUnresolvablePlaceholders;

  PropertyPlaceholderHelper(
    this._placeholderPrefix,
    this._placeholderSuffix, {
    String? valueSeparator,
    String? escapeCharacter,
    bool ignoreUnresolvablePlaceholders = true,
  }) : _valueSeparator = valueSeparator,
       _escapeCharacter = escapeCharacter,
       _ignoreUnresolvablePlaceholders = ignoreUnresolvablePlaceholders;

  /// Replace placeholders with values from properties map
  String replacePlaceholders(String value, Map<String, String> properties) {
    return _parseStringValue(value, (placeholderName) => properties[placeholderName]);
  }

  /// Replace placeholders using resolver function
  String replacePlaceholdersWithResolver(String value, PlaceholderResolver resolver) {
    return _parseStringValue(value, resolver);
  }

  String _parseStringValue(String value, PlaceholderResolver placeholderResolver) {
    if (value.isEmpty) return value;

    final buffer = StringBuffer();
    int startIndex = value.indexOf(_placeholderPrefix);
    
    while (startIndex != -1) {
      buffer.write(value.substring(0, startIndex));
      
      final endIndex = _findPlaceholderEndIndex(value, startIndex);
      if (endIndex != -1) {
        final placeholder = value.substring(
          startIndex + _placeholderPrefix.length, 
          endIndex
        );
        
        final originalPlaceholder = placeholder;
        String? propVal;
        String? defaultValue;
        
        if (_valueSeparator != null) {
          final separatorIndex = placeholder.indexOf(_valueSeparator!);
          if (separatorIndex != -1) {
            final actualPlaceholder = placeholder.substring(0, separatorIndex);
            defaultValue = placeholder.substring(separatorIndex + _valueSeparator!.length);
            propVal = placeholderResolver(actualPlaceholder);
          } else {
            propVal = placeholderResolver(placeholder);
          }
        } else {
          propVal = placeholderResolver(placeholder);
        }
        
        if (propVal != null) {
          // Recursive resolution
          propVal = _parseStringValue(propVal, placeholderResolver);
          buffer.write(propVal);
        } else if (defaultValue != null) {
          // Recursive resolution of default value
          defaultValue = _parseStringValue(defaultValue, placeholderResolver);
          buffer.write(defaultValue);
        } else if (_ignoreUnresolvablePlaceholders) {
          buffer.write(_placeholderPrefix);
          buffer.write(originalPlaceholder);
          buffer.write(_placeholderSuffix);
        } else {
          throw PlaceholderResolutionException(
            "Could not resolve placeholder '$originalPlaceholder'",
            originalPlaceholder,
          );
        }
        
        value = value.substring(endIndex + _placeholderSuffix.length);
      } else {
        buffer.write(_placeholderPrefix);
        value = value.substring(startIndex + _placeholderPrefix.length);
      }
      
      startIndex = value.indexOf(_placeholderPrefix);
    }
    
    buffer.write(value);
    return buffer.toString();
  }

  int _findPlaceholderEndIndex(String value, int startIndex) {
    int index = startIndex + _placeholderPrefix.length;
    int withinNestedPlaceholder = 0;
    
    while (index < value.length) {
      if (_substringMatch(value, index, _placeholderSuffix)) {
        if (withinNestedPlaceholder > 0) {
          withinNestedPlaceholder--;
          index += _placeholderSuffix.length;
        } else {
          return index;
        }
      } else if (_substringMatch(value, index, _placeholderPrefix)) {
        withinNestedPlaceholder++;
        index += _placeholderPrefix.length;
      } else {
        index++;
      }
    }
    
    return -1;
  }

  bool _substringMatch(String str, int index, String substring) {
    if (index + substring.length > str.length) return false;
    for (int i = 0; i < substring.length; i++) {
      if (str[index + i] != substring[i]) return false;
    }
    return true;
  }
}

/// Function type for resolving placeholder values
typedef PlaceholderResolver = String? Function(String placeholderName);

/// Exception thrown when placeholder resolution fails
class PlaceholderResolutionException implements Exception {
  final String message;
  final String placeholder;
  final List<String> values;

  PlaceholderResolutionException(
    this.message,
    this.placeholder, [
    String? value,
  ]) : values = value != null ? [value] : [];

  @override
  String toString() => 'PlaceholderResolutionException: $message';
}