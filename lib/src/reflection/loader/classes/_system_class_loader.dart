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

part of '../class_loader.dart';

/// System class loader implementation
class SystemClassLoader extends ClassLoader {
  SystemClassLoader._() : super._system();
  
  @override
  Class<T> findClass<T>(String name) {
    // Handle different URI schemes
    if (name.startsWith('dart:')) {
      return _findDartClass<T>(name);
    } else if (name.startsWith('package:')) {
      return _findPackageClass<T>(name);
    } else {
      return _findClassBySimpleName<T>(name);
    }
  }
  
  /// Finds a class from dart: libraries
  Class<T> _findDartClass<T>(String dartUri) {
    final clazz = _findBootstrapClassOrNull<T>(dartUri);
    if (clazz != null) {
      _recordClassAsLoaded(dartUri, clazz);
      return clazz;
    }
    throw ClassNotFoundException(dartUri);
  }
  
  /// Finds a class from package: URI
  Class<T> _findPackageClass<T>(String packageUri) {
    try {
      final uri = Uri.parse(packageUri);
      final packageName = uri.pathSegments.first;
      final className = uri.pathSegments.last.replaceAll('.dart', '');
      
      // Try to find the class using reflection
      final mirrorSystem = mirrors.currentMirrorSystem();
      
      for (final library in mirrorSystem.libraries.values) {
        if (library.uri.scheme == 'package' && 
            library.uri.pathSegments.first == packageName) {
          
          for (final declaration in library.declarations.values) {
            if (declaration is mirrors.ClassMirror) {
              final declClassName = mirrors.MirrorSystem.getName(declaration.simpleName);
              if (declClassName == className) {
                final clazz = Class<T>.fromDartMirror(declaration);
                _recordClassAsLoaded(packageUri, clazz);
                return clazz;
              }
            }
          }
        }
      }
      
      throw ClassNotFoundException(packageUri);
    } catch (e) {
      throw ClassNotFoundException(packageUri);
    }
  }
  
  /// Finds a class by simple name using reflection
  Class<T> _findClassBySimpleName<T>(String name) {
    try {
      final mirrorSystem = mirrors.currentMirrorSystem();
      
      for (final library in mirrorSystem.libraries.values) {
        for (final declaration in library.declarations.values) {
          if (declaration is mirrors.ClassMirror) {
            final className = mirrors.MirrorSystem.getName(declaration.simpleName);
            final qualifiedName = mirrors.MirrorSystem.getName(declaration.qualifiedName);
            
            if (className == name || qualifiedName == name || qualifiedName.endsWith('.$name')) {
              final clazz = Class<T>.fromDartMirror(declaration);
              _recordClassAsLoaded(name, clazz);
              return clazz;
            }
          }
        }
      }
      
      throw ClassNotFoundException(name);
    } catch (e) {
      throw ClassNotFoundException(name);
    }
  }
  
  @override
  Future<Uri?> findResource(String name) async {
    // System class loader can find resources from dart: and package: schemes
    if (name.startsWith('dart:') || name.startsWith('package:')) {
      try {
        final uri = Uri.parse(name);
        // Verify the resource exists
        if (uri.scheme == 'dart') {
          // Check if dart library exists
          final mirrorSystem = mirrors.currentMirrorSystem();
          final library = mirrorSystem.libraries[uri];
          return library != null ? uri : null;
        } else if (uri.scheme == 'package') {
          // For package resources, we'd need to check the file system
          // This is a simplified implementation
          return uri;
        }
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }
}