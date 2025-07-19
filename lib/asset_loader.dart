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
/// final html404 = await AssetLoader.load('resources/html/404.html');
/// ```
/// 
/// ---
///
/// ### 📦 Exports:
/// - [AssetLoader] — loads and caches internal files
/// - [AssetLoaderException] — error thrown when asset fails to resolve
/// {@endtemplate}
/// 
/// @author Evaristus Adimonyemma
/// @emailAddress evaristusadimonyemma@hapnium.com
/// @organization Hapnium
/// @website https://hapnium.com
library;

export 'src/asset_loader/bundler.dart';
export 'src/asset_loader/interface.dart';
export 'src/asset_loader/exceptions.dart';