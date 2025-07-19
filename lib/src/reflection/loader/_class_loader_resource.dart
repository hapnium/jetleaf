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

import 'dart:io' show File;

import 'package:jetleaf/lang.dart';

import 'class_loader_resource.dart';

/// {@template class_loader_resource_impl}
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
class ClassLoaderResourceImpl extends ClassLoaderResource {
  /// {@macro class_loader_resource_impl}
  ClassLoaderResourceImpl(super.uri, super.timestamp, [super.ttl = const Duration(minutes: 5)]);

  @override
  InputStream getInputStream() {
    return FileInputStream.fromFile(File.fromUri(uri));
  }
}