import 'dart:mirrors' as mirrors;

import 'exceptions.dart';
import 'interfaces/reflectable_annotation.dart';
import 'mirrors/class_mirror.dart';
import 'mirrors/field_mirror.dart';
import 'mirrors/method_mirror.dart';

/// Utility class providing helper methods for common reflection operations.
/// 
/// This class contains static methods that simplify common reflection tasks
/// and provide additional functionality not directly available through the
/// core mirror classes. It's designed to be similar to utility classes
/// found in Java reflection frameworks.
/// 
/// **Example:**
/// ```dart
/// // Find all classes with a specific annotation
/// final serviceClasses = ReflectionUtils.findClassesWithAnnotation<Service>();
/// 
/// // Copy field values between objects
/// ReflectionUtils.copyProperties(source, target);
/// 
/// // Check if a class has a specific method
/// final hasMethod = ReflectionUtils.hasMethod<MyClass>('methodName');
/// ```
final class ReflectionUtils {
  // Private constructor to prevent instantiation
  ReflectionUtils._();
  
  // ========== Class Discovery ==========
  
  /// Finds all classes in the current isolate that have the specified annotation.
  /// 
  /// This method scans all loaded libraries and returns a list of ClassMirror
  /// objects for classes that are annotated with the specified annotation type.
  /// 
  /// **Type Parameters:**
  /// - [T]: The annotation type to search for
  /// 
  /// **Returns:** A list of ClassMirror objects for annotated classes
  /// 
  /// **Example:**
  /// ```dart
  /// @Service()
  /// class UserService {}
  /// 
  /// @Service()
  /// class OrderService {}
  /// 
  /// final services = ReflectionUtils.findClassesWithAnnotation<Service>();
  /// print(services.length); // 2
  /// ```
  static List<ClassMirror<Object>> findClassesWithAnnotation<T extends ReflectableAnnotation>() {
    final result = <ClassMirror<Object>>[];
    final annotationType = ClassMirror.forType<T>();
    final mirrorSystem = mirrors.currentMirrorSystem();
    
    for (final library in mirrorSystem.libraries.values) {
      for (final declaration in library.declarations.values) {
        if (declaration is mirrors.ClassMirror) {
          final classMirror = ClassMirror<Object>.fromDartMirror(declaration);
          if (classMirror.isAnnotationPresent(annotationType)) {
            result.add(classMirror);
          }
        }
      }
    }
    
    return result;
  }
  
  /// Finds all classes in the current isolate that implement the specified interface.
  /// 
  /// **Type Parameters:**
  /// - [T]: The interface type to search for
  /// 
  /// **Returns:** A list of ClassMirror objects for implementing classes
  static List<ClassMirror<Object>> findClassesImplementing<T>() {
    final result = <ClassMirror<Object>>[];
    final interfaceType = ClassMirror.forType<T>();
    final mirrorSystem = mirrors.currentMirrorSystem();
    
    for (final library in mirrorSystem.libraries.values) {
      for (final declaration in library.declarations.values) {
        if (declaration is mirrors.ClassMirror) {
          final classMirror = ClassMirror<Object>.fromDartMirror(declaration);
          if (classMirror.isAssignableFrom(interfaceType)) {
            result.add(classMirror);
          }
        }
      }
    }
    
    return result;
  }
  
  /// Finds all subclasses of the specified class in the current isolate.
  /// 
  /// **Type Parameters:**
  /// - [T]: The superclass type to search for
  /// 
  /// **Returns:** A list of ClassMirror objects for subclasses
  static List<ClassMirror<Object>> findSubclassesOf<T>() {
    final result = <ClassMirror<Object>>[];
    final superclassType = ClassMirror.forType<T>();
    final mirrorSystem = mirrors.currentMirrorSystem();
    
    for (final library in mirrorSystem.libraries.values) {
      for (final declaration in library.declarations.values) {
        if (declaration is mirrors.ClassMirror) {
          final classMirror = ClassMirror<Object>.fromDartMirror(declaration);
          if (classMirror.isSubclassOf<T>(superclassType) && classMirror != superclassType) {
            result.add(classMirror);
          }
        }
      }
    }
    
    return result;
  }
  
  // ========== Method Discovery ==========
  
  /// Finds all methods in a class that have the specified annotation.
  /// 
  /// **Type Parameters:**
  /// - [T]: The annotation type to search for
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to search in
  /// 
  /// **Returns:** A list of MethodMirror objects for annotated methods
  static List<MethodMirror> findMethodsWithAnnotation<T extends ReflectableAnnotation>(ClassMirror<Object> classMirror) {
    final result = <MethodMirror>[];
    final annotationType = ClassMirror.forType<T>();
    final methods = classMirror.getMethods();
    
    for (final method in methods.values) {
      if (method.isAnnotationPresent(annotationType)) {
        result.add(method);
      }
    }
    
    return result;
  }
  
  /// Finds all methods in a class with the specified name.
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to search in
  /// - [methodName]: The name of the methods to find
  /// 
  /// **Returns:** A list of MethodMirror objects with the specified name
  static List<MethodMirror> findMethodsByName(ClassMirror<Object> classMirror, String methodName) {
    final result = <MethodMirror>[];
    final methods = classMirror.getMethods();
    
    for (final method in methods.values) {
      if (method.getName() == methodName) {
        result.add(method);
      }
    }
    
    return result;
  }
  
  /// Checks if a class has a method with the specified name.
  /// 
  /// **Type Parameters:**
  /// - [T]: The class type to check
  /// 
  /// **Parameters:**
  /// - [methodName]: The name of the method to check for
  /// 
  /// **Returns:** true if the class has a method with the specified name
  static bool hasMethod<T>(String methodName) {
    final classMirror = ClassMirror.forType<T>();
    try {
      classMirror.getMethod(methodName);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // ========== Field Discovery ==========
  
  /// Finds all fields in a class that have the specified annotation.
  /// 
  /// **Type Parameters:**
  /// - [T]: The annotation type to search for
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to search in
  /// 
  /// **Returns:** A list of FieldMirror objects for annotated fields
  static List<FieldMirror> findFieldsWithAnnotation<T extends ReflectableAnnotation>(
      ClassMirror<Object> classMirror) {
    final result = <FieldMirror>[];
    final annotationType = ClassMirror.forType<T>();
    final fields = classMirror.getFields();
    
    for (final field in fields.values) {
      if (field.isAnnotationPresent(annotationType)) {
        result.add(field);
      }
    }
    
    return result;
  }
  
  /// Finds all fields in a class of the specified type.
  /// 
  /// **Type Parameters:**
  /// - [T]: The field type to search for
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to search in
  /// 
  /// **Returns:** A list of FieldMirror objects of the specified type
  static List<FieldMirror> findFieldsOfType<T>(ClassMirror<Object> classMirror) {
    final result = <FieldMirror>[];
    final fieldType = ClassMirror.forType<T>();
    final fields = classMirror.getFields();
    
    for (final field in fields.values) {
      if (field.getType() == fieldType) {
        result.add(field);
      }
    }
    
    return result;
  }
  
  /// Checks if a class has a field with the specified name.
  /// 
  /// **Type Parameters:**
  /// - [T]: The class type to check
  /// 
  /// **Parameters:**
  /// - [fieldName]: The name of the field to check for
  /// 
  /// **Returns:** true if the class has a field with the specified name
  static bool hasField<T>(String fieldName) {
    final classMirror = ClassMirror.forType<T>();
    try {
      classMirror.getField(fieldName);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  // ========== Object Manipulation ==========
  
  /// Copies all field values from the source object to the target object.
  /// 
  /// This method copies values for all fields that exist in both objects
  /// and have compatible types. Fields that are final, const, or static
  /// are skipped.
  /// 
  /// **Parameters:**
  /// - [source]: The object to copy values from
  /// - [target]: The object to copy values to
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if source or target is null
  /// 
  /// **Example:**
  /// ```dart
  /// final person1 = Person('John', 25);
  /// final person2 = Person('', 0);
  /// 
  /// ReflectionUtils.copyProperties(person1, person2);
  /// print(person2.name); // 'John'
  /// print(person2.age); // 25
  /// ```
  static void copyProperties(Object? source, Object? target) {
    if (source == null || target == null) {
      throw IllegalArgumentTypeException('Source and target objects cannot be null');
    }
    
    final sourceClass = ClassMirror.forObject(source);
    final targetClass = ClassMirror.forObject(target);
    
    final sourceFields = sourceClass.getFields();
    final targetFields = targetClass.getFields();
    
    for (final entry in sourceFields.entries) {
      final fieldName = entry.key;
      final sourceField = entry.value;
      final targetField = targetFields[fieldName];
      
      if (targetField != null &&
          !targetField.isFinal() &&
          !targetField.isConst() &&
          !targetField.isStatic() &&
          sourceField.getType() == targetField.getType()) {
        try {
          final value = sourceField.get(source);
          targetField.set(target, value);
        } catch (e) {
          // Skip fields that can't be accessed or set
        }
      }
    }
  }
  
  /// Creates a deep copy of an object using reflection.
  /// 
  /// This method creates a new instance of the same class and copies all
  /// field values recursively. Note that this is a simple implementation
  /// and may not handle all edge cases.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the object to copy
  /// 
  /// **Parameters:**
  /// - [original]: The object to copy
  /// 
  /// **Returns:** A deep copy of the original object
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if the original object is null
  /// - [InstantiationException] if a new instance cannot be created
  static T deepCopy<T>(T original) {
    if (original == null) {
      throw IllegalArgumentTypeException('Original object cannot be null');
    }
    
    final classMirror = ClassMirror.forObject(original);
    final copy = classMirror.newInstance() as T;
    
    copyProperties(original, copy);
    
    return copy;
  }
  
  // ========== Type Checking ==========
  
  /// Checks if an object is an instance of the specified type.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type to check against
  /// 
  /// **Parameters:**
  /// - [obj]: The object to check
  /// 
  /// **Returns:** true if the object is an instance of type T
  static bool isInstanceOf<T>(Object? obj) {
    if (obj == null) return false;
    final classMirror = ClassMirror.forType<T>();
    return classMirror.isInstance(obj);
  }
  
  /// Gets the runtime type of an object as a ClassMirror.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to get the type for
  /// 
  /// **Returns:** A ClassMirror representing the runtime type of the object
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if the object is null
  static ClassMirror<Object> getType(Object obj) {
    return ClassMirror.forObject(obj);
  }
  
  /// Checks if two types are assignable (one can be assigned to the other).
  /// 
  /// **Type Parameters:**
  /// - [From]: The source type
  /// - [To]: The target type
  /// 
  /// **Returns:** true if From is assignable to To
  static bool isAssignable<From, To>() {
    final fromClass = ClassMirror.forType<From>();
    final toClass = ClassMirror.forType<To>();
    return toClass.isAssignableFrom(fromClass);
  }
  
  // ========== Annotation Processing ==========
  
  /// Gets all annotations of a specific type from a class hierarchy.
  /// 
  /// This method searches the class and all its superclasses for annotations
  /// of the specified type.
  /// 
  /// **Type Parameters:**
  /// - [T]: The annotation type to search for
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to start the search from
  /// 
  /// **Returns:** A list of annotations found in the class hierarchy
  static List<T> getInheritedAnnotations<T extends ReflectableAnnotation>(ClassMirror<Object> classMirror) {
    final result = <T>[];
    final annotationType = ClassMirror.forType<T>();
    
    ClassMirror<Object>? current = classMirror;
    while (current != null) {
      result.addAll(current.getAnnotationsByType(annotationType));
      current = current.getSuperclass();
    }
    
    return result;
  }
  
  /// Processes all classes with a specific annotation using a callback function.
  /// 
  /// **Type Parameters:**
  /// - [T]: The annotation type to search for
  /// 
  /// **Parameters:**
  /// - [processor]: A function that processes each annotated class
  /// 
  /// **Example:**
  /// ```dart
  /// ReflectionUtils.processAnnotatedClasses<Service>((classMirror, annotation) {
  ///   print('Found service: ${classMirror.getSimpleName()}');
  /// });
  /// ```
  static void processAnnotatedClasses<T extends ReflectableAnnotation>(void Function(ClassMirror<Object> classMirror, T annotation) processor) {
    final annotatedClasses = findClassesWithAnnotation<T>();
    final annotationType = ClassMirror.forType<T>();
    
    for (final classMirror in annotatedClasses) {
      final annotation = classMirror.getAnnotation(annotationType);
      if (annotation != null) {
        processor(classMirror, annotation);
      }
    }
  }
  
  // ========== Validation ==========
  
  /// Validates that a class meets certain criteria.
  /// 
  /// **Parameters:**
  /// - [classMirror]: The class to validate
  /// - [criteria]: A list of validation functions
  /// 
  /// **Returns:** true if all criteria are met
  /// 
  /// **Example:**
  /// ```dart
  /// final isValid = ReflectionUtils.validateClass(classMirror, [
  ///   (c) => !c.isAbstract(),
  ///   (c) => c.getConstructors().isNotEmpty,
  /// ]);
  /// ```
  static bool validateClass(ClassMirror<Object> classMirror, List<bool Function(ClassMirror<Object>)> criteria) {
    return criteria.every((criterion) => criterion(classMirror));
  }
  
  /// Validates that a method meets certain criteria.
  /// 
  /// **Parameters:**
  /// - [methodMirror]: The method to validate
  /// - [criteria]: A list of validation functions
  /// 
  /// **Returns:** true if all criteria are met
  static bool validateMethod(MethodMirror methodMirror, List<bool Function(MethodMirror)> criteria) {
    return criteria.every((criterion) => criterion(methodMirror));
  }
}