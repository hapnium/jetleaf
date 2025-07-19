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

import 'accessible_object.dart';
import '../mirrors/parameter_mirror.dart';
import '../mirrors/class_mirror.dart';

/// A shared superclass for the common functionality of Method and Constructor.
/// 
/// This abstract class provides common functionality for executable elements
/// (methods and constructors) such as parameter handling, exception types,
/// and invocation capabilities.
abstract class Executable extends AccessibleObject {
  /// Returns the Class object representing the class or interface that
  /// declares the executable represented by this object.
  /// 
  /// **Returns:** An object representing the declaring class of the underlying member
  ClassMirror<Object> getDeclaringClass();
  
  /// Returns the simple name of the underlying executable.
  /// 
  /// **Returns:** The simple name of the underlying executable
  String getName();
  
  /// Returns the modifier flags for the executable represented by this object.
  /// 
  /// **Returns:** The modifier flags for the underlying executable
  int getModifiers();
  
  /// Returns an array of Class objects that represent the types of exceptions
  /// declared to be thrown by the underlying executable.
  /// 
  /// **Returns:** The exception types declared as being thrown by the executable
  List<ClassMirror<Exception>> getExceptionTypes();
  
  /// Returns an array of Parameter objects that represent all the parameters
  /// to the underlying executable.
  /// 
  /// **Returns:** An array of Parameter objects representing all parameters
  List<ParameterMirror> getParameters();
  
  /// Returns the number of formal parameters (whether explicitly declared
  /// or implicitly declared or neither) for the executable.
  /// 
  /// **Returns:** The number of formal parameters for the executable
  int getParameterCount();
  
  /// Returns an array of Class objects that represent the formal parameter
  /// types, in declaration order, of the executable.
  /// 
  /// **Returns:** The parameter types for the executable
  List<ClassMirror<Object>> getParameterTypes();
  
  /// Returns an array of Type objects that represent the formal parameter
  /// types, in declaration order, of the executable.
  /// 
  /// **Returns:** An array of Types that represent the formal parameter types
  List<ClassMirror<Object>> getGenericParameterTypes();
  
  /// Returns true if this executable was declared to take a variable number of arguments.
  /// 
  /// **Returns:** true if this executable was declared to take a variable number of arguments
  bool isVarArgs();
  
  /// Returns true if this executable is a synthetic construct.
  /// 
  /// **Returns:** true if this executable is a synthetic construct
  bool isSynthetic();
  
  /// Returns the name used to create a string representation of this Executable.
  /// 
  /// **Returns:** The name to be used in toString
  String toGenericString();
  
  @override
  bool isPrivateAccess();
}