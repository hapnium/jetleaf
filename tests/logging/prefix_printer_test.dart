import 'package:jetleaf/src/logging/printers/prefix_printer.dart';
import 'package:test/test.dart';
import 'package:jetleaf/logging.dart';

import '../_dependencies/logger.dart';

void main() {
  group('PrefixPrinter', () {
    test('applies prefix and color', () {
      final printer = PrefixPrinter(
        config: defaultConfig(steps: [LogStep.LEVEL, LogStep.MESSAGE]),
      );

      final record = sampleRecord(level: LogLevel.WARN, message: 'Warning!');
      final result = printer.log(record).first;

      expect(result, contains('⚠️'));
      expect(result, contains('Warning!'));
    });
  });
}