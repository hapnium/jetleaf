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

import 'dart:typed_data' show Uint8List;

/// {@template resource_resolver}
/// Defines the contract for resolving and loading resources from various sources
/// such as file systems, HTTP, Dart packages, or in-memory caches.
///
/// This abstraction supports asynchronous operations, glob pattern resolution,
/// and cache invalidation. It enables modular and pluggable resource access
/// strategies for environments like compilers, interpreters, or dynamic loaders.
///
/// Common use cases include loading configuration files, code artifacts, assets,
/// or bytecode dynamically.
/// {@endtemplate}
abstract class ResourceResolver {
  /// {@macro resource_resolver}
  const ResourceResolver();

  /// Resolves a resource by name and returns its URI if found.
  ///
  /// This may search the file system, package config, HTTP endpoints, or other
  /// defined resolution strategies depending on implementation.
  ///
  /// Returns `null` if the resource is not found.
  Future<Uri?> resolveResource(String name);

  /// Resolves all matching resources for the provided [namePattern].
  ///
  /// This supports glob patterns and returns a list of all matching URIs.
  ///
  /// Example:
  /// ```dart
  /// final uris = await resolver.resolveAllResources('lib/**.dart');
  /// ```
  Future<List<Uri>> resolveAllResources(String namePattern);

  /// Loads the content of the resource at [uri] as a string.
  ///
  /// Returns `null` if the resource cannot be found or read.
  Future<String?> loadResourceAsString(Uri uri);

  /// Loads the content of the resource at [uri] as a byte array.
  ///
  /// Returns `null` if the resource cannot be found or read.
  Future<Uint8List?> loadResourceAsBytes(Uri uri);

  /// Clears any internal or cached resolution results.
  ///
  /// Useful when working with dynamic sources or after changes to the file system.
  void clearCache();

  // ---------------------------------------------------------------------------
  // Protected/internal resolution strategies
  // ---------------------------------------------------------------------------

  /// Resolves a resource using the Dart package system.
  ///
  /// Example:
  /// ```dart
  /// final uri = await resolvePackageResource('package:jetleaf/core.dart');
  /// ```
  Future<Uri?> resolvePackageResource(String packageUri);

  /// Resolves a resource that begins with `dart:` such as `dart:io`.
  ///
  /// These are typically SDK-provided sources and may be mapped differently.
  Future<Uri?> resolveDartResource(String dartUri);

  /// Resolves a resource from the file system using a `file:` URI.
  Future<Uri?> resolveFileResource(String fileUri);

  /// Resolves a resource from a remote HTTP or HTTPS URL.
  Future<Uri?> resolveHttpResource(String httpUri);

  /// Resolves a relative resource by interpreting it within the
  /// current context or root directory.
  Future<Uri?> resolveRelativeResource(String name);

  /// Resolves resources using a glob-style [pattern].
  ///
  /// Example:
  /// ```dart
  /// final matches = await resolveGlobPattern('config/**/*.yaml');
  /// ```
  Future<List<Uri>> resolveGlobPattern(String pattern);

  /// Loads and returns the current Dart package configuration.
  ///
  /// Returns a parsed JSON-like map of the `.dart_tool/package_config.json`
  /// file or equivalent. May be used to support package-based resolution.
  Future<Map<String, dynamic>?> getPackageConfig();

  /// Returns `true` if the resource at [uri] exists and can be accessed.
  ///
  /// This performs a lightweight check that may involve file system or network access.
  Future<bool> resourceExists(Uri uri);
}