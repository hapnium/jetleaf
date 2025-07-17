import 'package:test/test.dart';
import 'class_test.dart' as class_test;
import 'reflection_utils_test.dart' as reflection_utils_test;

void main() => group('Reflection Tests', () {
  class_test.main();
  reflection_utils_test.main();
});