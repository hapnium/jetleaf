/// {@template bundler_library}
/// 🗂️ JetLeaf Bundler Library
/// 
/// The `bundler` library enables asset resolution and loading in pure Dart projects
/// similarly to how Flutter handles assets via `rootBundle`.
/// 
/// ---
/// 
/// ### 🔍 Features:
/// - Access static files from JetLeaf internal packages (HTML, templates, etc)
/// - Compatible with `pub.dev`, local paths, and executable builds
/// - Caches file reads to optimize performance
/// 
/// ---
/// 
/// ### Example:
/// ```dart
/// final html404 = await BundlerManager.load('resources/html/404.html');
/// ```
/// 
/// ---
///
/// ### 📦 Exports:
/// - [BundlerManager] — loads and caches internal files
/// - [BundlerException] — error thrown when asset fails to resolve
/// {@endtemplate}
/// 
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library;

export 'src/bundler.dart';
export 'src/interface.dart';
export 'src/exceptions.dart';