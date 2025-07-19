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
import 'dart:mirrors';

import 'package:jetleaf/reflection.dart' show PackageDescriptor;
import 'package:jetleaf/src/system/_system_detector.dart';

final class JetApplication {
  static void run(Type primarySource, List<String> args) {
    // final detectedSystem = SystemDetector.detect();
    // print("System: ${detectedSystem.toString()}");
    print("Running arguments: $args");
    final script = Platform.script.toString();
    print('Running from: $script');
    print('Running executable: ${Platform.executable}');
    print('Running resolved executable: ${Platform.resolvedExecutable}');

    final system = currentMirrorSystem();
    // system.noSuchMethod(Invocation.getter(name))
    system.libraries.forEach((key, value) {
      // if(!key.toString().startsWith('package:jetleaf_')) {
      //   return;
      // }
      print("Key: $key");
      print("Value: $value");
      print("URI: ${value.uri}");
      // print("Is Private: ${value.isPrivate}");
      // print("Is Top Level: ${value.isTopLevel}");
      // print("Simple Name: ${value.simpleName}");
      // print("Qualified Name: ${value.qualifiedName}");
      // print("Runtime Type: ${value.runtimeType}");
      
      // /// Source Location
      // print("Source Location URI: ${value.location?.sourceUri}");
      // print("Source Location Line: ${value.location?.line}");
      // print("Source Location Column: ${value.location?.column}");

      // /// Metadata
      // value.metadata.forEach((metadata) {
      //   print("Metadata: $metadata");
      //   print("Metadata Has Reflectee: ${metadata.hasReflectee}");
      //   print("Metadata Reflectee: ${metadata.reflectee}");
      //   print("Metadata Type Simple Name: ${metadata.type.simpleName}");
      //   print("Metadata Type Qualified Name: ${metadata.type.qualifiedName}");
      //   print("Metadata Type Runtime Type: ${metadata.type.runtimeType}");
      //   print("Metadata Type URI: ${metadata.type.location?.sourceUri}");
      //   print("Metadata Type Line: ${metadata.type.location?.line}");
      //   print("Metadata Type Column: ${metadata.type.location?.column}");
      // });

      // /// Declarations
      value.declarations.forEach((key, value) {
        print("Declaration: $key");
        print("Declaration: $value");
        // print("Declaration Is Private: ${value.isPrivate}");
        // print("Declaration Is Top Level: ${value.isTopLevel}");
        // print("Declaration Simple Name: ${value.simpleName}");
        // print("Declaration Qualified Name: ${value.qualifiedName}");
        // print("Declaration Runtime Type: ${value.runtimeType}");
        print("Declaration URI: ${value.location?.sourceUri}");
        // print("Declaration Line: ${value.location?.line}");
        // print("Declaration Column: ${value.location?.column}");
      });

      // if(value.owner != null) {
      //   /// Owner
      //   print("Owner: ${value.owner}");
      //   print("Owner Is Private: ${value.owner?.isPrivate}");
      //   print("Owner Is Top Level: ${value.owner?.isTopLevel}");
      //   print("Owner Simple Name: ${value.owner?.simpleName}");
      //   print("Owner Qualified Name: ${value.owner?.qualifiedName}");
      //   print("Owner Runtime Type: ${value.owner?.runtimeType}");
      //   print("Owner URI: ${value.owner?.location?.sourceUri}");
      //   print("Owner Line: ${value.owner?.location?.line}");
      //   print("Owner Column: ${value.owner?.location?.column}");
      // }
    });

    // Find the PackageDescriptor type mirror
    ClassMirror? packageInfoTypeMirror;
    for (var libMirror in system.libraries.values) {
      final declaration = libMirror.declarations[Symbol('PackageDescriptor')];
      if (declaration is ClassMirror) {
        packageInfoTypeMirror = declaration;
        break;
      }
    }

    if (packageInfoTypeMirror == null) {
      print("Error: PackageDescriptor abstract class not found via mirrors.");
      return;
    }

    print("--- Discovered Libraries and PackageDescriptor Classes ---");
    system.libraries.forEach((uri, libMirror) {
      // Print library info
      // print("Key: $uri"); // Too verbose for general output
      // print("Value: $libMirror");
      // print("URI: ${libMirror.uri}");

      // Iterate through declarations within each library
      libMirror.declarations.forEach((declName, declMirror) {
        // print("Declaration: $declName"); // Too verbose
        // print("Declaration URI: ${declMirror.location?.sourceUri}");

        // Check if it's a class and if it implements PackageDescriptor
        if (declMirror is ClassMirror && declMirror != packageInfoTypeMirror) {
          bool implementsPackageInfo = false;
          try {
            if (declMirror.isSubtypeOf(packageInfoTypeMirror!.originalDeclaration)) {
              implementsPackageInfo = true;
            }
          } catch (e) {
            // Handle cases where isSubtypeOf might fail for some mirrors (e.g., private classes)
            // print("  -> Error checking subtype for $declName: $e"); // Debugging only
          }

          if (implementsPackageInfo) {
            try {
              // Instantiate the class to get its properties
              // Ensure the class has a default (no-arg) constructor for this to work
              final instance = declMirror.newInstance(Symbol(''), []).reflectee;
              if (instance is PackageDescriptor) {
                print("  -> Discovered PackageDescriptor: Name=${instance.name}, Version=${instance.version}");
              }
            } catch (e) {
              print("  -> Could not instantiate PackageDescriptor class $declName (does it have a default constructor?): $e");
            }
          }
        }
      });
    });
    print("----------------------------------------------------\n");

    // Instantiate and run the user's main application class
    try {
      final mainClassMirror = reflectClass(primarySource);
      // Assuming the user's Main class has a default constructor or one that takes Check
      // For simplicity, let's assume a default constructor for now.
      // If it needs dependencies, you'd resolve them here.
      // final mainInstance = mainClassMirror.newInstance(Symbol(''), []).reflectee;
      // if (mainInstance is Main) {
      //   mainInstance.run();
      // } else {
      //   print("Error: Primary source is not an instance of Main.");
      // }
    } catch (e) {
      print("Error running user's application: $e");
    }
  }
}