/// {@template jtl_library}
/// The core library for the JetLeaf Template Language (JTL).
///
/// This library provides the default template engine used by the JetLeaf
/// framework to render HTML templates with support for:
/// - Variable interpolation
/// - Conditional rendering
/// - Looping
/// - Template includes
///
/// It exposes the main APIs for using and loading templates, as well as
/// exceptions related to template parsing and rendering.
///
/// Example usage:
/// ```dart
/// final engine = TemplateEngineLoader.load();
/// final result = await engine.render('hello.html', {'name': 'World'});
/// ```
/// {@endtemplate}
/// 
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library;

export 'src/jtl/template_engine.dart';
export 'src/jtl/exceptions.dart';