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

import 'dart:io';
import 'property_placeholder_helper.dart';

/// Helper class for resolving placeholders in texts using system properties
class SystemPropertyUtils {
  static const String placeholderPrefix = r'#{';
  static const String placeholderSuffix = '}';
  static const String valueSeparator = ':';
  static const String escapeCharacter = r'\';

  static final PropertyPlaceholderHelper _strictHelper = PropertyPlaceholderHelper(
    placeholderPrefix,
    placeholderSuffix,
    valueSeparator: valueSeparator,
    escapeCharacter: escapeCharacter,
    ignoreUnresolvablePlaceholders: false,
  );

  static final PropertyPlaceholderHelper _nonStrictHelper = PropertyPlaceholderHelper(
    placeholderPrefix,
    placeholderSuffix,
    valueSeparator: valueSeparator,
    escapeCharacter: escapeCharacter,
    ignoreUnresolvablePlaceholders: true,
  );

  /// Resolve placeholders in text using system properties
  static String resolvePlaceholders(String text, [bool ignoreUnresolvablePlaceholders = false]) {
    if (text.isEmpty) return text;
    
    final helper = ignoreUnresolvablePlaceholders ? _nonStrictHelper : _strictHelper;
    return helper.replacePlaceholdersWithResolver(text, _SystemPropertyPlaceholderResolver(text).resolve);
  }
}

class _SystemPropertyPlaceholderResolver {
  final String text;

  _SystemPropertyPlaceholderResolver(this.text);

  String? resolve(String placeholderName) {
    try {
      // Try environment variable first
      String? propVal = Platform.environment[placeholderName];
      return propVal;
    } catch (ex) {
      print('Could not resolve placeholder \'$placeholderName\' in [$text]: $ex');
      return null;
    }
  }
}