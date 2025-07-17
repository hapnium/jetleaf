import 'package:test/test.dart';
import 'package:jetleaf/src/env/standard_environment.dart';
import 'package:jetleaf/src/env/property_source/map_property_source.dart';

import '../_dependencies/conversion.dart';

void main() {
  group('StandardEnvironment', () {
    late StandardEnvironment env;

    setUp(() {
      env = StandardEnvironment();
      env.setConversionService(getConversionService());
      env.propertySources.addFirst(MapPropertySource('testSource', {
        'app.name': 'JetLeaf',
        'app.version': '1.0.0',
        'server.port': '8080',
        'greeting': 'Hello, \${app.name}!',
        'welcome': 'Welcome to @app.name@ version \${app.version}',
      }));
    });

    test('containsProperty returns true for existing key', () {
      expect(env.containsProperty('app.name'), isTrue);
    });

    test('getProperty returns correct value', () {
      expect(env.getProperty('app.name'), equals('JetLeaf'));
    });

    test('getPropertyAs<int> returns typed value', () {
      expect(env.getPropertyAs<int>('server.port'), equals(8080));
    });

    test('getRequiredProperty throws on missing key', () {
      expect(() => env.getRequiredProperty('missing.key'), throwsA(isA<Exception>()));
    });

    test('resolvePlaceholders resolves nested placeholders', () {
      final resolved = env.resolvePlaceholders(r'${greeting}');
      expect(resolved, equals('Hello, JetLeaf!'));
    });

    test('resolvePlaceholders with @ syntax', () {
      final resolved = env.resolvePlaceholders(r'@app.name@');
      expect(resolved, equals('JetLeaf'));
    });

    test('resolvePlaceholders with mixed syntax', () {
      final resolved = env.resolvePlaceholders(r'Welcome: @app.name@ v${app.version}');
      expect(resolved, equals('Welcome: JetLeaf v1.0.0'));
    });

    test('activeProfiles is initially empty', () {
      expect(env.activeProfiles, isEmpty);
    });

    test('can set active and default profiles', () {
      env.setDefaultProfiles(['dev']);
      env.setActiveProfiles(['prod']);
      expect(env.activeProfiles, contains('prod'));
      expect(env.defaultProfiles, contains('dev'));
    });
  });
}