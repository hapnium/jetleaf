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

import 'annotated_element.dart';

/// The AccessibleObject class is the base class for Field, Method, and Constructor objects.
/// 
/// It provides the ability to flag a reflected object as suppressing default
/// access control checks when it is used. This is similar to Java's
/// AccessibleObject but adapted for Dart's access control system.
/// 
/// The ability to access private members is controlled by Dart's mirror system
/// and the accessibility of the mirror itself.
abstract class AccessibleObject extends AnnotatedElement {
  /// The accessible flag for this object
  bool _accessible = false;
  
  /// Get the value of the accessible flag for this object.
  /// 
  /// **Returns:** The value of the object's accessible flag
  bool get isAccessible => _accessible;
  
  /// Set the accessible flag for this object to the indicated boolean value.
  /// 
  /// A value of true indicates that the reflected object should suppress
  /// access control checks when it is used. A value of false indicates
  /// that the reflected object should enforce access control checks.
  /// 
  /// **Parameters:**
  /// - [flag]: The new value for the accessible flag
  /// 
  /// **Throws:**
  /// - [SecurityError] if access cannot be enabled for security reasons
  void setAccessible(bool flag) {
    _accessible = flag;
  }
  
  /// Convenience method to set the accessible flag for an array of objects
  /// with a single security check (for efficiency).
  /// 
  /// **Parameters:**
  /// - [array]: The array of AccessibleObjects
  /// - [flag]: The new value for the accessible flag in each object
  /// 
  /// **Throws:**
  /// - [SecurityError] if access cannot be enabled for security reasons
  static void setAccessibleAll(List<AccessibleObject> array, bool flag) {
    for (final obj in array) {
      obj.setAccessible(flag);
    }
  }
  
  /// Checks if this accessible object can be accessed with the current permissions.
  /// 
  /// **Returns:** true if this object can be accessed, false otherwise
  bool canAccess() {
    return _accessible || !isPrivateAccess();
  }
  
  /// Determines if this accessible object represents a private member.
  /// 
  /// **Returns:** true if this object represents a private member
  bool isPrivateAccess();
}