import '../mirrors/class_mirror.dart';
import 'reflectable_annotation.dart';

/// Represents an annotated construct in a program, such as a class, method, or field.
/// 
/// This interface provides methods to access metadata (annotations) associated
/// with program elements. It's designed to be similar to Java's AnnotatedElement
/// interface but adapted for Dart's annotation system.
/// 
/// All annotations returned by methods in this interface are immutable and
/// represent the actual annotation instances found on the program element.
abstract class AnnotatedElement {
  /// Returns true if an annotation of the specified type is present on this element.
  /// 
  /// This method is equivalent to `getAnnotation<T>() != null`.
  /// 
  /// **Parameters:**
  /// - [annotationType]: The Class object corresponding to the annotation type
  /// 
  /// **Returns:** true if an annotation of the specified type is present, false otherwise
  /// 
  /// **Example:**
  /// ```dart
  /// @Entity('users')
  /// class User {}
  /// 
  /// final userClass = ClassMirror.forType<User>();
  /// final hasEntity = userClass.isAnnotationPresent(ClassMirror.forType<Entity>());
  /// print(hasEntity); // true
  /// ```
  bool isAnnotationPresent<T extends ReflectableAnnotation>(ClassMirror<T> annotationType);

  /// Returns true if an annotation of the specified type is present on this element.
  /// 
  /// This method is equivalent to `getAnnotation<T>() != null`.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the annotation to query for
  /// 
  /// **Returns:** true if an annotation of the specified type is present, false otherwise
  /// 
  /// **Example:**
  /// ```dart
  /// @Entity('users')
  /// class User {}
  /// 
  /// final userClass = ClassMirror.forType<User>();
  /// final hasEntity = userClass.hasAnnotation<Entity>();
  /// print(hasEntity); // true
  /// ```
  bool hasAnnotation<T extends ReflectableAnnotation>() {
    return getAnnotation<T>(ClassMirror.forType<T>()) != null;
  }
  
  /// Returns this element's annotation for the specified type if present, null otherwise.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the annotation to query for and return if present
  /// 
  /// **Parameters:**
  /// - [annotationType]: The Class object corresponding to the annotation type
  /// 
  /// **Returns:** This element's annotation for the specified annotation type if
  /// present on this element, else null
  /// 
  /// **Throws:**
  /// - [InvalidArgumentException] if the given annotation type is null
  /// 
  /// **Example:**
  /// ```dart
  /// @Entity('users')
  /// class User {}
  /// 
  /// final userClass = ClassMirror.forType<User>();
  /// final entity = userClass.getAnnotation<Entity>(ClassMirror.forType<Entity>());
  /// print(entity?.tableName); // 'users'
  /// ```
  T? getAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType);
  
  /// Returns annotations that are present on this element.
  /// 
  /// If there are no annotations present on this element, the return value is
  /// an empty list. The caller of this method is free to modify the returned
  /// list; it will have no effect on the lists returned to other callers.
  /// 
  /// **Returns:** All annotations present on this element
  /// 
  /// **Example:**
  /// ```dart
  /// @Entity('users')
  /// @Deprecated('Use UserV2 instead')
  /// class User {}
  /// 
  /// final userClass = ClassMirror.forType<User>();
  /// final annotations = userClass.getAnnotations();
  /// print(annotations.length); // 2
  /// ```
  List<ReflectableAnnotation> getAnnotations();
  
  /// Returns annotations that are associated with this element.
  /// 
  /// If there are no annotations associated with this element, the return
  /// value is an empty list. The difference between this method and
  /// [getAnnotation] is that this method detects if its argument is a
  /// repeatable annotation type, and if so, attempts to find one or more
  /// annotations of that type by "looking through" a container annotation.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the annotation to query for and return if present
  /// 
  /// **Parameters:**
  /// - [annotationType]: The Class object corresponding to the annotation type
  /// 
  /// **Returns:** All this element's annotations for the specified annotation type
  /// 
  /// **Example:**
  /// ```dart
  /// @Repeatable()
  /// class Tag {
  ///   final String value;
  ///   const Tag(this.value);
  /// }
  /// 
  /// @Tag('important')
  /// @Tag('user-related')
  /// class User {}
  /// 
  /// final userClass = ClassMirror.forType<User>();
  /// final tags = userClass.getAnnotationsByType<Tag>(ClassMirror.forType<Tag>());
  /// print(tags.length); // 2
  /// ```
  List<T> getAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType);
  
  /// Returns annotations that are directly present on this element.
  /// 
  /// This method ignores inherited annotations. If there are no annotations
  /// directly present on this element, the return value is an empty list.
  /// 
  /// **Returns:** All annotations directly present on this element
  List<ReflectableAnnotation> getDeclaredAnnotations();
  
  /// Returns this element's annotation(s) for the specified type if such
  /// annotations are either directly present or indirectly present.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the annotation to query for and return if present
  /// 
  /// **Parameters:**
  /// - [annotationType]: The Class object corresponding to the annotation type
  /// 
  /// **Returns:** All this element's annotations for the specified annotation type
  List<T> getDeclaredAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType);
  
  /// Returns the annotation directly present on this element for the specified type.
  /// 
  /// **Type Parameters:**
  /// - [T]: The type of the annotation to query for and return if directly present
  /// 
  /// **Parameters:**
  /// - [annotationType]: The Class object corresponding to the annotation type
  /// 
  /// **Returns:** The directly present annotation for the specified annotation type,
  /// null if no such annotation is directly present
  T? getDeclaredAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType);
}