import 'dart:mirrors' as mirrors;

import '../exceptions.dart';
import '../interfaces/accessible_object.dart';
import '../interfaces/member.dart';
import '../interfaces/reflectable_annotation.dart';
import 'class_mirror.dart';

/// A mirror on a field, providing comprehensive reflection capabilities for fields.
/// 
/// FieldMirror represents a single field on a class or interface and provides
/// access to information about the field including its type, annotations,
/// and the ability to get and set field values.
/// 
/// This class provides type-safe field reflection similar to Java's Field class
/// but adapted for Dart's type system and property access patterns.
/// 
/// **Example:**
/// ```dart
/// class Person {
///   @JsonProperty('full_name')
///   String name;
///   
///   static int count = 0;
///   
///   Person(this.name);
/// }
/// 
/// final personClass = ClassMirror.forType<Person>();
/// final nameField = personClass.getField('name');
/// 
/// print(nameField.getName()); // 'name'
/// print(nameField.getType().getSimpleName()); // 'String'
/// print(nameField.isStatic()); // false
/// 
/// final person = Person('John');
/// nameField.set(person, 'Jane');
/// print(nameField.get(person)); // 'Jane'
/// ```
class FieldMirror extends AccessibleObject implements Member {
  /// The underlying Dart VariableMirror from dart:mirrors
  final mirrors.VariableMirror _mirror;
  
  /// Cache for annotations to improve performance
  List<ReflectableAnnotation>? _annotationCache;
  
  /// Creates a FieldMirror from a dart:mirrors VariableMirror.
  /// 
  /// **Parameters:**
  /// - [mirror]: The underlying VariableMirror from dart:mirrors
  FieldMirror._(this._mirror);
  
  /// Creates a FieldMirror from a dart:mirrors VariableMirror.
  /// 
  /// This is the primary factory method for creating FieldMirror instances
  /// from the underlying Dart mirror system.
  /// 
  /// **Parameters:**
  /// - [mirror]: The dart:mirrors VariableMirror to wrap
  /// 
  /// **Returns:** A new FieldMirror instance
  /// 
  /// **Throws:**
  /// - [InvalidArgumentException] if the mirror is null or invalid
  static FieldMirror fromDartMirror(mirrors.VariableMirror mirror) {
    return FieldMirror._(mirror);
  }
  
  // ========== Basic Field Information ==========
  
  @override
  String getName() {
    return mirrors.MirrorSystem.getName(_mirror.simpleName);
  }
  
  /// Returns the simple name of the field.
  /// 
  /// **Returns:** The simple name of the field
  String getSimpleName() => getName();
  
  /// Returns the qualified name of the field.
  /// 
  /// The qualified name includes the declaring class name.
  /// 
  /// **Returns:** The qualified name of the field
  String getQualifiedName() {
    return mirrors.MirrorSystem.getName(_mirror.qualifiedName);
  }
  
  @override
  ClassMirror<Object> getDeclaringClass() {
    final owner = _mirror.owner;
    if (owner is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(owner);
    }
    throw ClassInstantiationException(owner?.simpleName.toString() ?? '');
  }
  
  /// Returns a ClassMirror that identifies the declared type for the field.
  /// 
  /// **Returns:** A ClassMirror representing the declared type of the field
  ClassMirror<Object> getType() {
    final type = _mirror.type;
    if (type is mirrors.ClassMirror) {
      return ClassMirror<Object>.fromDartMirror(type);
    }
    throw ClassInstantiationException(type.simpleName.toString());
  }
  
  /// Returns a ClassMirror that represents the declared type for the field.
  /// 
  /// This method returns the same as [getType] for compatibility with Java's API.
  /// 
  /// **Returns:** A ClassMirror representing the generic type of the field
  ClassMirror<Object> getGenericType() => getType();
  
  @override
  int getModifiers() {
    int modifiers = 0;
    if (isStatic()) modifiers |= 0x0008; // STATIC
    if (isFinal()) modifiers |= 0x0010; // FINAL
    if (_mirror.isPrivate) modifiers |= 0x0002; // PRIVATE
    return modifiers;
  }
  
  // ========== Field Type Checks ==========
  
  /// Returns true if this field is static.
  /// 
  /// **Returns:** true if this field is static, false otherwise
  bool isStatic() => _mirror.isStatic;
  
  /// Returns true if this field is final.
  /// 
  /// **Returns:** true if this field is final, false otherwise
  bool isFinal() => _mirror.isFinal;
  
  /// Returns true if this field is const.
  /// 
  /// **Returns:** true if this field is const, false otherwise
  bool isConst() => _mirror.isConst;
  
  @override
  bool isSynthetic() {
    // In Dart, fields are generally not synthetic unless they're compiler-generated
    return false;
  }
  
  /// Returns true if this field is private.
  /// 
  /// In Dart, a field is private if its name starts with an underscore.
  /// 
  /// **Returns:** true if this field is private, false otherwise
  bool isPrivate() => _mirror.isPrivate;
  
  @override
  bool isPrivateAccess() => isPrivate();
  
  /// Returns true if this field represents an enum constant.
  /// 
  /// **Returns:** true if this field is an enum constant, false otherwise
  bool isEnumConstant() {
    final declaringClass = getDeclaringClass();
    return declaringClass.isEnum() && isStatic() && isFinal();
  }
  
  // ========== Annotation Methods ==========
  
  @override
  bool isAnnotationPresent<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotation(annotationType) != null;
  }
  
  @override
  T? getAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    final annotations = getAnnotations();
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        return annotation as T;
      }
    }
    return null;
  }
  
  @override
  List<ReflectableAnnotation> getAnnotations() {
    if (_annotationCache != null) {
      return List.unmodifiable(_annotationCache!);
    }
    
    final annotations = <ReflectableAnnotation>[];
    for (final instanceMirror in _mirror.metadata) {
      if (instanceMirror.hasReflectee) {
        final reflectee = instanceMirror.reflectee;
        if (reflectee is ReflectableAnnotation) {
          annotations.add(reflectee);
        }
      }
    }
    
    _annotationCache = annotations;
    return List.unmodifiable(annotations);
  }
  
  @override
  List<T> getAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    final annotations = getAnnotations();
    final result = <T>[];
    
    for (final annotation in annotations) {
      if (annotation.runtimeType == annotationType.getType()) {
        result.add(annotation as T);
      }
    }
    
    return result;
  }
  
  @override
  List<ReflectableAnnotation> getDeclaredAnnotations() {
    return getAnnotations();
  }
  
  @override
  List<T> getDeclaredAnnotationsByType<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotationsByType(annotationType);
  }
  
  @override
  T? getDeclaredAnnotation<T extends ReflectableAnnotation>(ClassMirror<T> annotationType) {
    return getAnnotation(annotationType);
  }
  
  // ========== Field Access ==========
  
  /// Returns the value of the field represented by this FieldMirror on the specified object.
  /// 
  /// The value is automatically wrapped in an object if it has a primitive type.
  /// 
  /// **Parameters:**
  /// - [obj]: Object from which the represented field's value is to be extracted
  /// 
  /// **Returns:** The value of the represented field in object obj
  /// 
  /// **Throws:**
  /// - [IllegalTypeAccessException] if this Field object is enforcing access control
  /// - [IllegalArgumentTypeException] if the specified object is not an instance of
  ///   the class or interface declaring the underlying field
  Object? get(Object? obj) {
    if (!canAccess()) {
      throw IllegalTypeAccessException(getName());
    }
    
    try {
      if (isStatic()) {
        // For static fields, get from the class
        final classMirror = _mirror.owner as mirrors.ClassMirror;
        final result = classMirror.getField(_mirror.simpleName);
        return result.reflectee;
      } else {
        // For instance fields, get from the object
        if (obj == null) {
          throw IllegalArgumentTypeException('Cannot get instance field from null object');
        }
        
        final instanceMirror = mirrors.reflect(obj);
        final result = instanceMirror.getField(_mirror.simpleName);
        return result.reflectee;
      }
    } catch (e) {
      if (e is NoSuchMethodError) {
        throw NoSuchFieldException(getName(), getDeclaringClass().getSimpleName());
      }
      rethrow;
    }
  }
  
  /// Sets the field represented by this FieldMirror on the specified object
  /// argument to the specified new value.
  /// 
  /// **Parameters:**
  /// - [obj]: The object whose field should be modified
  /// - [value]: The new value for the field of obj being modified
  /// 
  /// **Throws:**
  /// - [IllegalTypeAccessException] if this Field object is enforcing access control
  /// - [IllegalArgumentTypeException] if the specified object is not an instance of
  ///   the class or interface declaring the underlying field, or if an unwrapping
  ///   conversion fails
  void set(Object? obj, Object? value) {
    if (!canAccess()) {
      throw IllegalTypeAccessException(getName());
    }
    
    if (isFinal() || isConst()) {
      throw IllegalTypeAccessException('Cannot modify final field ${getName()}');
    }
    
    try {
      if (isStatic()) {
        // For static fields, set on the class
        final classMirror = _mirror.owner as mirrors.ClassMirror;
        classMirror.setField(_mirror.simpleName, value);
      } else {
        // For instance fields, set on the object
        if (obj == null) {
          throw IllegalArgumentTypeException('Cannot set instance field on null object');
        }
        
        final instanceMirror = mirrors.reflect(obj);
        instanceMirror.setField(_mirror.simpleName, value);
      }
    } catch (e) {
      if (e is NoSuchMethodError) {
        throw NoSuchFieldException(getName(), getDeclaringClass().getSimpleName());
      }
      if (e is TypeError) {
        throw IllegalArgumentTypeException('Cannot assign value of type ${value.runtimeType} to field ${getName()} of type ${getType().getSimpleName()}');
      }
      rethrow;
    }
  }
  
  /// Gets the value of a static field.
  /// 
  /// This is a convenience method for getting static field values without
  /// needing to pass null as the object parameter.
  /// 
  /// **Returns:** The value of the static field
  /// 
  /// **Throws:**
  /// - [IllegalStateException] if this field is not static
  /// - [IllegalTypeAccessException] if this Field object is enforcing access control
  Object? getStatic() {
    if (!isStatic()) {
      throw IllegalArgumentTypeException('Field ${getName()} is not static');
    }
    
    return get(null);
  }
  
  /// Sets the value of a static field.
  /// 
  /// This is a convenience method for setting static field values without
  /// needing to pass null as the object parameter.
  /// 
  /// **Parameters:**
  /// - [value]: The new value for the static field
  /// 
  /// **Throws:**
  /// - [IllegalStateException] if this field is not static
  /// - [IllegalTypeAccessException] if this Field object is enforcing access control
  void setStatic(Object? value) {
    if (!isStatic()) {
      throw IllegalArgumentTypeException('Field ${getName()} is not static');
    }
    
    set(null, value);
  }
  
  // ========== Type-Safe Getters and Setters ==========
  
  /// Gets the value of the field as a boolean.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to extract the boolean value from
  /// 
  /// **Returns:** The value of the field as a boolean
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if the field is not of type boolean
  bool getBoolean(Object? obj) {
    final value = get(obj);
    if (value is bool) {
      return value;
    }
    throw IllegalArgumentTypeException('Field ${getName()} is not of type bool');
  }
  
  /// Sets the value of the field as a boolean.
  /// 
  /// **Parameters:**
  /// - [obj]: The object whose field should be modified
  /// - [value]: The new boolean value
  void setBoolean(Object? obj, bool value) {
    set(obj, value);
  }
  
  /// Gets the value of the field as an int.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to extract the int value from
  /// 
  /// **Returns:** The value of the field as an int
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if the field is not of type int
  int getInt(Object? obj) {
    final value = get(obj);
    if (value is int) {
      return value;
    }
    throw IllegalArgumentTypeException('Field ${getName()} is not of type int');
  }
  
  /// Sets the value of the field as an int.
  /// 
  /// **Parameters:**
  /// - [obj]: The object whose field should be modified
  /// - [value]: The new int value
  void setInt(Object? obj, int value) {
    set(obj, value);
  }
  
  /// Gets the value of the field as a double.
  /// 
  /// **Parameters:**
  /// - [obj]: The object to extract the double value from
  /// 
  /// **Returns:** The value of the field as a double
  /// 
  /// **Throws:**
  /// - [IllegalArgumentTypeException] if the field is not of type double
  double getDouble(Object? obj) {
    final value = get(obj);
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    throw IllegalArgumentTypeException('Field ${getName()} is not of numeric type');
  }
  
  /// Sets the value of the field as a double.
  /// 
  /// **Parameters:**
  /// - [obj]: The object whose field should be modified
  /// - [value]: The new double value
  void setDouble(Object? obj, double value) {
    set(obj, value);
  }
  
  /// Returns the underlying dart:mirrors VariableMirror.
  /// 
  /// This method provides access to the underlying Dart mirror for advanced
  /// use cases that require direct access to dart:mirrors functionality.
  /// 
  /// **Returns:** The underlying VariableMirror
  mirrors.VariableMirror get dartMirror => _mirror;
  
  // ========== Object Methods ==========
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FieldMirror && other._mirror == _mirror;
  }
  
  @override
  int get hashCode => _mirror.hashCode;
  
  @override
  String toString() => 'FieldMirror(${getName()})';
}