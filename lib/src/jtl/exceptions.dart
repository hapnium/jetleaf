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

/// {@template template_exception}
/// Base class for all template-related exceptions within JetLeaf.
///
/// This abstract class represents failures that occur during the loading,
/// parsing, or rendering of templates. Subclasses provide specific context
/// (e.g., missing templates, render-time errors).
///
/// All [TemplateException]s extend [JetException], allowing integration into
/// JetLeaf's centralized error-handling and logging mechanisms.
///
/// {@endtemplate}
abstract class TemplateException implements Exception {
  /// The error message
  final String message;
  
  /// The underlying cause of this exception, if any.
  final Object? cause;

  /// Constructs a [TemplateException] with an error [message] and optional [cause].
  ///
  /// The [cause] can be another exception that triggered this one, enabling
  /// better debugging and exception chaining.
  ///
  /// {@macro template_exception}
  TemplateException(this.message, {this.cause});
  
  @override
  String toString() => 'TemplateException: $message';
}

/// {@template template_not_found_exception}
/// Thrown when a template file cannot be located or loaded.
///
/// This typically occurs when a referenced template file does not exist
/// at the expected path, or if the resource system fails to resolve the template.
///
/// ### Example:
/// ```dart
/// throw TemplateNotFoundException(
///   'Template "emails/welcome.html" not found',
///   FileSystemException('No such file'),
/// );
/// ```
///
/// {@endtemplate}
class TemplateNotFoundException extends TemplateException {
  /// {@macro template_not_found_exception}
  TemplateNotFoundException(super.message, {super.cause});

  @override
  String toString() => 'TemplateNotFoundException: $message';
}

/// {@template template_render_exception}
/// Thrown when an error occurs during the rendering phase of a template.
///
/// This could be due to:
/// - Invalid variables or context passed to the template
/// - Malformed syntax inside the template
/// - Runtime issues during dynamic evaluation
///
/// ### Example:
/// ```dart
/// throw TemplateRenderException('Error rendering welcome email');
/// ```
///
/// {@endtemplate}
class TemplateRenderException extends TemplateException {
  /// {@macro template_render_exception}
  TemplateRenderException(super.message, {super.cause});

  @override
  String toString() => 'TemplateRenderException: $message';
}