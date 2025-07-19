// /// {@template class_loader_api}
// /// Public API for JetLeaf class loaders.
// /// 
// /// This abstraction exposes all user-accessible operations of a [ClassLoader],
// /// while hiding internal implementation details like caching, locking, and metrics.
// /// 
// /// {@endtemplate}
// abstract class ClassLoaderApi {
//   /// Returns the global system class loader.
//   static ClassLoaderApi getSystemClassLoader();

//   /// Returns the parent class loader of this loader.
//   ClassLoaderApi? getParent();

//   /// Loads the class with the specified name.
//   Class<T> loadClass<T>(String name, [bool resolve = false]);

//   /// Finds a class from the system class loader.
//   Class<T> findSystemClass<T>(String name);

//   /// Defines a class from byte array data.
//   Class<T> defineClass<T>(
//     String name,
//     List<int> b,
//     int off,
//     int len, [
//     ProtectionDomain? protectionDomain,
//   ]);

//   /// Enables development mode (hot reload, debugging, etc).
//   void enableDevelopmentMode();

//   /// Disables development mode.
//   void disableDevelopmentMode();

//   /// Returns true if development mode is enabled.
//   bool get isDevelopmentMode;

//   /// Adds a plugin to this class loader.
//   void addPlugin(ClassLoaderPlugin plugin);

//   /// Removes a plugin from this class loader.
//   void removePlugin(ClassLoaderPlugin plugin);

//   /// Finds a resource by name (no parent fallback).
//   Future<Uri?> findResource(String name);

//   /// Finds a resource by name (with parent fallback).
//   Future<Uri?> getResource(String name);

//   /// Finds all resources by name (no parent fallback).
//   Future<List<Uri>> findResources(String name);

//   /// Finds all resources by name (with parent fallback).
//   Future<List<Uri>> getResources(String name);

//   /// Loads a resource as String.
//   Future<String?> getResourceAsString(String name);

//   /// Loads a resource as bytes.
//   Future<List<int>?> getResourceAsBytes(String name);

//   /// Loads a resource as JSON.
//   Future<Map<String, dynamic>?> getResourceAsJson(String name);

//   /// Defines a new package.
//   PackageInfo definePackage(
//     String name,
//     String? specTitle,
//     String? specVersion,
//     String? specVendor,
//     String? implTitle,
//     String? implVersion,
//     String? implVendor,
//     Uri? sealBase,
//   );

//   /// Gets a package by name.
//   PackageInfo? getPackage(String name);

//   /// Gets all defined packages.
//   List<PackageInfo> getPackages();

//   /// Gets performance metrics.
//   ClassLoaderMetrics getMetrics();

//   /// Preloads a list of classes.
//   Future<void> preloadClasses(List<String> classNames);

//   /// Clears class/resource/package caches.
//   void clearCache();

//   /// Optimizes resource cache by removing expired entries.
//   void optimizeCache();
// }