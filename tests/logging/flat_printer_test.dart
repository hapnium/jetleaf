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

import 'package:jetleaf/src/logging/printers/flat_printer.dart';
import 'package:jetleaf/src/logging/printers/flat_structured_printer.dart';
import 'package:test/test.dart';
import 'package:jetleaf/logging.dart';

import '../_dependencies/logger.dart';

void main() {
  group('FlatPrinter', () {
    test('prints timestamp, level, and message', () {
      final printer = FlatPrinter(
        config: defaultConfig(steps: [LogStep.TIMESTAMP, LogStep.LEVEL, LogStep.MESSAGE]),
      );

      final record = sampleRecord();
      final result = printer.log(record).first;

      expect(result, contains(record.time.toIso8601String()));
      expect(result, contains('INFO'));
      expect(result, contains('Test log'));
    });

    test('omits tag when showTag is false', () {
      final printer = FlatPrinter(
        config: defaultConfig(steps: [LogStep.TAG, LogStep.MESSAGE], showTag: false),
      );

      final record = sampleRecord(tag: 'MyLogger');
      final result = printer.log(record).first;

      expect(result, isNot(contains('MyLogger')));
    });
  });

  group('FlatStructuredPrinter', () {
    test('prints main line and stack trace lines', () {
      final printer = FlatStructuredPrinter(
        config: defaultConfig(steps: [LogStep.MESSAGE, LogStep.STACKTRACE]),
      );

      final record = sampleRecord(
        message: 'error occurred',
        stackTrace: StackTrace.current,
      );

      final result = printer.log(record);
      expect(result.first, contains('error occurred'));
      expect(result.any((line) => line.trim().startsWith('↪')), isTrue);
    });
  });
}