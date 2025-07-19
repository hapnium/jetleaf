/// ---------------------------------------------------------------------------
/// 🍃 JetLeaf Framework - https://jetleaf.hapnium.com
///
/// Copyright © 2025 Hapnium & JetLeaf Contributors. All rights reserved.
///
/// This source file is part of the JetLeaf Framework and is protected
/// under copyright law. You may not copy, modify, or distribute this file
/// except in compliance with the JetLeaf license.
///
/// For licensing terms, see the LICENSE file in the root of this project.
/// ---------------------------------------------------------------------------
/// 
/// 🔧 Powered by Hapnium — the Dart backend engine 🍃

/// {@template reflectable_annotation}
/// Base class for all reflectable annotations.
/// 
/// This class serves as the base for all annotations that can be discovered
/// and processed through the reflection system. It provides the basic
/// contract that all reflectable annotations must implement.
/// 
/// Unlike Dart's built-in Annotation class, this class is designed specifically
/// for use with the reflection framework and provides additional metadata
/// and processing capabilities.
/// 
/// {@endtemplate}
abstract class ReflectableAnnotation {
  /// {@macro reflectable_annotation}
  const ReflectableAnnotation();
  
  /// Returns the annotation type of this annotation.
  /// 
  /// This method returns the runtime type of the annotation, which can be
  /// used for type checking and filtering operations.
  /// 
  /// **Returns:** The Class object representing the annotation type
  Type get annotationType;
  
  /// Checks if this annotation is equal to another object.
  /// 
  /// Two annotations are considered equal if they are of the same type
  /// and all their properties have equal values.
  /// 
  /// **Parameters:**
  /// - [other]: The object to compare with this annotation
  /// 
  /// **Returns:** true if the objects are equal, false otherwise
  @override
  bool operator ==(Object other);
  
  /// Returns the hash code for this annotation.
  /// 
  /// The hash code is computed based on the annotation type and all
  /// property values to ensure consistency with equality.
  /// 
  /// **Returns:** The hash code for this annotation
  @override
  int get hashCode;
  
  /// Returns a string representation of this annotation.
  /// 
  /// The string representation includes the annotation type and all
  /// property values in a readable format.
  /// 
  /// **Returns:** A string representation of this annotation
  @override
  String toString();
}