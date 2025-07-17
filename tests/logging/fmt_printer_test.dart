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