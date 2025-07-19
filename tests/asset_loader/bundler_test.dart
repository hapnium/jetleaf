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
import 'package:jetleaf/asset_loader.dart';

void main() {
  late AssetLoaderInterface bundler;

  setUp(() {
    // Use a test package with known structure or mock setup
    bundler = AssetLoader.forPackage('jetleaf_bundler');
  });

  group('JetLeafAssetBundler', () {
    test('loads existing asset', () async {
      final content = await bundler.load('tests/sample.txt');
      expect(content, contains('Hello, Test!'));
    });

    test('returns false for nonexistent asset (exists)', () async {
      final exists = await bundler.exists('tests/does_not_exist.txt');
      expect(exists, isFalse);
    });

    test('throws BundlerException for nonexistent asset (load)', () async {
      expect(
        () => bundler.load('test/does_not_exist.txt'),
        throwsA(predicate((e) =>
          e is AssetLoaderException &&
          e.message.contains('Failed to load asset') &&
          e.assetPath == 'test/does_not_exist.txt'
        )),
      );
    });

    test('returns package name', () {
      expect(bundler.packageName, equals('jetleaf_bundler'));
    });

    test('gets non-null package root', () async {
      final root = await bundler.getPackageRoot();
      expect(root, isNotNull);
      expect(Directory(root!).existsSync(), isTrue);
    });

    test('clears cache without error', () {
      expect(() => bundler.clearCache(), returnsNormally);
    });
  });
}