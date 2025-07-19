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

import 'pattern_match_utils.dart';
import 'string_utils.dart';

/// PathMatcher implementation for Ant-style path patterns
class AntPathMatcher implements PathMatcher {
  static const String defaultPathSeparator = '/';
  
  final String _pathSeparator;
  final bool _caseSensitive;
  final bool _trimTokens;
  final Map<String, List<String>> _tokenizedPatternCache = {};
  final Map<String, AntPathStringMatcher> _stringMatcherCache = {};

  AntPathMatcher({
    String pathSeparator = defaultPathSeparator,
    bool caseSensitive = true,
    bool trimTokens = false,
  }) : _pathSeparator = pathSeparator,
       _caseSensitive = caseSensitive,
       _trimTokens = trimTokens;

  @override
  bool isPattern(String? path) {
    if (path == null) return false;
    
    bool uriVar = false;
    for (int i = 0; i < path.length; i++) {
      final c = path[i];
      if (c == '*' || c == '?') return true;
      if (c == '{') {
        uriVar = true;
        continue;
      }
      if (c == '}' && uriVar) return true;
    }
    return false;
  }

  @override
  bool match(String pattern, String path) {
    return _doMatch(pattern, path, true, null);
  }

  @override
  bool matchStart(String pattern, String path) {
    return _doMatch(pattern, path, false, null);
  }

  bool _doMatch(String pattern, String? path, bool fullMatch, Map<String, String>? uriTemplateVariables) {
    if (path == null || path.startsWith(_pathSeparator) != pattern.startsWith(_pathSeparator)) {
      return false;
    }

    final pattDirs = _tokenizePattern(pattern);
    final pathDirs = _tokenizePath(path);

    int pattIdxStart = 0;
    int pattIdxEnd = pattDirs.length - 1;
    int pathIdxStart = 0;
    int pathIdxEnd = pathDirs.length - 1;

    // Match all elements up to the first **
    while (pattIdxStart <= pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      final pattDir = pattDirs[pattIdxStart];
      if (pattDir == '**') break;
      
      if (!_matchStrings(pattDir, pathDirs[pathIdxStart], uriTemplateVariables)) {
        return false;
      }
      pattIdxStart++;
      pathIdxStart++;
    }

    if (pathIdxStart > pathIdxEnd) {
      // Path is exhausted, only match if rest of pattern is * or **'s
      if (pattIdxStart > pattIdxEnd) {
        return pattern.endsWith(_pathSeparator) == path.endsWith(_pathSeparator);
      }
      if (!fullMatch) return true;
      
      if (pattIdxStart == pattIdxEnd && pattDirs[pattIdxStart] == '*' && path.endsWith(_pathSeparator)) {
        return true;
      }
      
      for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
        if (pattDirs[i] != '**') return false;
      }
      return true;
    } else if (pattIdxStart > pattIdxEnd) {
      return false;
    } else if (!fullMatch && pattDirs[pattIdxStart] == '**') {
      return true;
    }

    // Match from the end
    while (pattIdxStart <= pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      final pattDir = pattDirs[pattIdxEnd];
      if (pattDir == '**') break;
      
      if (!_matchStrings(pattDir, pathDirs[pathIdxEnd], uriTemplateVariables)) {
        return false;
      }
      pattIdxEnd--;
      pathIdxEnd--;
    }

    if (pathIdxStart > pathIdxEnd) {
      for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
        if (pattDirs[i] != '**') return false;
      }
      return true;
    }

    // Match the middle part
    while (pattIdxStart != pattIdxEnd && pathIdxStart <= pathIdxEnd) {
      int patIdxTmp = -1;
      for (int i = pattIdxStart + 1; i <= pattIdxEnd; i++) {
        if (pattDirs[i] == '**') {
          patIdxTmp = i;
          break;
        }
      }
      
      if (patIdxTmp == pattIdxStart + 1) {
        pattIdxStart++;
        continue;
      }

      final patLength = patIdxTmp - pattIdxStart - 1;
      final strLength = pathIdxEnd - pathIdxStart + 1;
      int foundIdx = -1;

      strLoop: for (int i = 0; i <= strLength - patLength; i++) {
        for (int j = 0; j < patLength; j++) {
          final subPat = pattDirs[pattIdxStart + j + 1];
          final subStr = pathDirs[pathIdxStart + i + j];
          if (!_matchStrings(subPat, subStr, uriTemplateVariables)) {
            continue strLoop;
          }
        }
        foundIdx = pathIdxStart + i;
        break;
      }

      if (foundIdx == -1) return false;
      
      pattIdxStart = patIdxTmp;
      pathIdxStart = foundIdx + patLength;
    }

    for (int i = pattIdxStart; i <= pattIdxEnd; i++) {
      if (pattDirs[i] != '**') return false;
    }

    return true;
  }

  List<String> _tokenizePattern(String pattern) {
    var tokenized = _tokenizedPatternCache[pattern];
    if (tokenized == null) {
      tokenized = _tokenizePath(pattern);
      _tokenizedPatternCache[pattern] = tokenized;
    }
    return tokenized;
  }

  List<String> _tokenizePath(String path) {
    return StringUtils.tokenizeToStringArray(path, _pathSeparator, _trimTokens, true);
  }

  bool _matchStrings(String pattern, String str, Map<String, String>? uriTemplateVariables) {
    return _getStringMatcher(pattern).matchStrings(str, uriTemplateVariables);
  }

  AntPathStringMatcher _getStringMatcher(String pattern) {
    var matcher = _stringMatcherCache[pattern];
    if (matcher == null) {
      matcher = AntPathStringMatcher(pattern, _pathSeparator, _caseSensitive);
      _stringMatcherCache[pattern] = matcher;
    }
    return matcher;
  }

  @override
  String extractPathWithinPattern(String pattern, String path) {
    final patternParts = StringUtils.tokenizeToStringArray(pattern, _pathSeparator, _trimTokens, true);
    final pathParts = StringUtils.tokenizeToStringArray(path, _pathSeparator, _trimTokens, true);
    
    final buffer = StringBuffer();
    bool pathStarted = false;
    
    for (int segment = 0; segment < patternParts.length; segment++) {
      final patternPart = patternParts[segment];
      if (patternPart.contains('*') || patternPart.contains('?')) {
        for (; segment < pathParts.length; segment++) {
          if (pathStarted || (segment == 0 && !pattern.startsWith(_pathSeparator))) {
            buffer.write(_pathSeparator);
          }
          buffer.write(pathParts[segment]);
          pathStarted = true;
        }
      }
    }
    
    return buffer.toString();
  }

  @override
  Map<String, String> extractUriTemplateVariables(String pattern, String path) {
    final variables = <String, String>{};
    final result = _doMatch(pattern, path, true, variables);
    if (!result) {
      throw StateError('Pattern "$pattern" is not a match for "$path"');
    }
    return variables;
  }

  @override
  String combine(String pattern1, String pattern2) {
    if (!StringUtils.hasText(pattern1) && !StringUtils.hasText(pattern2)) {
      return '';
    }
    if (!StringUtils.hasText(pattern1)) return pattern2;
    if (!StringUtils.hasText(pattern2)) return pattern1;

    final pattern1ContainsUriVar = pattern1.contains('{');
    if (pattern1 != pattern2 && !pattern1ContainsUriVar && match(pattern1, pattern2)) {
      return pattern2;
    }

    if (pattern1.endsWith('$_pathSeparator*')) {
      return _concat(pattern1.substring(0, pattern1.length - 2), pattern2);
    }

    if (pattern1.endsWith('$_pathSeparator**')) {
      return _concat(pattern1, pattern2);
    }

    final starDotPos1 = pattern1.indexOf('*.');
    if (pattern1ContainsUriVar || starDotPos1 == -1 || _pathSeparator == '.') {
      return _concat(pattern1, pattern2);
    }

    final ext1 = pattern1.substring(starDotPos1 + 1);
    final dotPos2 = pattern2.indexOf('.');
    final file2 = dotPos2 == -1 ? pattern2 : pattern2.substring(0, dotPos2);
    final ext2 = dotPos2 == -1 ? '' : pattern2.substring(dotPos2);
    final ext1All = ext1 == '.*' || ext1.isEmpty;
    final ext2All = ext2 == '.*' || ext2.isEmpty;
    
    if (!ext1All && !ext2All) {
      throw ArgumentError('Cannot combine patterns: $pattern1 vs $pattern2');
    }
    
    final ext = ext1All ? ext2 : ext1;
    return file2 + ext;
  }

  String _concat(String path1, String path2) {
    final path1EndsWithSeparator = path1.endsWith(_pathSeparator);
    final path2StartsWithSeparator = path2.startsWith(_pathSeparator);
    
    if (path1EndsWithSeparator && path2StartsWithSeparator) {
      return path1 + path2.substring(1);
    } else if (path1EndsWithSeparator || path2StartsWithSeparator) {
      return path1 + path2;
    } else {
      return path1 + _pathSeparator + path2;
    }
  }
}

/// Interface for path matching strategies
abstract class PathMatcher {
  bool isPattern(String? path);
  bool match(String pattern, String path);
  bool matchStart(String pattern, String path);
  String extractPathWithinPattern(String pattern, String path);
  Map<String, String> extractUriTemplateVariables(String pattern, String path);
  String combine(String pattern1, String pattern2);
}

/// String matcher for Ant path patterns
class AntPathStringMatcher {
  static const String _defaultVariablePattern = r'(.*)';
  
  final String _rawPattern;
  final bool _caseSensitive;
  final bool _exactMatch;
  final RegExp? _pattern;
  final List<String> _variableNames = [];

  AntPathStringMatcher(String pattern, String pathSeparator, bool caseSensitive)
      : _rawPattern = pattern,
        _caseSensitive = caseSensitive,
        _exactMatch = !_containsPatternChars(pattern),
        _pattern = !_containsPatternChars(pattern) ? null : _buildPattern(pattern, pathSeparator, caseSensitive);

  static bool _containsPatternChars(String str) {
    return str.contains('*') || str.contains('?') || str.contains('{');
  }

  static RegExp _buildPattern(String pattern, String pathSeparator, bool caseSensitive) {
    final patternBuilder = StringBuffer();
    final matcher = RegExp(r'\?|\*|\{([^}]+)\}');
    int end = 0;
    
    for (final match in matcher.allMatches(pattern)) {
      patternBuilder.write(RegExp.escape(pattern.substring(end, match.start)));
      final matchStr = match.group(0)!;
      
      if (matchStr == '?') {
        patternBuilder.write('.');
      } else if (matchStr == '*') {
        patternBuilder.write('.*');
      } else if (matchStr.startsWith('{') && matchStr.endsWith('}')) {
        final colonIdx = matchStr.indexOf(':');
        if (colonIdx == -1) {
          patternBuilder.write(_defaultVariablePattern);
          // variableNames.add(match.group(1)!);
        } else {
          final variablePattern = matchStr.substring(colonIdx + 1, matchStr.length - 1);
          patternBuilder.write('($variablePattern)');
          // final variableName = matchStr.substring(1, colonIdx);
          // variableNames.add(variableName);
        }
      }
      end = match.end;
    }
    
    patternBuilder.write(RegExp.escape(pattern.substring(end)));
    
    return RegExp(
      patternBuilder.toString(),
      caseSensitive: caseSensitive,
      dotAll: true,
    );
  }

  bool matchStrings(String str, Map<String, String>? uriTemplateVariables) {
    if (_exactMatch) {
      return _caseSensitive ? _rawPattern == str : _rawPattern.toLowerCase() == str.toLowerCase();
    } else if (_pattern != null) {
      final match = _pattern!.firstMatch(str);
      if (match != null) {
        if (uriTemplateVariables != null) {
          for (int i = 1; i <= match.groupCount; i++) {
            if (i - 1 < _variableNames.length) {
              final name = _variableNames[i - 1];
              final value = match.group(i);
              if (value != null) {
                uriTemplateVariables[name] = value;
              }
            }
          }
        }
        return true;
      }
    }
    return false;
  }
}