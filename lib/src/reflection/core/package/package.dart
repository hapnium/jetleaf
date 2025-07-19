import 'package_descriptor.dart';

/// {@template package_info}
/// Metadata about a Dart package, typically extracted from `package_config.json`.
///
/// This class is used within JetLeaf to capture information about each package
/// in the runtime environment, such as the root application package and its
/// dependencies.
///
/// Example:
/// ```dart
/// final info = Package(
///   name: 'jetleaf',
///   version: '1.0.0',
///   languageVersion: '3.3',
///   isRootPackage: true,
/// );
/// print(info.name); // jetleaf
/// ```
/// {@endtemplate}
class Package extends PackageDescriptor {
  @override
  final String name;

  @override
  final String version;

  @override
  final String? languageVersion;

  @override
  final bool isRootPackage;

  /// {@macro package_info}
  const Package({
    required this.name,
    required this.version,
    this.languageVersion,
    required this.isRootPackage,
  });

  @override
  String toString() => 'Package(\n'
    'name: $name, \n'
    'version: $version, \n'
    'languageVersion: $languageVersion, \n'
    'isRootPackage: $isRootPackage\n'
  ')';
}