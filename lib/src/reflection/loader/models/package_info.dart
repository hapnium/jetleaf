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

/// {@template package_info}
/// Contains metadata information about a package.
///
/// This class provides access to both the **specification** and **implementation**
/// details of a package. This includes name, version, vendor, and seal information.
/// 
/// Example usage:
/// ```dart
/// final info = PackageInfo(
///   name: 'jetleaf.core',
///   specTitle: 'JetLeaf Core',
///   specVersion: '1.0.0',
///   specVendor: 'JetLeaf Inc.',
///   implTitle: 'JetLeaf Core Impl',
///   implVersion: '1.0.0+build.3',
///   implVendor: 'JetLeaf Inc.',
///   sealBase: Uri.parse('package:jetleaf/core.dart'),
/// );
///
/// print(info.getSpecificationVersion()); // 1.0.0
/// print(info.isCompatibleWith('1.0.0')); // true
/// print(info.isSealed()); // true
/// ```
/// {@endtemplate}
class PackageInfo {
  /// The name of the package.
  final String name;

  /// The title of the package specification.
  final String? specTitle;

  /// The version of the package specification.
  final String? specVersion;

  /// The vendor of the package specification.
  final String? specVendor;

  /// The title of the package implementation.
  final String? implTitle;

  /// The version of the package implementation.
  final String? implVersion;

  /// The vendor of the package implementation.
  final String? implVendor;

  /// The sealing base URI, used to determine if the package is sealed.
  final Uri? sealBase;

  /// {@macro package_info}
  const PackageInfo({
    required this.name,
    this.specTitle,
    this.specVersion,
    this.specVendor,
    this.implTitle,
    this.implVersion,
    this.implVendor,
    this.sealBase,
  });

  /// {@template package_info_get_name}
  /// Returns the name of this package.
  /// 
  /// ```dart
  /// print(packageInfo.getName()); // 'my_package'
  /// ```
  /// {@endtemplate}
  String getName() => name;

  /// {@template package_info_get_spec_title}
  /// Returns the specification title of the package.
  ///
  /// ```dart
  /// print(packageInfo.getSpecificationTitle()); // 'My Package Spec'
  /// ```
  /// {@endtemplate}
  String? getSpecificationTitle() => specTitle;

  /// {@template package_info_get_spec_version}
  /// Returns the specification version of the package.
  ///
  /// ```dart
  /// print(packageInfo.getSpecificationVersion()); // '1.0.0'
  /// ```
  /// {@endtemplate}
  String? getSpecificationVersion() => specVersion;

  /// {@template package_info_get_spec_vendor}
  /// Returns the specification vendor of the package.
  ///
  /// ```dart
  /// print(packageInfo.getSpecificationVendor()); // 'MyCompany'
  /// ```
  /// {@endtemplate}
  String? getSpecificationVendor() => specVendor;

  /// {@template package_info_get_impl_title}
  /// Returns the implementation title of the package.
  ///
  /// ```dart
  /// print(packageInfo.getImplementationTitle()); // 'My Package Impl'
  /// ```
  /// {@endtemplate}
  String? getImplementationTitle() => implTitle;

  /// {@template package_info_get_impl_version}
  /// Returns the implementation version of the package.
  ///
  /// ```dart
  /// print(packageInfo.getImplementationVersion()); // '1.2.3'
  /// ```
  /// {@endtemplate}
  String? getImplementationVersion() => implVersion;

  /// {@template package_info_get_impl_vendor}
  /// Returns the implementation vendor of the package.
  ///
  /// ```dart
  /// print(packageInfo.getImplementationVendor()); // 'VendorName'
  /// ```
  /// {@endtemplate}
  String? getImplementationVendor() => implVendor;

  /// {@template package_info_is_sealed}
  /// Returns `true` if this package is sealed.
  ///
  /// A sealed package prevents loading classes from outside
  /// the specified [sealBase].
  ///
  /// ```dart
  /// if (packageInfo.isSealed()) {
  ///   // package is sealed
  /// }
  /// ```
  /// {@endtemplate}
  bool isSealed() => sealBase != null;

  /// {@template package_info_is_sealed_with}
  /// Returns `true` if the package is sealed with respect to the given [url].
  ///
  /// This checks if the [sealBase] matches the provided [url].
  ///
  /// ```dart
  /// final url = Uri.parse('package:my_package/file.dart');
  /// print(packageInfo.isSealedWith(url));
  /// ```
  /// {@endtemplate}
  bool isSealedWith(Uri url) => sealBase == url;

  /// {@template package_info_is_compatible_with}
  /// Returns `true` if this package's specification version matches [desired].
  ///
  /// **Note**: This is a simple version equality check, not a semantic version range.
  ///
  /// ```dart
  /// print(packageInfo.isCompatibleWith('1.0.0')); // true or false
  /// ```
  /// {@endtemplate}
  bool isCompatibleWith(String desired) {
    if (specVersion == null) return false;
    return specVersion == desired;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PackageInfo && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'PackageInfo($name)';
}