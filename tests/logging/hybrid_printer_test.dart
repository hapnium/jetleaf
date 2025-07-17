import 'package:jetleaf/src/logging/printers/hybrid_printer.dart';
import 'package:test/test.dart';
import 'package:jetleaf/logging.dart';

import '../_dependencies/logger.dart';

void main() {
  group('HybridPrinter', () {
    test('uses simple printer for DEBUG', () {
      final printer = HybridPrinter();

      final debugRecord = sampleRecord(level: LogLevel.DEBUG, message: 'debug');
      final result = printer.log(debugRecord).first;

      expect(result.toLowerCase(), contains('debug'));
    });

    test('uses pretty printer for INFO', () {
      final printer = HybridPrinter();

      final infoRecord = sampleRecord(level: LogLevel.INFO, message: 'info');
      final result = printer.log(infoRecord);

      expect(result.length, greaterThan(1)); // PrettyPrinter uses box borders
    });
  });
}