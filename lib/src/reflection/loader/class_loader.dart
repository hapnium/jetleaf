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

import 'dart:convert' show json;
import 'dart:mirrors' as mirrors;

import 'package:jetleaf/lang.dart';

import '../class.dart';
import '../exceptions.dart';
import '_class_loader_resource.dart';
import '_class_loading_lock.dart';
import 'plugins/class_loader_plugin.dart';
import 'class_loader_resource.dart';
import 'class_loading_lock.dart';
import 'metrics/_class_loader_metrics.dart';
import 'metrics/class_loader_metrics.dart';
import 'models/protection_domain.dart';
import 'models/package_info.dart';
import 'resource_resolver/_resource_resolver.dart';
import 'resource_resolver/resource_resolver.dart';

part 'classes/_system_class_loader.dart';

/// {@template class_loader}
/// Abstract base class for class loaders in the JetLeaf framework.
///
/// A class loader is responsible for loading classes and packages into memory
/// at runtime. This follows Java's `ClassLoader` delegation model:
///
/// - Delegates to a parent class loader first.
/// - If the parent cannot find the class or resource, it attempts to load it itself.
///
/// JetLeaf uses this abstraction to allow flexible loading mechanisms,
/// pluggable classpath scanners, and custom class loading strategies.
///
/// Example usage:
/// ```dart
/// final loader = CustomClassLoader.withParent(ClassLoader.getSystemClassLoader());
/// final clazz = await loader.loadClass('package:example/example.dart');
/// ```
/// {@endtemplate}
abstract class ClassLoader {
  /// {@template class_loader_parent}
  /// The parent class loader used for delegation.
  ///
  /// If this loader cannot find a class, it delegates the lookup
  /// to this parent.
  /// {@endtemplate}
  final ClassLoader? _parent;

  /// {@template class_loader_class_cache}
  /// Internal cache of loaded classes by name.
  ///
  /// Maps fully qualified class names (e.g., `'package:example/example.dart'`) to their `Class` representation.
  /// Used to avoid repeated loads.
  /// {@endtemplate}
  final Map<String, Class<Object>> _classes = HashMap<String, Class<Object>>();

  /// {@template class_loader_package_cache}
  /// Internal cache of loaded packages by name.
  ///
  /// Maps package names to [PackageInfo] for metadata and versioning info.
  /// {@endtemplate}
  final Map<String, PackageInfo> _packages = HashMap<String, PackageInfo>();

  /// {@template class_loader_lock_map}
  /// Internal locks to ensure thread-safe loading of each class.
  ///
  /// Each class name has a corresponding [ClassLoadingLock].
  /// {@endtemplate}
  final Map<String, ClassLoadingLock> _classLoadingLocks = HashMap<String, ClassLoadingLock>();

  /// {@template class_loader_resource_resolver}
  /// Resource resolver for Dart URI schemes
  /// 
  /// This resolver is used to resolve resources from Dart URI schemes.
  /// {@endtemplate}
  final ResourceResolver _resourceResolver = ResourceResolverImpl();
  
  /// {@template class_loader_metrics}
  /// Metrics collector for performance monitoring
  /// 
  /// This collector is used to collect metrics for performance monitoring.
  /// 
  /// {@endtemplate}
  final ClassLoaderMetrics _metrics = ClassLoaderMetricsImpl();
  
  /// {@template class_loader_class_timestamps}
  /// Class timestamps for hot reload support
  /// 
  /// This map stores the last modified timestamps of classes for hot reload support.
  /// {@endtemplate}
  final Map<String, DateTime> _classTimestamps = HashMap<String, DateTime>();
  
  /// {@template class_loader_development_mode}
  /// Development mode flag
  /// 
  /// This flag is used to enable or disable development mode.
  /// {@endtemplate}
  bool _developmentMode = false;
  
  /// {@template class_loader_resource_cache}
  /// Resource cache for performance
  /// 
  /// This cache stores resources for performance.
  /// {@endtemplate}
  final Map<String, ClassLoaderResource> _resourceCache = HashMap<String, ClassLoaderResource>();
  
  /// {@template class_loader_plugins}
  /// Plugin system for extending functionality
  /// 
  /// This list stores plugins for extending functionality.
  /// {@endtemplate}
  final List<ClassLoaderPlugin> _plugins = [];

  /// {@template class_loader_default_ctor}
  /// Constructs a [ClassLoader] with the system class loader as its parent.
  ///
  /// Example:
  /// ```dart
  /// final loader = CustomClassLoader(); // Uses system loader as parent
  /// ```
  /// {@endtemplate}
  ClassLoader() : _parent = _getSystemClassLoader();

  /// {@template class_loader_with_parent}
  /// Constructs a [ClassLoader] with the specified [parent] loader.
  ///
  /// Example:
  /// ```dart
  /// final loader = CustomClassLoader.withParent(otherLoader);
  /// ```
  /// {@endtemplate}
  ClassLoader.withParent(ClassLoader? parent) : _parent = parent;

  /// {@template class_loader_internal_ctor}
  /// Internal constructor for creating the system class loader root.
  ///
  /// Used only within JetLeaf's class loading internals.
  /// {@endtemplate}
  ClassLoader._system() : _parent = null;

  /// Singleton instance of the system class loader.
  static ClassLoader? _systemClassLoader;

  /// {@template class_loader_get_system_internal}
  /// Lazily initializes and returns the system class loader.
  /// {@endtemplate}
  static ClassLoader _getSystemClassLoader() {
    return _systemClassLoader ??= SystemClassLoader._();
  }

  /// {@template class_loader_get_system}
  /// Returns the global system class loader used by default in JetLeaf.
  ///
  /// This is the root loader in the delegation chain and is used
  /// whenever no parent is specified.
  ///
  /// Example:
  /// ```dart
  /// final loader = ClassLoader.getSystemClassLoader();
  /// ```
  /// {@endtemplate}
  static ClassLoader getSystemClassLoader() {
    return _getSystemClassLoader();
  }

  /// {@template class_loader_get_parent}
  /// Returns the parent class loader of this loader.
  ///
  /// If no parent was set, returns `null` (e.g., for system loader).
  ///
  /// Example:
  /// ```dart
  /// final parent = loader.getParent();
  /// ```
  /// {@endtemplate}
  ClassLoader? getParent() => _parent;
  
  /// Loads the class with the specified binary name.
  /// 
  /// This method searches for classes in the following order:
  /// 1. Check if the class has already been loaded
  /// 2. Delegate to parent class loader (if exists)
  /// 3. Call findClass to find the class
  /// 
  /// [name] The binary name of the class
  /// [resolve] If true then resolve the class
  /// 
  /// Returns the resulting Class object
  /// Throws [ClassNotFoundException] if the class could not be found
  Class<T> loadClass<T>(String name, [bool resolve = false]) {
    final stopwatch = Stopwatch()..start();
    
    try {
      // Check for hot reload in development mode
      if (_developmentMode && _shouldReloadClass(name)) {
        _invalidateClass(name);
      }
      
      // Notify plugins
      for (final plugin in _plugins) {
        plugin.beforeClassLoad(name);
      }
      
      final result = _loadClass<T>(name, resolve);
      
      // Record metrics
      _metrics.recordClassLoad(name, stopwatch.elapsedMicroseconds);
      
      // Notify plugins
      for (final plugin in _plugins) {
        plugin.afterClassLoad(name, result as Class<Object>);
      }
      
      return result;
    } catch (e) {
      _metrics.recordClassLoadError(name, e);
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
  
  /// Internal implementation of class loading with proper synchronization
  Class<T> _loadClass<T>(String name, bool resolve) {
    final lock = _getClassLoadingLock(name);
    
    return synchronized(lock, () {
      // First, check if the class has already been loaded
      Class<T>? c = _findLoadedClass<T>(name);
      
      if (c == null) {
        try {
          if (_parent != null) {
            // Delegate to parent class loader
            c = _parent._loadClass<T>(name, false);
          } else {
            // Try to find bootstrap class
            c = _findBootstrapClassOrNull<T>(name);
          }
        } on ClassNotFoundException {
          // ClassNotFoundException thrown if class not found from parent
          // This is expected behavior, continue to findClass
        }
        
        if (c == null) {
          // If still not found, call findClass to find the class
          c = findClass<T>(name);
          
          // Record timestamp for hot reload
          if (_developmentMode) {
            _classTimestamps[name] = DateTime.now();
          }
        }
      }
      
      if (resolve) {
        _resolveClass(c);
      }
      
      return c;
    });
  }
  
  /// Finds the class with the specified binary name.
  /// 
  /// This method should be overridden by class loader implementations
  /// to define how classes are found. The default implementation throws
  /// ClassNotFoundException.
  /// 
  /// [name] The binary name of the class
  /// 
  /// Returns the resulting Class object
  /// Throws [ClassNotFoundException] if the class could not be found
  Class<T> findClass<T>(String name) {
    throw ClassNotFoundException(name);
  }
  
  /// Converts an array of bytes into an instance of class Class.
  /// 
  /// This method is used to define a class from byte array data.
  /// In Dart, this is simulated by creating a Class from reflection.
  /// 
  /// [name] The expected binary name of the class
  /// [b] The bytes that make up the class data
  /// [off] The start offset in b of the class data
  /// [len] The length of the class data
  /// [protectionDomain] The ProtectionDomain of the class
  /// 
  /// Returns the Class object created from the data
  /// Throws [ClassFormatException] if the data did not contain a valid class
  Class<T> defineClass<T>(String name, List<int> b, int off, int len, [ProtectionDomain? protectionDomain]) {
    return _defineClass<T>(name, b, off, len, protectionDomain);
  }
  
  /// Internal implementation of class definition
  Class<T> _defineClass<T>(String name, List<int> b, int off, int len, [ProtectionDomain? protectionDomain]) {
    // In a real implementation, this would parse the byte array
    // For Dart, we simulate this by trying to create a Class from reflection
    try {
      // This is a simplified implementation
      // In practice, you would need to deserialize the class from bytes
      throw UnsupportedError('defineClass from bytes not implemented in Dart');
    } catch (e) {
      throw ClassFormatException('Invalid class format for $name: $e');
    }
  }

  /// {@template class_loader_enable_development_mode}
  /// Enables development mode with hot reload and enhanced debugging
  /// 
  /// This method enables development mode, which provides hot reload support
  /// and detailed metrics tracking for performance monitoring.
  /// 
  /// Example:
  /// ```dart
  /// final loader = ClassLoader();
  /// loader.enableDevelopmentMode();
  /// ```
  /// 
  /// {@endtemplate}
  void enableDevelopmentMode() {
    _developmentMode = true;
    _metrics.enableDetailedTracking();
  }
  
  /// {@template class_loader_disable_development_mode}
  /// Disables development mode for production performance
  /// 
  /// This method disables development mode, which disables hot reload support
  /// and detailed metrics tracking for performance monitoring.
  /// 
  /// Example:
  /// ```dart
  /// final loader = ClassLoader();
  /// loader.disableDevelopmentMode();
  /// ```
  /// 
  /// {@endtemplate}
  void disableDevelopmentMode() {
    _developmentMode = false;
    _metrics.disableDetailedTracking();
  }
  
  /// {@template class_loader_is_development_mode}
  /// Checks if development mode is enabled
  /// 
  /// This method returns true if development mode is enabled, false otherwise.
  /// 
  /// Example:
  /// ```dart
  /// final loader = ClassLoader();
  /// final isDevMode = loader.isDevelopmentMode;
  /// ```
  /// 
  /// {@endtemplate}
  bool get isDevelopmentMode => _developmentMode;
  
  /// {@template class_loader_add_plugin}
  /// Adds a plugin to extend class loader functionality
  /// 
  /// This method adds a plugin to the class loader, which extends its functionality.
  /// 
  /// Example:
  /// ```dart
  /// final loader = ClassLoader();
  /// loader.addPlugin(MyClassLoaderPlugin());
  /// ```
  /// 
  /// {@endtemplate}
  void addPlugin(ClassLoaderPlugin plugin) {
    _plugins.add(plugin);
    plugin.initialize(this);
  }
  
  /// {@template class_loader_remove_plugin}
  /// Removes a plugin
  /// 
  /// This method removes a plugin from the class loader, which extends its functionality.
  /// 
  /// Example:
  /// ```dart
  /// final loader = ClassLoader();
  /// loader.removePlugin(MyClassLoaderPlugin());
  /// ```
  /// 
  /// {@endtemplate}
  void removePlugin(ClassLoaderPlugin plugin) {
    _plugins.remove(plugin);
    plugin.dispose();
  }
  
  /// Links the specified class.
  /// 
  /// This method is used to link a class, which involves verifying
  /// and preparing the class. In Dart, this is mostly a no-op.
  /// 
  /// [c] The class to link
  void _resolveClass<T>(Class<T> c) {
    // In Dart, class resolution is handled by the VM
    // This is mostly a no-op for compatibility
  }
  
  /// Returns the class with the given binary name if this loader
  /// has been recorded by the Java virtual machine as an initiating
  /// loader of a class with that binary name.
  /// 
  /// [name] The binary name of the class
  /// 
  /// Returns the Class object, or null if the class has not been loaded
  Class<T>? _findLoadedClass<T>(String name) {
    final clazz = _classes[name];
    return clazz as Class<T>?;
  }
  
  /// Finds a class with the specified name from the system class loader.
  /// 
  /// [name] The binary name of the class
  /// 
  /// Returns the Class object for the system class
  /// Throws [ClassNotFoundException] if the class could not be found
  Class<T> findSystemClass<T>(String name) {
    return getSystemClassLoader().loadClass<T>(name);
  }
  
  /// Attempts to find a bootstrap class, returns null if not found.
  /// 
  /// [name] The binary name of the class
  /// 
  /// Returns the Class object, or null if not found
  Class<T>? _findBootstrapClassOrNull<T>(String name) {
    // In Dart, bootstrap classes are core library classes
    try {
      // Try to find core Dart classes
      // Handle dart: scheme URIs
      if (name.startsWith('dart:')) {
        return _findDartCoreClass<T>(name);
      }

      switch (name) {
        case 'Object':
          return Class<Object>() as Class<T>;
        case 'String':
          return Class<String>() as Class<T>;
        case 'int':
          return Class<int>() as Class<T>;
        case 'double':
          return Class<double>() as Class<T>;
        case 'bool':
          return Class<bool>() as Class<T>;
        case 'List':
          return Class<List>() as Class<T>;
        case 'Map':
          return Class<Map>() as Class<T>;
        case 'Set':
          return Class<Set>() as Class<T>;
        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Finds a class from dart: core libraries
  Class<T>? _findDartCoreClass<T>(String dartUri) {
    try {
      final uri = Uri.parse(dartUri);
      final libraryName = uri.scheme + ':' + uri.path;
      
      final mirrorSystem = mirrors.currentMirrorSystem();
      final library = mirrorSystem.libraries[Uri.parse(libraryName)];
      
      if (library != null) {
        // If no fragment specified, return the library's main class
        if (uri.fragment.isEmpty) {
          return null;
        }
        
        // Look for specific class in the library
        final className = uri.fragment;
        final declaration = library.declarations[Symbol(className)];
        
        if (declaration is mirrors.ClassMirror) {
          return Class<T>.fromDartMirror(declaration);
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Returns an object to be used as a lock for loading the named class.
  /// 
  /// [className] The name of the class
  /// 
  /// Returns the lock object for the class
  ClassLoadingLock _getClassLoadingLock(String className) {
    return _classLoadingLocks.putIfAbsent(className, () => ClassLoadingLockImpl(className));
  }
  
  /// Finds the resource with the given name.
  /// 
  /// [name] The resource name
  /// 
  /// Returns the URL for reading the resource, or null if not found
  /// Supports:
  /// - package:my_package/resource.json
  /// - dart:core/resource.txt  
  /// - file:///path/to/resource.txt
  /// - http://example.com/resource.json
  /// - https://example.com/resource.json
  Future<Uri?> findResource(String name) async {
    // Check cache first
    final cached = _resourceCache[name];
    if (cached != null && !cached.isExpired) {
      return cached.uri;
    }
    
    try {
      final uri = await _resourceResolver.resolveResource(name);
      
      // Cache the result
      if (uri != null) {
        _resourceCache[name] = ClassLoaderResourceImpl(uri, DateTime.now());
      }
      
      return uri;
    } catch (e) {
      if (_developmentMode) {
        print('Warning: Failed to resolve resource $name: $e');
      }
      return null;
    }
  }
  
  /// Finds the resource with the given name.
  /// 
  /// This method will first search the parent class loader for the resource;
  /// if the parent is null the path of the class loader built-in to the
  /// virtual machine is searched.
  /// 
  /// [name] The resource name
  /// 
  /// Returns the URL for reading the resource, or null if not found
  Future<Uri?> getResource(String name) async {
    if (_parent != null) {
      final parentResource = await _parent.getResource(name);
      if (parentResource != null) {
        return parentResource;
      }
    }
    return await findResource(name);
  }
  
  /// Finds all the resources with the given name.
  /// 
  /// [name] The resource name
  /// 
  /// Returns an List of URLs for the resources
  Future<List<Uri>> findResources(String name) async {
    return await _resourceResolver.resolveAllResources(name);
  }
  
  /// Finds all the resources with the given name.
  /// 
  /// [name] The resource name
  /// 
  /// Returns an List of URLs for the resources
  Future<List<Uri>> getResources(String name) async {
    final resources = <Uri>[];
    
    if (_parent != null) {
      resources.addAll(await _parent.getResources(name));
    }
    
    resources.addAll(await findResources(name));
    return resources;
  }

  /// Loads resource content as string
  Future<String?> getResourceAsString(String name) async {
    final uri = await getResource(name);
    if (uri == null) return null;
    
    return await _resourceResolver.loadResourceAsString(uri);
  }
  
  /// Loads resource content as bytes
  Future<List<int>?> getResourceAsBytes(String name) async {
    final uri = await getResource(name);
    if (uri == null) return null;
    
    return await _resourceResolver.loadResourceAsBytes(uri);
  }
  
  /// Loads resource content as JSON
  Future<Map<String, dynamic>?> getResourceAsJson(String name) async {
    final content = await getResourceAsString(name);
    if (content == null) return null;
    
    try {
      return json.decode(content) as Map<String, dynamic>;
    } catch (e) {
      if (_developmentMode) {
        // print('Warning: Failed to parse JSON resource $name: $e');
      }
      return null;
    }
  }
  
  /// Defines a package with the specified name.
  /// 
  /// [name] The package name
  /// [specTitle] The specification title
  /// [specVersion] The specification version
  /// [specVendor] The specification vendor
  /// [implTitle] The implementation title
  /// [implVersion] The implementation version
  /// [implVendor] The implementation vendor
  /// [sealBase] The URL used to seal the package
  /// 
  /// Returns the newly defined Package object
  /// Throws [IllegalArgumentException] if package name duplicates an existing package
  PackageInfo definePackage(
    String name,
    String? specTitle,
    String? specVersion,
    String? specVendor,
    String? implTitle,
    String? implVersion,
    String? implVendor,
    Uri? sealBase,
  ) {
    if (_packages.containsKey(name)) {
      throw IllegalArgumentException('Package $name already defined');
    }
    
    final package = PackageInfo(
      name: name,
      specTitle: specTitle,
      specVersion: specVersion,
      specVendor: specVendor,
      implTitle: implTitle,
      implVersion: implVersion,
      implVendor: implVendor,
      sealBase: sealBase,
    );
    
    _packages[name] = package;
    return package;
  }
  
  /// Returns the Package with the given name.
  /// 
  /// [name] The package name
  /// 
  /// Returns the Package corresponding to the given name, or null if not found
  PackageInfo? getPackage(String name) {
    final package = _packages[name];
    if (package != null) {
      return package;
    }
    
    if (_parent != null) {
      return _parent.getPackage(name);
    }
    
    return null;
  }
  
  /// Returns all of the Packages defined by this class loader and its ancestors.
  /// 
  /// Returns the array of Package objects defined by this ClassLoader
  List<PackageInfo> getPackages() {
    final packages = <PackageInfo>[];
    packages.addAll(_packages.values);
    
    if (_parent != null) {
      packages.addAll(_parent.getPackages());
    }
    
    return packages;
  }
  
  /// Records a class as loaded by this class loader
  void _recordClassAsLoaded<T>(String name, Class<T> clazz) {
    _classes[name] = clazz as Class<Object>;
  }

  /// Hot reload support - checks if class should be reloaded
  bool _shouldReloadClass(String name) {
    if (!_developmentMode) return false;
    
    final timestamp = _classTimestamps[name];
    if (timestamp == null) return false;
    
    // Check if source file has been modified
    // This is a simplified implementation
    return false;
  }
  
  /// Invalidates a class for hot reload
  void _invalidateClass(String name) {
    _classes.remove(name);
    _classTimestamps.remove(name);
    _metrics.recordClassReload(name);
  }
  
  /// Gets performance metrics
  ClassLoaderMetrics getMetrics() => _metrics;
  
  /// Preloads commonly used classes for better performance
  Future<void> preloadClasses(List<String> classNames) async {
    for (final className in classNames) {
      try {
        loadClass(className);
      } catch (e) {
        if (_developmentMode) {
          print('Warning: Failed to preload class $className: $e');
        }
      }
    }
  }
  
  /// Clears the class loader cache
  void clearCache() {
    _classes.clear();
    _packages.clear();
    _classLoadingLocks.clear();
    _resourceCache.clear();
    _classTimestamps.clear();
    _metrics.reset();
  }
  
  /// Optimizes resource cache by removing expired entries
  void optimizeCache() {
    final now = DateTime.now();
    _resourceCache.removeWhere((key, value) => value.isExpired);
    
    if (_developmentMode) {
      // print('Cache optimized: ${_resourceCache.length} resources cached');
    }
  }
  
  @override
  String toString() => 'ClassLoader(${runtimeType})';
}