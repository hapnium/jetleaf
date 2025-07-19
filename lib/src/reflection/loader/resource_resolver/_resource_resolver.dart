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

import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'resource_resolver.dart';

part '_cached_entry.dart';

/// Resolves resources using Dart URI schemes and provides caching
class ResourceResolverImpl implements ResourceResolver {
  final Map<String, Uri> _resolvedUris = {};
  final Map<Uri, _CachedContent> _contentCache = {};
  
  @override
  Future<Uri?> resolveResource(String name) async {
    // Check cache first
    if (_resolvedUris.containsKey(name)) {
      return _resolvedUris[name];
    }
    
    Uri? resolvedUri;
    
    if (name.startsWith('package:')) {
      resolvedUri = await resolvePackageResource(name);
    } else if (name.startsWith('dart:')) {
      resolvedUri = await resolveDartResource(name);
    } else if (name.startsWith('file:')) {
      resolvedUri = await resolveFileResource(name);
    } else if (name.startsWith('http:') || name.startsWith('https:')) {
      resolvedUri = await resolveHttpResource(name);
    } else {
      // Try to resolve as relative path
      resolvedUri = await resolveRelativeResource(name);
    }
    
    if (resolvedUri != null) {
      _resolvedUris[name] = resolvedUri;
    }
    
    return resolvedUri;
  }
  
  @override
  Future<List<Uri>> resolveAllResources(String namePattern) async {
    final resources = <Uri>[];
    
    if (namePattern.contains('*') || namePattern.contains('?')) {
      // Handle glob patterns
      resources.addAll(await resolveGlobPattern(namePattern));
    } else {
      final uri = await resolveResource(namePattern);
      if (uri != null) {
        resources.add(uri);
      }
    }
    
    return resources;
  }
  
  @override
  Future<Uri?> resolvePackageResource(String packageUri) async {
    try {
      final uri = Uri.parse(packageUri);
      
      // Get package root from .dart_tool/package_config.json
      final packageConfig = await getPackageConfig();
      if (packageConfig == null) return null;
      
      final packages = packageConfig['packages'] as List?;
      if (packages == null) return null;
      
      final packageName = uri.pathSegments.first;
      final resourcePath = uri.pathSegments.skip(1).join('/');
      
      for (final package in packages) {
        if (package is Map && package['name'] == packageName) {
          final rootUri = package['rootUri'] as String?;
          if (rootUri != null) {
            final packageRoot = Uri.parse(rootUri);
            final resourceUri = packageRoot.resolve(resourcePath);
            
            // Check if resource exists
            if (await resourceExists(resourceUri)) {
              return resourceUri;
            }
          }
        }
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Uri?> resolveDartResource(String dartUri) async {
    try {
      final uri = Uri.parse(dartUri);
      
      // Dart core libraries are built-in, so we can't access their source files
      // But we can verify they exist and return the URI
      final dartSdkLibraries = [
        'core', 'async', 'collection', 'convert', 'io', 'isolate',
        'math', 'mirrors', 'typed_data', 'html', 'js', 'svg'
      ];
      
      if (dartSdkLibraries.contains(uri.path)) {
        return uri;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Uri?> resolveFileResource(String fileUri) async {
    try {
      final uri = Uri.parse(fileUri);
      final file = File.fromUri(uri);
      
      if (await file.exists()) {
        return uri;
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Uri?> resolveHttpResource(String httpUri) async {
    try {
      final uri = Uri.parse(httpUri);
      
      // Make a HEAD request to check if resource exists
      final client = HttpClient();
      try {
        final request = await client.headUrl(uri);
        final response = await request.close();
        
        if (response.statusCode == 200) {
          return uri;
        }
      } finally {
        client.close();
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Uri?> resolveRelativeResource(String name) async {
    // Try common locations
    final locations = [
      'lib/$name',
      'assets/$name',
      'resources/$name',
      'web/$name',
      name,
    ];
    
    for (final location in locations) {
      final file = File(location);
      if (await file.exists()) {
        return file.uri;
      }
    }
    
    return null;
  }
  
  @override
  Future<List<Uri>> resolveGlobPattern(String pattern) async {
    final resources = <Uri>[];
    
    // This is a simplified glob implementation
    // In practice, you'd want a more robust pattern matching
    if (pattern.startsWith('package:')) {
      // Handle package glob patterns
      final basePattern = pattern.replaceAll('*', '');
      final packageConfig = await getPackageConfig();
      
      if (packageConfig != null) {
        final packages = packageConfig['packages'] as List?;
        if (packages != null) {
          for (final package in packages) {
            if (package is Map) {
              final packageName = package['name'] as String?;
              if (packageName != null && pattern.contains(packageName)) {
                // Find matching resources in this package
                // This would require directory traversal
              }
            }
          }
        }
      }
    }
    
    return resources;
  }
  
  @override
  Future<String?> loadResourceAsString(Uri uri) async {
    final cached = _contentCache[uri];
    if (cached != null && !cached.isExpired) {
      return cached.content as String?;
    }
    
    try {
      String? content;
      
      if (uri.scheme == 'file') {
        final file = File.fromUri(uri);
        content = await file.readAsString();
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        final client = HttpClient();
        try {
          final request = await client.getUrl(uri);
          final response = await request.close();
          
          if (response.statusCode == 200) {
            content = await response.transform(utf8.decoder).join();
          }
        } finally {
          client.close();
        }
      }
      
      if (content != null) {
        _contentCache[uri] = _CachedContent(content, DateTime.now());
      }
      
      return content;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Uint8List?> loadResourceAsBytes(Uri uri) async {
    final cached = _contentCache[uri];
    if (cached != null && !cached.isExpired) {
      return cached.content as Uint8List?;
    }
    
    try {
      Uint8List? bytes;
      
      if (uri.scheme == 'file') {
        final file = File.fromUri(uri);
        bytes = await file.readAsBytes();
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        final client = HttpClient();
        try {
          final request = await client.getUrl(uri);
          final response = await request.close();
          
          if (response.statusCode == 200) {
            final bytesBuilder = BytesBuilder();
            await for (final chunk in response) {
              bytesBuilder.add(chunk);
            }
            bytes = bytesBuilder.toBytes();
          }
        } finally {
          client.close();
        }
      }
      
      if (bytes != null) {
        _contentCache[uri] = _CachedContent(bytes, DateTime.now());
      }
      
      return bytes;
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<Map<String, dynamic>?> getPackageConfig() async {
    try {
      final configFile = File('.dart_tool/package_config.json');
      if (await configFile.exists()) {
        final content = await configFile.readAsString();
        return json.decode(content) as Map<String, dynamic>;
      }
    } catch (e) {
      // Fallback to .packages file
      try {
        final packagesFile = File('.packages');
        if (await packagesFile.exists()) {
          // Parse .packages format (legacy)
          final lines = await packagesFile.readAsLines();
          final packages = <Map<String, String>>[];
          
          for (final line in lines) {
            if (line.trim().isEmpty || line.startsWith('#')) continue;
            
            final parts = line.split(':');
            if (parts.length == 2) {
              packages.add({
                'name': parts[0],
                'rootUri': parts[1],
              });
            }
          }
          
          return {'packages': packages};
        }
      } catch (e) {
        // Ignore
      }
    }
    
    return null;
  }
  
  @override
  Future<bool> resourceExists(Uri uri) async {
    try {
      if (uri.scheme == 'file') {
        final file = File.fromUri(uri);
        return await file.exists();
      } else if (uri.scheme == 'http' || uri.scheme == 'https') {
        final client = HttpClient();
        try {
          final request = await client.headUrl(uri);
          final response = await request.close();
          return response.statusCode == 200;
        } finally {
          client.close();
        }
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
  
  @override
  void clearCache() {
    _resolvedUris.clear();
    _contentCache.clear();
  }
}