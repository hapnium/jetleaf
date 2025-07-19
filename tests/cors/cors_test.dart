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

import 'dart:io';

import 'package:test/test.dart';
import 'package:jetleaf/cors.dart';

class FakeHttpRequest implements HttpRequest {
  @override
  final Uri uri;

  FakeHttpRequest(this.uri);

  // All other members are unimplemented for brevity
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CorsConfiguration', () {
    test('default values are correct', () {
      const config = CorsConfiguration();

      expect(config.allowedOrigins, ['*']);
      expect(config.allowedMethods, ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS']);
      expect(config.allowedHeaders, ['*']);
      expect(config.exposedHeaders, []);
      expect(config.allowCredentials, isFalse);
      expect(config.maxAgeSeconds, 86400);
    });

    test('custom values are stored correctly', () {
      const config = CorsConfiguration(
        allowedOrigins: ['https://example.com'],
        allowedMethods: ['GET'],
        allowedHeaders: ['Authorization'],
        exposedHeaders: ['X-Header'],
        allowCredentials: true,
        maxAgeSeconds: 3600,
      );

      expect(config.allowedOrigins, ['https://example.com']);
      expect(config.allowedMethods, ['GET']);
      expect(config.allowedHeaders, ['Authorization']);
      expect(config.exposedHeaders, ['X-Header']);
      expect(config.allowCredentials, isTrue);
      expect(config.maxAgeSeconds, 3600);
    });
  });

  group('PathBasedCorsConfigurationSource', () {
    late PathBasedCorsConfigurationSource source;

    setUp(() {
      source = PathBasedCorsConfigurationSource();
    });

    test('returns configuration for matching path prefix', () {
      final config = CorsConfiguration(allowedOrigins: ['https://allowed.com']);
      source.register('/api/public', config);

      final request = FakeHttpRequest(Uri.parse('/api/public/data'));

      final result = source.getCorsConfiguration(request);
      expect(result, equals(config));
    });

    test('returns null when no path matches', () {
      source.register('/admin', CorsConfiguration());

      final request = FakeHttpRequest(Uri.parse('/user/home'));

      final result = source.getCorsConfiguration(request);
      expect(result, isNull);
    });

    test('matches the first prefix in insertion order', () {
      final first = CorsConfiguration(allowedOrigins: ['https://first.com']);
      final second = CorsConfiguration(allowedOrigins: ['https://second.com']);

      source.register('/api', first);
      source.register('/api/v1', second);

      final request = FakeHttpRequest(Uri.parse('/api/v1/resource'));

      // Note: Dart map iteration order is insertion order, so '/api' wins
      final result = source.getCorsConfiguration(request);
      expect(result, equals(first));
    });
  });
}