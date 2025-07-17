import 'package:jetleaf/logging.dart';
import 'package:jetleaf/src/logging/printers/simple_printer.dart';
import 'package:test/test.dart';

import '../_dependencies/logger.dart';

void main() {
  group('SimplePrinter', () {
    test('formats basic output', () {
      final printer = SimplePrinter(
        config: defaultConfig(steps: [LogStep.LEVEL, LogStep.MESSAGE]),
      );

      final record = sampleRecord(level: LogLevel.ERROR, message: 'Oops!');
      final result = printer.log(record).first;

      expect(result, contains('[E]'));
      expect(result, contains('Oops!'));
    });
  });
}