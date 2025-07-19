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

import 'package:jetleaf/src/reflection/loader/_class_loader.dart';
import 'package:jetleaf/src/reflection/loader/class_loader.dart';

/// Example showcasing the supercharged ClassLoader features
void main() async {
  // Create supercharged JetLeaf class loader
  final classLoader = JetLeafClassLoader(
    basePackages: ['package:my_app/', 'package:shared/'],
    parent: ClassLoader.getSystemClassLoader(),
  );
  
  // Enable development mode for superpowers
  classLoader.enableDevelopmentMode();
  
  print('🚀 JetLeaf ClassLoader Superpowers Demo');
  print('=====================================');
  
  // 1. Enhanced Package Scanning
  print('\n1. 🔍 Enhanced Package Scanning');
  await classLoader.scanPackages();
  
  // 2. Smart Resource Loading with Dart URIs
  print('\n2. 📦 Smart Resource Loading');
  await _demonstrateResourceLoading(classLoader);
  
  // 3. Performance Monitoring
  print('\n3. 📊 Performance Monitoring');
  _demonstratePerformanceMonitoring(classLoader);
  
  // 4. Hot Reload Capabilities
  print('\n4. 🔥 Hot Reload Capabilities');
  await _demonstrateHotReload(classLoader);
  
  // 5. Smart Preloading
  print('\n5. 🧠 Smart Preloading');
  await classLoader.smartPreload();
  
  // 6. Dependency Analysis
  print('\n6. 🔗 Dependency Analysis');
  classLoader.printDependencyAnalysis();
  
  // 7. Fuzzy Class Finding (Development Mode)
  print('\n7. 🎯 Fuzzy Class Finding');
  await _demonstrateFuzzyFinding(classLoader);
  
  // 8. Resource Caching and Optimization
  print('\n8. ⚡ Resource Optimization');
  classLoader.optimizeCache();
  
  // Final performance report
  print('\n📈 Final Performance Report');
  classLoader.getMetrics().printReport();
}

/// Demonstrates advanced resource loading with Dart URIs
Future<void> _demonstrateResourceLoading(JetLeafClassLoader classLoader) async {
  // Load from package: scheme
  final packageResource = await classLoader.getResource('package:my_app/config.json');
  print('📦 Package resource: $packageResource');
  
  // Load from dart: scheme
  final dartResource = await classLoader.getResource('dart:core');
  print('🎯 Dart resource: $dartResource');
  
  // Load from file: scheme
  final fileResource = await classLoader.getResource('file:///tmp/config.json');
  print('📁 File resource: $fileResource');
  
  // Load from HTTP
  final httpResource = await classLoader.getResource('https://api.example.com/config.json');
  print('🌐 HTTP resource: $httpResource');
  
  // Load as JSON
  final jsonConfig = await classLoader.getResourceAsJson('package:my_app/config.json');
  print('📋 JSON config: $jsonConfig');
  
  // Load multiple resources with glob patterns
  final allConfigs = await classLoader.getResources('package:*/config.json');
  print('🔍 Found ${allConfigs.length} config files');
}

/// Demonstrates performance monitoring
void _demonstratePerformanceMonitoring(JetLeafClassLoader classLoader) {
  // Load some classes to generate metrics
  try {
    classLoader.loadClass<String>('String');
    classLoader.loadClass<List>('List');
    classLoader.loadClass<Map>('Map');
  } catch (e) {
    // Expected for demo
  }
  
  final metrics = classLoader.getMetrics();
  final summary = metrics.getSummary();
  
  print('📊 Metrics Summary:');
  print('  Total Loads: ${summary['totalLoads']}');
  print('  Cache Hit Ratio: ${(summary['cacheHitRatio'] * 100).toStringAsFixed(1)}%');
  print('  Average Load Time: ${(summary['averageLoadTime'] / 1000).toStringAsFixed(2)}ms');
}

/// Demonstrates hot reload capabilities
Future<void> _demonstrateHotReload(JetLeafClassLoader classLoader) async {
  // This would work with actual user classes
  print('🔥 Hot reload capabilities:');
  
  final dependencyInfo = classLoader.getDependencyInfo();
  final hotReloadable = dependencyInfo['hotReloadableClasses'] as List;
  
  print('  Hot-reloadable classes: ${hotReloadable.length}');
  
  if (hotReloadable.isNotEmpty) {
    final className = hotReloadable.first;
    print('  Example: $className can be hot-reloaded');
    
    // In a real scenario, you would:
    await classLoader.hotReloadClass(className);
  }
}

/// Demonstrates fuzzy class finding
Future<void> _demonstrateFuzzyFinding(JetLeafClassLoader classLoader) async {
  print('🎯 Fuzzy finding examples:');
  
  // These would work with actual classes in development mode
  try {
    // Case-insensitive matching
    final clazz1 = classLoader.loadClass('string'); // finds 'String'
    print('  ✅ Found: ${clazz1.simpleName}');
  } catch (e) {
    print('  ℹ️  Would find String class in dev mode');
  }
  
  try {
    // Partial matching
    final clazz2 = classLoader.loadClass('List'); // finds 'List'
    print('  ✅ Found: ${clazz2.simpleName}');
  } catch (e) {
    print('  ℹ️  Partial matching available in dev mode');
  }
}

// Example classes for demonstration
@Component()
class UserService {
  final DatabaseService _db;
  
  UserService(this._db);
  
  Future<List<User>> getUsers() async {
    return await _db.findAll<User>();
  }
}

@Repository()
class DatabaseService {
  Future<List<T>> findAll<T>() async {
    // Simulate database operation
    await Future.delayed(Duration(milliseconds: 100));
    return <T>[];
  }
}

@Controller()
class UserController {
  final UserService _userService;
  
  UserController(this._userService);
  
  @GetMapping('/users')
  Future<List<User>> getAllUsers() async {
    return await _userService.getUsers();
  }
}

class User {
  final String name;
  final int age;
  
  User(this.name, this.age);
  
  @override
  String toString() => 'User(name: $name, age: $age)';
}

// Annotations for demonstration
class Component {
  const Component();
}

class Repository {
  const Repository();
}

class Controller {
  const Controller();
}

class GetMapping {
  final String path;
  const GetMapping(this.path);
}