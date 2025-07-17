import 'package:test/test.dart';
import 'package:jetleaf/reflection.dart';

class SimpleClass {
  String name = 'Dart';
  int value = 42;

  void sayHello() {}
}


void main() {
  group('Class<T> basics', () {
    late Class<SimpleClass> clazz;

    setUp(() {
      clazz = Class<SimpleClass>();
    });

    test('should return correct simple and qualified name', () {
      expect(clazz.simpleName, equals('SimpleClass'));
      expect(clazz.qualifiedName.contains('SimpleClass'), isTrue);
    });

    test('should return correct type', () {
      expect(clazz.type, equals(SimpleClass));
      expect(clazz.typeName, equals('SimpleClass'));
    });

    test('should recognize primitive types', () {
      expect(Class<int>().isPrimitive(), isTrue);
      expect(Class<String>().isPrimitive(), isTrue);
      expect(Class<SimpleClass>().isPrimitive(), isFalse);
    });

    test('should detect array type correctly', () {
      expect(Class<List<String>>().isArray(), isTrue);
      expect(Class<SimpleClass>().isArray(), isFalse);
    });

    test('should return descriptor string', () {
      expect(Class<int>().descriptorString(), equals('I'));
      expect(Class<String>().descriptorString(), equals('Ljava/lang/String;'));
    });

    test('should create new instance', () {
      final instance = clazz.newInstance();
      expect(instance, isA<SimpleClass>());
    });

    test('should get fields and methods', () {
      final fields = clazz.getDeclaredFields();
      expect(fields.containsKey('name'), isTrue);
      expect(fields.containsKey('value'), isTrue);

      final methods = clazz.getDeclaredMethods();
      expect(methods.containsKey('sayHello'), isTrue);
    });

    test('should return null for non-existent method or field', () {
      expect(clazz.getMethod('nonExistentMethod'), isNull);
      expect(clazz.getField('nonExistentField'), isNull);
    });

    test('should match equal class types', () {
      final another = Class<SimpleClass>();
      expect(clazz == another, isTrue);
      expect(clazz.equals(another), isTrue);
    });

    test('should handle toString properly', () {
      expect(clazz.toString(), equals('Class<SimpleClass>'));
    });
  });

  group('Error handling', () {
    test('should throw on invalid type for fromType', () {
      expect(() => Class.fromType(_FakeType()), throwsA(isA<ClassInstantiationException>()));
    });
  });
}

class _FakeType implements Type {}