import 'interface.dart';
import 'manager.dart';
import 'exceptions.dart';

/// {@template jet_asset_bundler}
/// A configurable asset bundler for loading files from Dart packages.
/// 
/// This bundler can be configured to load assets from any Dart package,
/// making it flexible for different use cases. It provides a clean API
/// for loading package assets with proper error handling and caching.
/// 
/// Example usage:
/// ```dart
/// // For JetLeaf package
/// final jetBundler = JetLeafBundler.forPackage('jetleaf');
/// final html = await jetBundler.load('resources/html/404.html');
/// 
/// // For custom package
/// final myBundler = JetLeafBundler.forPackage('my_package');
/// final config = await myBundler.load('config/settings.json');
/// ```
/// {@endtemplate}
class JetLeafBundler implements BundlerInterface {
  final BundlerManager _manager;

  /// Creates a new asset bundler for the specified package.
  /// 
  /// [packageName] - The name of the package to load assets from
  JetLeafBundler._(this._manager);

  /// Creates a new asset bundler for the specified package.
  /// 
  /// [packageName] - The name of the package to load assets from
  /// 
  /// Returns a configured [JetLeafBundler] instance.
  factory JetLeafBundler.forPackage(String packageName) {
    final manager = BundlerManager(packageName);
    return JetLeafBundler._(manager);
  }

  /// Creates a new asset bundler specifically for the JetLeaf package.
  /// 
  /// This is a convenience factory for the most common use case.
  /// 
  /// Returns a [JetLeafBundler] configured for the 'jetleaf' package.
  factory JetLeafBundler.forJetLeaf() {
    return JetLeafBundler.forPackage('jetleaf');
  }

  @override
  Future<String> load(String relativePath) async {
    try {
      return await _manager.loadAsset(relativePath);
    } catch (e) {
      throw BundlerException('Failed to load asset: $relativePath', relativePath, e);
    }
  }

  @override
  Future<bool> exists(String relativePath) async {
    try {
      return await _manager.assetExists(relativePath);
    } catch (e) {
      return false;
    }
  }

  @override
  void clearCache() {
    _manager.clearCache();
  }

  @override
  Future<String?> getPackageRoot() async {
    return await _manager.getPackageRoot();
  }

  @override
  String get packageName => _manager.packageName;
}

/// {@template jetleaf_leaf_bundler}
/// The default asset bundler used by JetLeaf to load internal framework assets.
///
/// This is typically used to resolve HTML templates, static files, and other
/// bundled resources that are shipped with JetLeaf itself.
///
/// It uses the `Platform.script` or similar runtime metadata to locate
/// assets relative to the JetLeaf package.
///
/// Example:
/// ```dart
/// final html = await jetLeafBundler.loadAsString('errors/404.html');
/// ```
/// {@endtemplate}
final BundlerInterface jetLeafBundler = JetLeafBundler.forJetLeaf();

/// {@template jetleaf_root_bundler}
/// Creates an asset bundler for a user-defined package.
///
/// This allows you to load assets (e.g. templates, partials, config files)
/// from your own project's `lib/`, `assets/`, or other accessible folders
/// using the package's declared name.
///
/// [packageName] must match the name defined in your `pubspec.yaml`.
///
/// Example:
/// ```dart
/// final bundler = rootBundler('my_app');
/// final template = await bundler.loadAsString('templates/welcome.html');
/// ```
///
/// Throws a [BundlerException] if the asset cannot be located or loaded.
/// {@endtemplate}
///
/// - [packageName]: The name of the Dart package to resolve assets from.
/// - Returns a [BundlerInterface] for loading assets in that package.
BundlerInterface rootBundler(String packageName) => JetLeafBundler.forPackage(packageName);