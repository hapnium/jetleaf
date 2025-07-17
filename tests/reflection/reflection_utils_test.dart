import 'package:jetleaf/reflection.dart';
import 'package:test/test.dart';

const isIllegalArgumentTypeException = TypeMatcher<IllegalArgumentTypeException>();
Matcher throwsIllegalArgumentTypeException = throwsA(isIllegalArgumentTypeException);

// === Annotations ===
class Service extends ReflectableAnnotation {
  const Service();

  @override
  Type get annotationType => Service;
}

class FieldMark extends ReflectableAnnotation {
  const FieldMark();

  @override
  Type get annotationType => FieldMark;
}

class MethodMark extends ReflectableAnnotation {
  const MethodMark();

  @override
  Type get annotationType => MethodMark;
}

// === Classes for Testing ===
@Service()
class UserService {
  String name = 'User';

  @FieldMark()
  int age = 30;

  @MethodMark()
  void greet() {}

  void update() {}
}

class AdvancedService extends UserService {}

class Dummy {}

abstract class AbstractService {}

class CopyTarget {
  String name = '';
  int age = 0;
}

void main() {
  group('ReflectionUtils', () {
    test('findClassesWithAnnotation returns classes with annotation', () {
      final classes = ReflectionUtils.findClassesWithAnnotation<Service>();
      expect(classes.any((c) => c.getSimpleName() == 'UserService'), isTrue);
    });

    test('findClassesImplementing returns classes implementing an interface', () {
      final results = ReflectionUtils.findClassesImplementing<UserService>();
      expect(results.any((c) => c.getSimpleName() == 'AdvancedService'), isTrue);
    });

    test('findSubclassesOf returns subclasses', () {
      final subclasses = ReflectionUtils.findSubclassesOf<UserService>();
      expect(subclasses.map((c) => c.getSimpleName()), contains('AdvancedService'));
    });

    test('findMethodsWithAnnotation returns annotated methods', () {
      final classMirror = ClassMirror.forType<UserService>();
      final methods = ReflectionUtils.findMethodsWithAnnotation<MethodMark>(classMirror);
      expect(methods.any((m) => m.getName() == 'greet'), isTrue);
    });

    test('findMethodsByName returns methods by name', () {
      final classMirror = ClassMirror.forType<UserService>();
      final methods = ReflectionUtils.findMethodsByName(classMirror, 'update');
      expect(methods.length, 1);
      expect(methods.first.getName(), 'update');
    });

    test('hasMethod returns true if method exists', () {
      expect(ReflectionUtils.hasMethod<UserService>('greet'), isTrue);
    });

    test('hasMethod returns false if method does not exist', () {
      expect(ReflectionUtils.hasMethod<UserService>('nonExistent'), isFalse);
    });

    test('findFieldsWithAnnotation returns annotated fields', () {
      final classMirror = ClassMirror.forType<UserService>();
      final fields = ReflectionUtils.findFieldsWithAnnotation<FieldMark>(classMirror);
      expect(fields.map((f) => f.getName()), contains('age'));
    });

    test('findFieldsOfType returns fields of specific type', () {
      final classMirror = ClassMirror.forType<UserService>();
      final fields = ReflectionUtils.findFieldsOfType<int>(classMirror);
      expect(fields.map((f) => f.getName()), contains('age'));
    });

    test('hasField returns true if field exists', () {
      expect(ReflectionUtils.hasField<UserService>('name'), isTrue);
    });

    test('hasField returns false if field does not exist', () {
      expect(ReflectionUtils.hasField<UserService>('foo'), isFalse);
    });

    test('copyProperties copies field values between objects', () {
      final source = UserService()..name = 'Alice'..age = 42;
      final target = CopyTarget();

      ReflectionUtils.copyProperties(source, target);

      expect(target.name, 'Alice');
      expect(target.age, 42);
    });

    test('copyProperties throws if null passed', () {
      expect(() => ReflectionUtils.copyProperties(null, Dummy()), throwsIllegalArgumentTypeException);
    });

    test('deepCopy creates a deep copy', () {
      final original = UserService()..name = 'Bob'..age = 33;
      final copy = ReflectionUtils.deepCopy(original);

      expect(copy.runtimeType, UserService);
      expect(copy.name, 'Bob');
      expect(copy.age, 33);
      expect(copy, isNot(same(original)));
    });

    test('isInstanceOf returns true when match', () {
      expect(ReflectionUtils.isInstanceOf<UserService>(UserService()), isTrue);
    });

    test('isInstanceOf returns false when mismatch', () {
      expect(ReflectionUtils.isInstanceOf<UserService>('string'), isFalse);
    });

    test('getType returns ClassMirror for object', () {
      final mirror = ReflectionUtils.getType(UserService());
      expect(mirror.getSimpleName(), 'UserService');
    });

    test('isAssignable returns true when compatible', () {
      expect(ReflectionUtils.isAssignable<AdvancedService, UserService>(), isTrue);
    });

    test('isAssignable returns false when incompatible', () {
      expect(ReflectionUtils.isAssignable<String, UserService>(), isFalse);
    });

    test('getInheritedAnnotations returns annotations from superclasses', () {
      final classMirror = ClassMirror.forType<AdvancedService>();
      final annotations = ReflectionUtils.getInheritedAnnotations<Service>(classMirror);
      expect(annotations.length, 1);
    });

    test('processAnnotatedClasses runs callback for each annotated class', () {
      final found = <String>[];

      ReflectionUtils.processAnnotatedClasses<Service>((classMirror, annotation) {
        found.add(classMirror.getSimpleName());
      });

      expect(found, contains('UserService'));
    });

    test('validateClass returns true when all criteria pass', () {
      final classMirror = ClassMirror.forType<UserService>();
      final isValid = ReflectionUtils.validateClass(classMirror, [
        (c) => !c.isAbstract(),
        (c) => c.getConstructors().isNotEmpty,
      ]);
      expect(isValid, isTrue);
    });

    test('validateMethod returns true when all method criteria pass', () {
      final classMirror = ClassMirror.forType<UserService>();
      final method = classMirror.getMethod('greet');
      final isValid = ReflectionUtils.validateMethod(method, [
        (m) => !m.isStatic(),
      ]);
      expect(isValid, isTrue);
    });
  });
}
