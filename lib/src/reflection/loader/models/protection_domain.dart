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

/// {@template protection_domain}
/// Represents the protection domain of a class.
///
/// A protection domain encapsulates:
/// - The `codeSource`: the origin URI of the class (e.g., a `.jar` or Dart package location),
/// - A set of `permissions`: what the class is allowed to do,
/// - A set of `principals`: identities (users, roles) on whose behalf the class may act.
///
/// This abstraction allows the security system to determine what actions a class is permitted
/// to perform at runtime.
///
/// Example usage:
/// ```dart
/// final domain = ProtectionDomain(
///   codeSource: Uri.parse('package:myapp/utils.dart'),
///   permissions: ['read', 'write', '*'],
///   principals: ['admin', 'user'],
/// );
///
/// print(domain.implies('write')); // true
/// print(domain.implies('delete')); // true, because of '*'
/// ```
/// {@endtemplate}
class ProtectionDomain {
  /// The origin URI of the class (e.g., file path or package location).
  final Uri? codeSource;

  /// The list of permissions assigned to this domain.
  final List<String> permissions;

  /// The list of principals (e.g., users, roles) that this domain represents.
  final List<String> principals;

  /// {@macro protection_domain}
  const ProtectionDomain({
    this.codeSource,
    this.permissions = const [],
    this.principals = const [],
  });

  /// {@template protection_domain_implies}
  /// Checks whether this protection domain *implies* the given [permission].
  ///
  /// The check returns `true` if the domain explicitly lists the permission
  /// or includes a wildcard (`'*'`) to represent all permissions.
  ///
  /// Example:
  /// ```dart
  /// domain.implies('read'); // true if 'read' or '*' is in [permissions]
  /// ```
  /// {@endtemplate}
  bool implies(String permission) {
    return permissions.contains(permission) || permissions.contains('*');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProtectionDomain &&
        other.codeSource == codeSource &&
        _listEquals(other.permissions, permissions) &&
        _listEquals(other.principals, principals);
  }

  @override
  int get hashCode => Object.hash(codeSource, permissions, principals);

  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() => 'ProtectionDomain(codeSource: $codeSource, permissions: $permissions)';
}