import '../mirrors/class_mirror.dart';

/// Member is an interface that reflects identifying information about
/// a single member (a field or a method) or a constructor.
/// 
/// This interface provides basic information about any class member,
/// similar to Java's Member interface.
abstract interface class Member {
  /// Identifies the set of all public members of a class or interface,
  /// including those declared by the class or interface and those
  /// inherited from superclasses and superinterfaces.
  static const int PUBLIC = 0;
  
  /// Identifies the set of declared members of a class or interface.
  /// Declared members include public, protected, default (package) access,
  /// and private members, but excludes inherited members.
  static const int DECLARED = 1;
  
  /// Returns the Class object representing the class or interface that
  /// declares the member or constructor represented by this Member.
  /// 
  /// **Returns:** An object representing the declaring class of the underlying member
  ClassMirror<Object> getDeclaringClass();
  
  /// Returns the simple name of the underlying member or constructor.
  /// 
  /// **Returns:** The simple name of the underlying member
  String getName();
  
  /// Returns the modifier flags for the member or constructor represented by this Member.
  /// 
  /// **Returns:** The modifier flags for the underlying member
  int getModifiers();
  
  /// Returns true if this member was introduced by the compiler; returns false otherwise.
  /// 
  /// **Returns:** true if and only if this member was introduced by the compiler
  bool isSynthetic();
}
