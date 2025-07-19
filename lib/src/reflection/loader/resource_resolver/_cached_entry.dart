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

part of '_resource_resolver.dart';

/// Cached content entry
class _CachedContent {
  final dynamic content;
  final DateTime timestamp;
  
  _CachedContent(this.content, this.timestamp);
  
  bool get isExpired => DateTime.now().difference(timestamp) > const Duration(minutes: 10);
}