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

import 'dart:mirrors' as mirrors;

import '../../class.dart';
import '../class_loader.dart';
import '../plugins/_hot_reload_plugin.dart';
import '../plugins/class_loader_plugin.dart';

/// JetLeaf-specific class loader with superpowers!
/// 
/// Features:
/// - Smart package scanning with dependency resolution
/// - Automatic component discovery and registration
/// - Hot reload with dependency tracking
/// - Resource bundling and optimization
/// - Plugin architecture for extensibility
/// - Performance monitoring and optimization
/// - Development vs production modes
class JetLeafClassLoader extends ClassLoader {
  final List<String> _basePackages;
  final Map<String, Class<Object>> _componentClasses = {};
  final Map<Type, List<Class<Object>>> _annotatedClasses = {};
  final Map<String, Set<String>> _dependencyGraph = {};
  final Set<String> _hotReloadableClasses = {};
  final List<ClassLoaderPlugin> _plugins = [];
  
  JetLeafClassLoader({
    List<String> basePackages = const [],
    ClassLoader? parent,
  }) : _basePackages = basePackages,
       super.withParent(parent);
  
  @override
  Class<T> findClass<T>(String name) {
    // First try to find in component cache
    final cachedClass = _componentClasses[name];
    if (cachedClass != null) {
      getMetrics().recordCacheHit();
      return cachedClass as Class<T>;
    }
    
    getMetrics().recordCacheMiss();
    
    // Try to find using enhanced reflection
    try {
      final clazz = _findClassUsingEnhancedReflection<T>(name);
      if (clazz != null) {
        _recordClassAsLoaded(name, clazz);
        _analyzeClassDependencies(clazz);
        _analyzeClassAnnotations(clazz);
        return clazz;
      }
    } catch (e) {
      // Continue to parent class loader
    }
    
    // Delegate to parent
    return super.findClass<T>(name);
  }

  /// Records a class as loaded by this class loader
  void _recordClassAsLoaded<T>(String name, Class<T> clazz) {
    _componentClasses[name] = clazz as Class<Object>;
  }
  
  /// Enhanced class finding with smart resolution
  Class<T>? _findClassUsingEnhancedReflection<T>(String name) {
    final mirrorSystem = mirrors.currentMirrorSystem();
    
    // Try exact match first
    for (final library in mirrorSystem.libraries.values) {
      if (_shouldScanLibrary(library)) {
        final clazz = _findClassInLibrary<T>(library, name);
        if (clazz != null) return clazz;
      }
    }
    
    // Try fuzzy matching for development convenience
    if (isDevelopmentMode) {
      return _findClassWithFuzzyMatching<T>(name);
    }
    
    return null;
  }
  
  /// Finds class in a specific library
  Class<T>? _findClassInLibrary<T>(mirrors.LibraryMirror library, String name) {
    for (final declaration in library.declarations.values) {
      if (declaration is mirrors.ClassMirror) {
        final className = mirrors.MirrorSystem.getName(declaration.simpleName);
        final qualifiedName = mirrors.MirrorSystem.getName(declaration.qualifiedName);
        
        if (className == name || qualifiedName == name || qualifiedName.endsWith('.$name')) {
          return Class<T>.fromDartMirror(declaration);
        }
      }
    }
    return null;
  }
  
  /// Fuzzy matching for development mode
  Class<T>? _findClassWithFuzzyMatching<T>(String name) {
    final mirrorSystem = mirrors.currentMirrorSystem();
    final candidates = <String, mirrors.ClassMirror>{};
    
    for (final library in mirrorSystem.libraries.values) {
      if (_shouldScanLibrary(library)) {
        for (final declaration in library.declarations.values) {
          if (declaration is mirrors.ClassMirror) {
            final className = mirrors.MirrorSystem.getName(declaration.simpleName);
            
            // Case-insensitive matching
            if (className.toLowerCase() == name.toLowerCase()) {
              candidates[className] = declaration;
            }
            // Partial matching
            else if (className.toLowerCase().contains(name.toLowerCase())) {
              candidates[className] = declaration;
            }
          }
        }
      }
    }
    
    if (candidates.length == 1) {
      final entry = candidates.entries.first;
      print('🎯 Fuzzy match: $name -> ${entry.key}');
      return Class<T>.fromDartMirror(entry.value);
    } else if (candidates.length > 1) {
      print('🤔 Multiple fuzzy matches for $name: ${candidates.keys.join(', ')}');
    }
    
    return null;
  }
  
  /// Checks if a library should be scanned
  bool _shouldScanLibrary(mirrors.LibraryMirror library) {
    final uri = library.uri.toString();
    
    // Always scan if no base packages specified
    if (_basePackages.isEmpty) return true;
    
    // Check base packages
    for (final basePackage in _basePackages) {
      if (uri.contains(basePackage)) return true;
    }
    
    return false;
  }
  
  /// Analyzes class dependencies for hot reload
  void _analyzeClassDependencies<T>(Class<T> clazz) {
    if (!isDevelopmentMode) return;
    
    final className = clazz.simpleName;
    final dependencies = <String>{};
    
    // Analyze field types
    final fields = clazz.getDeclaredFields();
    for (final field in fields.values) {
      final fieldType = field.clazz.type.toString();
      if (_isUserDefinedClass(fieldType)) {
        dependencies.add(fieldType);
      }
    }
    
    // Analyze method parameter and return types
    final methods = clazz.getDeclaredMethods();
    for (final method in methods.values) {
      // This would require more detailed analysis
      // For now, we'll keep it simple
    }
    
    _dependencyGraph[className] = dependencies;
    
    // Mark as hot reloadable if it has no complex dependencies
    if (dependencies.length <= 3) {
      _hotReloadableClasses.add(className);
    }
  }
  
  /// Checks if a type name represents a user-defined class
  bool _isUserDefinedClass(String typeName) {
    // Simple heuristic: not a built-in Dart type
    final builtInTypes = {
      'String', 'int', 'double', 'bool', 'List', 'Map', 'Set',
      'Object', 'dynamic', 'void', 'Null'
    };
    
    return !builtInTypes.contains(typeName) && !typeName.startsWith('dart:');
  }
  
  /// Analyzes class annotations and caches them
  void _analyzeClassAnnotations<T>(Class<T> clazz) {
    final annotations = clazz.getAnnotations();
    
    for (final annotation in annotations) {
      final annotationType = annotation.runtimeType;
      _annotatedClasses.putIfAbsent(annotationType, () => []).add(clazz as Class<Object>);
    }
  }
  
  /// Scans packages with enhanced discovery
  Future<void> scanPackages() async {
    print('🔍 Enhanced package scanning...');
    
    final mirrorSystem = mirrors.currentMirrorSystem();
    final discoveredClasses = <String, Class<Object>>{};
    
    for (final library in mirrorSystem.libraries.values) {
      if (_shouldScanLibrary(library)) {
        await _scanLibraryEnhanced(library, discoveredClasses);
      }
    }
    
    print('✅ Discovered ${discoveredClasses.length} classes');
    
    // Analyze relationships
    _analyzeClassRelationships(discoveredClasses);
    
    // Optimize for hot reload
    if (isDevelopmentMode) {
      _optimizeForHotReload();
    }
  }
  
  /// Enhanced library scanning
  Future<void> _scanLibraryEnhanced(
    mirrors.LibraryMirror library,
    Map<String, Class<Object>> discoveredClasses,
  ) async {
    for (final declaration in library.declarations.values) {
      if (declaration is mirrors.ClassMirror) {
        try {
          final className = mirrors.MirrorSystem.getName(declaration.simpleName);
          final clazz = Class<Object>.fromDartMirror(declaration);
          
          discoveredClasses[className] = clazz;
          _componentClasses[className] = clazz;
          _analyzeClassAnnotations(clazz);
          _analyzeClassDependencies(clazz);
          
        } catch (e) {
          if (isDevelopmentMode) {
            print('⚠️  Skipped class ${declaration.simpleName}: $e');
          }
        }
      }
    }
  }
  
  /// Analyzes relationships between classes
  void _analyzeClassRelationships(Map<String, Class<Object>> classes) {
    print('🔗 Analyzing class relationships...');
    
    for (final clazz in classes.values) {
      // Analyze inheritance hierarchy
      final superclass = clazz.getSuperclass();
      if (superclass != null) {
        final superName = superclass.simpleName;
        _dependencyGraph.putIfAbsent(clazz.simpleName, () => {}).add(superName);
      }
      
      // Analyze interfaces
      final interfaces = clazz.getSuperinterfaces();
      for (final interface in interfaces) {
        _dependencyGraph.putIfAbsent(clazz.simpleName, () => {}).add(interface.simpleName);
      }
    }
  }
  
  /// Optimizes class loading for hot reload
  void _optimizeForHotReload() {
    print('🔥 Optimizing for hot reload...');
    
    // Identify classes that can be safely reloaded
    for (final className in _componentClasses.keys) {
      final dependencies = _dependencyGraph[className] ?? {};
      
      // Classes with fewer dependencies are easier to reload
      if (dependencies.length <= 2) {
        _hotReloadableClasses.add(className);
      }
    }
    
    print('🔥 ${_hotReloadableClasses.length} classes marked as hot-reloadable');
  }
  
  /// Gets all classes annotated with a specific annotation type
  List<Class<Object>> getClassesAnnotatedWith<A>() {
    return _annotatedClasses[A] ?? [];
  }
  
  /// Gets all classes that are subtypes of a specific type
  List<Class<Object>> getSubTypesOf<T>() {
    final result = <Class<Object>>[];
    
    for (final clazz in _componentClasses.values) {
      if (clazz.isSubTypeOf<T>()) {
        result.add(clazz);
      }
    }
    
    return result;
  }
  
  /// Smart class preloading based on usage patterns
  Future<void> smartPreload() async {
    print('🧠 Smart preloading based on patterns...');
    
    // Preload frequently used classes first
    final metrics = getMetrics();
    final mostUsed = metrics.getMostLoadedClasses(20);
    
    for (final stats in mostUsed) {
      try {
        loadClass(stats.className);
      } catch (e) {
        // Ignore preload failures
      }
    }
    
    // Preload classes with many dependencies
    final classesToPreload = _dependencyGraph.entries
        .where((entry) => entry.value.length > 3)
        .map((entry) => entry.key)
        .take(10);
    
    for (final className in classesToPreload) {
      try {
        loadClass(className);
      } catch (e) {
        // Ignore preload failures
      }
    }
  }
  
  /// Hot reload a specific class and its dependents
  Future<void> hotReloadClass(String className) async {
    if (!isDevelopmentMode) {
      throw UnsupportedError('Hot reload only available in development mode');
    }
    
    if (!_hotReloadableClasses.contains(className)) {
      print('⚠️  Class $className is not marked as hot-reloadable');
      return;
    }
    
    print('🔥 Hot reloading $className...');
    
    // Invalidate the class and its dependents
    _invalidateClassAndDependents(className);
    
    // Reload the class
    try {
      final reloadedClass = loadClass(className);
      print('✅ Successfully reloaded $className');
      
      // Notify plugins
      for (final plugin in _plugins) {
        if (plugin is HotReloadPlugin) {
          plugin.onClassReloaded(className, reloadedClass as Class<Object>);
        }
      }
    } catch (e) {
      print('❌ Failed to reload $className: $e');
    }
  }
  
  /// Invalidates a class and all classes that depend on it
  void _invalidateClassAndDependents(String className) {
    final toInvalidate = <String>{className};
    
    // Find all classes that depend on this class
    for (final entry in _dependencyGraph.entries) {
      if (entry.value.contains(className)) {
        toInvalidate.add(entry.key);
      }
    }
    
    // Invalidate all dependent classes
    for (final classToInvalidate in toInvalidate) {
      _invalidateClass(classToInvalidate);
    }
  }

  /// Invalidates a class for hot reload
  void _invalidateClass(String name) {
    _componentClasses.remove(name);
    _dependencyGraph.remove(name);
    _hotReloadableClasses.remove(name);
  }
  
  /// Gets dependency information
  Map<String, dynamic> getDependencyInfo() {
    return {
      'totalClasses': _componentClasses.length,
      'dependencyGraph': _dependencyGraph,
      'hotReloadableClasses': _hotReloadableClasses.toList(),
      'annotatedTypes': _annotatedClasses.keys.map((t) => t.toString()).toList(),
    };
  }
  
  /// Prints dependency analysis
  void printDependencyAnalysis() {
    print('🔗 Dependency Analysis');
    print('====================');
    print('Total Classes: ${_componentClasses.length}');
    print('Hot Reloadable: ${_hotReloadableClasses.length}');
    print('Annotation Types: ${_annotatedClasses.length}');
    print('');
    
    // Show classes with most dependencies
    final sortedByDeps = _dependencyGraph.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    
    print('Classes with Most Dependencies:');
    for (final entry in sortedByDeps.take(5)) {
      print('  ${entry.key}: ${entry.value.length} dependencies');
    }
  }
  
  @override
  void clearCache() {
    super.clearCache();
    _componentClasses.clear();
    _annotatedClasses.clear();
    _dependencyGraph.clear();
    _hotReloadableClasses.clear();
  }
}