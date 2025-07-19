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

import 'package:meta/meta.dart';

/// A powerful template engine for the JetLeaf framework.
/// 
/// Supports variable interpolation, conditional rendering, loops,
/// and includes for modular template design.
/// 
/// Syntax:
/// - Variables: `{{variableName}}`
/// - Conditionals: `{{#if condition}}...{{/if}}`
/// - Loops: `{{#each items}}...{{/each}}`
/// - Includes: `{{>templateName}}`
/// 
/// Example:
/// ```dart
/// final engine = TemplateEngine('resources/html');
/// final result = await engine.render('user-profile', {
///   'user': {'name': 'John', 'email': 'john@example.com'},
///   'isAdmin': true
/// });
/// ```
abstract class TemplateEngine {
  /// The base directory where HTML templates are stored.
  final String baseDirectory;

  /// The fallback directory where HTML templates are stored.
  final String fallbackDirectory;
  
  /// Whether to enable template caching (default: true).
  final bool enableCaching;
  
  /// Creates a new template engine instance.
  /// 
  /// [baseDirectory] - The root directory containing HTML templates
  /// [fallbackDirectory] - The fallback directory containing HTML templates
  /// [enableCaching] - Whether to cache compiled templates
  TemplateEngine({String? baseDirectory, String? fallbackDirectory, this.enableCaching = true}) 
    : baseDirectory = baseDirectory ?? "resources/html",
      fallbackDirectory = fallbackDirectory ?? "resources/html";

  /// Renders a template with the provided data context.
  /// 
  /// [templateName] - Name of the template file (without .html extension)
  /// [context] - Map containing variables to inject into the template
  /// 
  /// Returns the rendered HTML string.
  /// 
  /// Throws [TemplateNotFoundException] if the template file doesn't exist.
  /// Throws [TemplateRenderException] if there's an error during rendering.
  @mustBeOverridden
  Future<String> render(String templateName, [Map<String, dynamic> context = const {}]);

  /// Gets the cached templates.
  /// 
  /// Returns a map of template names to their cached content.
  /// 
  /// Can return an empty map if caching is disabled.
  Map<String, String> getCachedTemplates() => {};
  
  /// Clears the template cache.
  /// 
  /// Useful for development when templates are frequently changed.
  void clearCachedTemplates() {}
}