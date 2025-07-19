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

import 'package:jetleaf/src/logging/printers/fmt_printer.dart';
import 'package:test/test.dart';
import 'package:jetleaf/logging.dart';

import '../_dependencies/logger.dart';

void main() {
  group('FmtPrinter', () {
    test('formats key-value pairs', () {
      final printer = FmtPrinter(
        config: defaultConfig(steps: [LogStep.LEVEL, LogStep.MESSAGE, LogStep.TIMESTAMP]),
      );

      final record = sampleRecord();
      final result = printer.log(record).first;

      expect(result, contains('level=info'));
      expect(result, contains('msg="Test log"'));
      expect(result, contains('time='));
    });
  });
}