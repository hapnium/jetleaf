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

import 'package:jetleaf/lang.dart';

/// {@template class_loader_resource}
/// Represents a resource that has been cached for a limited time.
///
/// A `ClassLoaderResource` holds the [uri] of the resource, the [timestamp] at which
/// it was cached, and an optional [ttl] (time-to-live) duration that determines
/// how long the resource is considered valid.
///
/// The [isExpired] getter can be used to check if the cache has expired.
///
/// ### Example:
/// ```dart
/// final resource = ClassLoaderResource(Uri.parse('https://example.com'), DateTime.now());
/// if (resource.isExpired) {
///   print('Cache expired');
/// }
/// ```
/// {@endtemplate}
abstract class ClassLoaderResource implements InputStreamSource{
  /// The URI of the cached resource.
  final Uri uri;

  /// The timestamp indicating when the resource was cached.
  final DateTime timestamp;

  /// The time-to-live for the cache. Defaults to 5 minutes.
  final Duration ttl;

  /// {@macro class_loader_resource}
  ClassLoaderResource(this.uri, this.timestamp, [this.ttl = const Duration(minutes: 5)]);

  /// Returns `true` if the cache has expired based on the [ttl] and [timestamp].
  bool get isExpired => DateTime.now().difference(timestamp) > ttl;
}