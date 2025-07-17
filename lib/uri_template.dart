/// {@template uri_library}
/// 
/// This library provides a pluggable, highly customizable URI template solution
/// for complex and simple URI parsing and formatting.
/// 
/// A zero-dependency Dart utility for parsing, matching, expanding, and normalizing URI templates — perfect for routing, dynamic URL generation, and robust path comparisons in JetLeaf and general Dart projects.
/// 
/// ### ✨ Features
/// 
/// - 🔄 **Template Matching** – Extract variables from paths (e.g. `/users/{id}`)
/// - 🔧 **Template Expansion** – Generate full paths from variable maps
/// - 🧹 **Path Normalization** – Clean and standardize messy URLs
/// - 🧭 **Full URL Normalization** – Canonicalizes scheme, host, port, path, query, and fragment
/// - 🔒 **Safe and Typed API** – Fully null-safe and exception-based error handling
/// 
/// ### 📦 Exports:
/// - [UriTemplate] — loads and caches internal files
/// - [UriTemplateException] — error thrown when asset fails to resolve
/// {@endtemplate}
/// 
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library uri;

export 'src/uri_template/exception.dart';
export 'src/uri_template/uri_template.dart';