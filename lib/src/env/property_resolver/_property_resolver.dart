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

import 'abstract_property_resolver.dart';

/// {@template resource_interpolator}
/// Handles comprehensive variable interpolation for configuration files
/// 
/// This class provides a way to interpolate environment variables and property references 
/// in text using multiple syntax patterns for maximum flexibility.
/// 
/// ## Supported Patterns
/// 
/// ### Environment Variables:
/// - `${VAR_NAME}` - Standard shell-style environment variable
/// - `#{VAR_NAME}` - Alternative environment variable syntax
/// - `$VAR_NAME` - Short environment variable syntax
/// - `#VAR_NAME` - Alternative short environment variable syntax
/// 
/// ### Property References:
/// - `@property.name@` - Property reference with @ delimiters
/// - `${property.name}` - Property reference using ${} syntax
/// - `#{property.name}` - Property reference using #{} syntax
/// 
/// ## Example Usage
/// ```dart
/// // Environment: BASE_URL=https://api.example.com, API=v1
/// // Properties: server.timeout=30, app.name=MyApp
/// 
/// final interpolator = RuntimePropertyResolver(resources);
/// 
/// // Various interpolation patterns:
/// interpolator.interpolate('${BASE_URL}/${API}')           // → https://api.example.com/v1
/// interpolator.interpolate('#{BASE_URL}/#{API}')           // → https://api.example.com/v1
/// interpolator.interpolate('$BASE_URL/$API')               // → https://api.example.com/v1
/// interpolator.interpolate('#BASE_URL/#API')               // → https://api.example.com/v1
/// interpolator.interpolate('$BASE_URL/check')              // → https://api.example.com/check
/// interpolator.interpolate('@app.name@ timeout: @server.timeout@s') // → MyApp timeout: 30s
/// ```
/// 
/// {@endtemplate}
class RuntimePropertyResolver {
  // Environment variable patterns
  final RegExp _varBraced = RegExp(r'\$\{([A-Za-z_][A-Za-z0-9_]*)\}');           // ${VAR_NAME}
  final RegExp _varHashBraced = RegExp(r'#\{([A-Za-z_][A-Za-z0-9_]*)\}');        // #{VAR_NAME}
  final RegExp _varShort = RegExp(r'\$([A-Za-z_][A-Za-z0-9_]*)(?![A-Za-z0-9_])'); // $VAR_NAME
  final RegExp _varHashShort = RegExp(r'#([A-Za-z_][A-Za-z0-9_]*)(?![A-Za-z0-9_])'); // #VAR_NAME
  
  // Property reference patterns
  final RegExp _propertyAtRef = RegExp(r'@([^@]+)@');                                // @property.name@
  final RegExp _propertyBraced = RegExp(r'\$\{([^}]+\.[^}]+)\}');                   // ${property.name}
  final RegExp _propertyHashBraced = RegExp(r'#\{([^}]+\.[^}]+)\}');                // #{property.name}

  final AbstractPropertyResolver resolver;

  /// {@macro resource_interpolator}
  RuntimePropertyResolver(this.resolver);

  /// Interpolates all supported variable patterns in text
  /// 
  /// Processes variables in the following order:
  /// 1. Property references (@property.name@, ${property.name}, #{property.name})
  /// 2. Environment variables (${VAR}, #{VAR}, $VAR, #VAR)
  /// 
  /// Supports nested interpolation up to 10 levels deep to handle cases where
  /// one variable contains references to other variables.
  /// 
  /// ## Parameters
  /// - `text`: The text containing variable references to interpolate
  /// 
  /// ## Returns
  /// The text with all supported variable patterns replaced with their values
  String interpolate(String text) {
    if (text.isEmpty) return text;
    
    var result = text;
    int depth = 0;
    const maxDepth = 10;

    // Continue interpolating until no more changes occur or max depth reached
    while (depth < maxDepth) {
      final previousResult = result;
      
      // Resolve property references first (they might contain env vars)
      result = _interpolateReferences(result);
      
      // If no changes occurred, we're done
      if (result == previousResult) {
        break;
      }
      
      depth++;
    }

    if (depth >= maxDepth) {
      // Log warning about potential circular references
    }

    return result;
  }

  /// Interpolates property references using all supported patterns
  String _interpolateReferences(String text) {
    var result = text;
    
    // @property.name@ pattern
    result = result.replaceAllMapped(_propertyAtRef, (match) {
      final propertyPath = match.group(1)!;
      final value = _getValue(propertyPath);
      return value?.toString() ?? match.group(0)!;
    });
    
    // ${property.name} pattern (only if it contains a dot)
    result = result.replaceAllMapped(_propertyBraced, (match) {
      final propertyPath = match.group(1)!;
      final value = _getValue(propertyPath);
      return value?.toString() ?? match.group(0)!;
    });
    
    // #{property.name} pattern (only if it contains a dot)
    result = result.replaceAllMapped(_propertyHashBraced, (match) {
      final propertyPath = match.group(1)!;
      final value = _getValue(propertyPath);
      return value?.toString() ?? match.group(0)!;
    });

    // $VAR_NAME pattern (short form)
    result = result.replaceAllMapped(_varShort, (match) {
      final varName = match.group(1)!;
      final value = _getValue(varName);
      return value ?? match.group(0)!;
    });
    
    // #VAR_NAME pattern (short form)
    result = result.replaceAllMapped(_varHashShort, (match) {
      final varName = match.group(1)!;
      final value = _getValue(varName);
      return value ?? match.group(0)!;
    });

    // ${VAR_NAME} pattern
    result = result.replaceAllMapped(_varBraced, (match) {
      final varName = match.group(1)!;
      final value = _getValue(varName);
      return value ?? match.group(0)!;
    });
    
    // #{VAR_NAME} pattern
    result = result.replaceAllMapped(_varHashBraced, (match) {
      final varName = match.group(1)!;
      final value = _getValue(varName);
      return value ?? match.group(0)!;
    });
    
    return result;
  }

  /// Gets a property value using dot notation (e.g., "server.port")
  dynamic _getValue(String path) {
    if (path.isEmpty) return null;
    
    try {
      return resolver.getProperty(path) ?? resolver.getRequiredProperty(path);
    } catch (e) {
      return null;
    }
  }

  /// Interpolates all string values in a map recursively
  /// 
  /// This method processes nested maps and lists, interpolating any string values
  /// it encounters while preserving the original structure.
  /// 
  /// ## Parameters
  /// - `map`: The map to interpolate
  /// 
  /// ## Returns
  /// A new map with all string values interpolated
  Map<String, dynamic> interpolateMap(Map<String, dynamic> map) {
    final result = <String, dynamic>{};

    for (final entry in map.entries) {
      if (entry.value is String) {
        result[entry.key] = interpolate(entry.value as String);
      } else if (entry.value is Map<String, dynamic>) {
        result[entry.key] = interpolateMap(entry.value as Map<String, dynamic>);
      } else if (entry.value is List) {
        result[entry.key] = _interpolateList(entry.value as List);
      } else {
        result[entry.key] = entry.value;
      }
    }

    return result;
  }

  /// Interpolates all string values in a list recursively
  /// 
  /// ## Parameters
  /// - `list`: The list to interpolate
  /// 
  /// ## Returns
  /// A new list with all string values interpolated
  List<dynamic> _interpolateList(List<dynamic> list) {
    return list.map((item) {
      if (item is String) {
        return interpolate(item);
      } else if (item is Map<String, dynamic>) {
        return interpolateMap(item);
      } else if (item is List) {
        return _interpolateList(item);
      } else {
        return item;
      }
    }).toList();
  }

  /// Validates that a string contains valid variable references
  /// 
  /// This method can be used to check if a configuration value contains
  /// properly formatted variable references before attempting interpolation.
  /// 
  /// ## Parameters
  /// - `text`: The text to validate
  /// 
  /// ## Returns
  /// A list of validation errors, empty if the text is valid
  List<String> validateInterpolation(String text) {
    final errors = <String>[];
    
    // Check for unmatched braces
    final openBraces = text.split('{').length - 1;
    final closeBraces = text.split('}').length - 1;
    if (openBraces != closeBraces) {
      errors.add('Unmatched braces in interpolation string');
    }
    
    // Check for unmatched @ symbols
    final atSymbols = text.split('@').length - 1;
    if (atSymbols % 2 != 0) {
      errors.add('Unmatched @ symbols in property reference');
    }
    
    // Check for empty variable names
    if (text.contains('\${}') || text.contains('#{}') || text.contains('@@')) {
      errors.add('Empty variable name in interpolation string');
    }
    
    return errors;
  }

  /// Gets all variable references found in a string
  /// 
  /// This method extracts all variable references from a string without
  /// performing interpolation, useful for dependency analysis.
  /// 
  /// ## Parameters
  /// - `text`: The text to analyze
  /// 
  /// ## Returns
  /// A set of all variable names referenced in the text
  Set<String> getVariableReferences(String text) {
    final references = <String>{};
    
    // Environment variables
    references.addAll(_varBraced.allMatches(text).map((m) => m.group(1)!));
    references.addAll(_varHashBraced.allMatches(text).map((m) => m.group(1)!));
    references.addAll(_varShort.allMatches(text).map((m) => m.group(1)!));
    references.addAll(_varHashShort.allMatches(text).map((m) => m.group(1)!));
    
    // Property references
    references.addAll(_propertyAtRef.allMatches(text).map((m) => m.group(1)!));
    references.addAll(_propertyBraced.allMatches(text).map((m) => m.group(1)!));
    references.addAll(_propertyHashBraced.allMatches(text).map((m) => m.group(1)!));
    
    return references;
  }
}