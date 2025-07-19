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
import 'package:jetleaf/src/jtl/_template_engine.dart';
import 'package:jetleaf/src/jtl/exceptions.dart';

void main() {
  late Directory tempDir;
  late JtlTemplateEngine engine;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('jetleaf_test_');
    final file = File('${tempDir.path}/hello.html');
    await file.writeAsString('Hello, {{name}}!');

    engine = JtlTemplateEngine(baseDirectory: tempDir.path);
  });

  tearDown(() async {
    await tempDir.delete(recursive: true);
  });

  test('renders a template with variable', () async {
    final result = await engine.render('hello', {'name': 'Dart'});
    expect(result, equals('Hello, Dart!'));
  });

  test('returns raw template if no variables', () async {
    final result = await engine.render('hello');
    expect(result, equals('Hello, {{name}}!'));
  });

  test('throws TemplateNotFoundException if missing', () async {
    expect(
      () => engine.render('missing'),
      throwsA(isA<TemplateNotFoundException>()),
    );
  });

  test('caches template by default', () async {
    await engine.render('hello', {'name': 'Cache'});
    expect(engine.getCachedTemplates().containsKey('hello'), isTrue);
  });

  test('clears cache when requested', () async {
    await engine.render('hello', {'name': 'Cache'});
    engine.clearCachedTemplates();
    expect(engine.getCachedTemplates().containsKey('hello'), isFalse);
  });
}