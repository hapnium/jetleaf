import 'dart:io';

import 'package:jetleaf/asset_loader.dart';

import 'exceptions.dart';
import 'template_engine.dart';

/// {@template template_engine}
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
/// {@endtemplate}
final class JtlTemplateEngine extends TemplateEngine {
  /// Cache for compiled templates to improve performance.
  final Map<String, String> templateCache = {};

  /// {@macro template_engine}
  JtlTemplateEngine({super.baseDirectory, super.enableCaching = true, super.fallbackDirectory});
  
  @override
  Future<String> render(String templateName, [Map<String, dynamic> context = const {}]) async {
    try {
      final templateContent = await _loadTemplate(templateName);
      
      if(context.isNotEmpty) {
        return _renderTemplate(templateContent, context);
      }

      return templateContent;
    } catch (e) {
      if (e is TemplateException) rethrow;
      throw TemplateRenderException('Failed to render template $templateName', cause: e);
    }
  }

  /// Loads a template from the file system.
  /// 
  /// [templateName] - Name of the template file
  /// 
  /// Returns the raw template content as a string.
  Future<String> _loadTemplate(String templateName) async {
    final cacheKey = templateName;
    
    // Check cache first if caching is enabled
    if (enableCaching && templateCache.containsKey(cacheKey)) {
      return templateCache[cacheKey]!;
    }

    final userPath = _resolveTemplatePath(baseDirectory, templateName);
    final fallbackPath = _resolveTemplatePath(fallbackDirectory, templateName);

    if (await File(userPath).exists()) {
      final content = await File(userPath).readAsString();
      if (enableCaching) templateCache[cacheKey] = content;
      return content;
    }

    try {
      final content = await jetLeafAssetLoader.load(fallbackPath);
      if (enableCaching) templateCache[cacheKey] = content;
      return content;
    } catch (e) {
      throw TemplateNotFoundException('Template not found: $templateName', cause: e);
    }
  }
  
  /// Resolves the full file path for a template.
  /// 
  /// [templateName] - Name of the template
  /// 
  /// Returns the full file path including the .html extension.
  String _resolveTemplatePath(String baseDirectory, String templateName) {
    // Handle nested templates (e.g., 'user/profile' -> 'user/profile.html')
    final normalizedName = templateName.replaceAll('\\', '/');
    final fileName = normalizedName.endsWith('.html') ? normalizedName : '$normalizedName.html';
    return '$baseDirectory/$fileName';
  }
  
  /// Renders a template with the provided context.
  /// 
  /// [template] - The raw template content
  /// [context] - Variables to inject into the template
  /// 
  /// Returns the rendered HTML string.
  String _renderTemplate(String template, Map<String, dynamic> context) {
    String result = template;
    
    // Process includes first ({{>templateName}})
    result = _processIncludes(result, context);
    
    // Process conditionals ({{#if condition}}...{{/if}})
    result = _processConditionals(result, context);
    
    // Process loops ({{#each items}}...{{/each}})
    result = _processLoops(result, context);
    
    // Process variables ({{variableName}})
    result = _processVariables(result, context);
    
    return result;
  }
  
  /// Processes template includes.
  /// 
  /// Syntax: `{{>templateName}}`
  String _processIncludes(String template, Map<String, dynamic> context) {
    final includePattern = RegExp(r'\{\{>\s*([^}]+)\s*\}\}');
    
    return template.replaceAllMapped(includePattern, (match) {
      final templateName = match.group(1)!.trim();
      try {
        // Recursively load and render the included template
        final includedContent = _loadTemplate(templateName);
        return _renderTemplate(includedContent as String, context);
      } catch (e) {
        return '<!-- Include error: $templateName - $e -->';
      }
    });
  }
  
  /// Processes conditional blocks.
  /// 
  /// Syntax: `{{#if condition}}content{{/if}}`
  String _processConditionals(String template, Map<String, dynamic> context) {
    final conditionalPattern = RegExp(r'\{\{#if\s+([^}]+)\}\}(.*?)\{\{/if\}\}', dotAll: true);
    
    return template.replaceAllMapped(conditionalPattern, (match) {
      final condition = match.group(1)!.trim();
      final content = match.group(2)!;
      
      final conditionValue = _evaluateCondition(condition, context);
      return conditionValue ? content : '';
    });
  }
  
  /// Processes loop blocks.
  /// 
  /// Syntax: `{{#each items}}content{{/each}}`
  String _processLoops(String template, Map<String, dynamic> context) {
    final loopPattern = RegExp(r'\{\{#each\s+([^}]+)\}\}(.*?)\{\{/each\}\}', dotAll: true);
    
    return template.replaceAllMapped(loopPattern, (match) {
      final itemsKey = match.group(1)!.trim();
      final content = match.group(2)!;
      
      final items = _getNestedValue(itemsKey, context);
      if (items is! List) return '';
      
      final buffer = StringBuffer();
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        final itemContext = Map<String, dynamic>.from(context);
        itemContext['this'] = item;
        itemContext['@index'] = i;
        itemContext['@first'] = i == 0;
        itemContext['@last'] = i == items.length - 1;
        
        buffer.write(_renderTemplate(content, itemContext));
      }
      
      return buffer.toString();
    });
  }
  
  /// Processes variable interpolation.
  /// 
  /// Syntax: `{{variableName}}`
  String _processVariables(String template, Map<String, dynamic> context) {
    final variablePattern = RegExp(r'\{\{([^#/>][^}]*)\}\}');
    
    return template.replaceAllMapped(variablePattern, (match) {
      final variableName = match.group(1)!.trim();
      final value = _getNestedValue(variableName, context);
      return _escapeHtml(value?.toString() ?? '');
    });
  }
  
  /// Evaluates a condition for conditional rendering.
  /// 
  /// [condition] - The condition string to evaluate
  /// [context] - The current template context
  /// 
  /// Returns true if the condition is truthy, false otherwise.
  bool _evaluateCondition(String condition, Map<String, dynamic> context) {
    final value = _getNestedValue(condition, context);
    
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) return value.isNotEmpty;
    if (value is num) return value != 0;
    if (value is List) return value.isNotEmpty;
    if (value is Map) return value.isNotEmpty;
    
    return true;
  }
  
  /// Gets a nested value from the context using dot notation.
  /// 
  /// [path] - The path to the value (e.g., 'user.name')
  /// [context] - The context map
  /// 
  /// Returns the value at the specified path, or null if not found.
  dynamic _getNestedValue(String path, Map<String, dynamic> context) {
    final parts = path.split('.');
    dynamic current = context;
    
    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else {
        return null;
      }
    }
    
    return current;
  }
  
  /// Escapes HTML special characters to prevent XSS attacks.
  /// 
  /// [text] - The text to escape
  /// 
  /// Returns the escaped text.
  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;');
  }

  @override
  Map<String, String> getCachedTemplates() => templateCache;

  @override
  void clearCachedTemplates() => templateCache.clear();
}