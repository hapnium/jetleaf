/// {@template bundler_exception}
/// An exception thrown when an asset cannot be loaded by the JetLeaf bundler.
///
/// This exception typically occurs when trying to read or resolve a file
/// that does not exist, is inaccessible, or fails during the bundling process.
///
/// The [assetPath] provides the full relative or absolute path of the asset
/// that failed to load, and the optional [cause] can point to the underlying
/// exception that triggered the failure.
///
/// Example usage:
/// ```dart
/// throw AssetLoaderException('Failed to load template', 'templates/home.html');
/// ```
/// {@endtemplate}
class AssetLoaderException implements Exception {
  /// The error message
  final String message;
  
  /// The underlying cause of this exception, if any.
  final Object? cause;

  /// The full path to the asset that could not be loaded.
  final String assetPath;

  /// {@macro bundler_exception}
  ///
  /// - [message]: A human-readable error message describing the failure.
  /// - [assetPath]: The relative or absolute path of the asset.
  /// - [cause]: (Optional) The underlying cause of the error.
  AssetLoaderException(this.message, this.assetPath, [this.cause]);

  /// Returns a human-readable string representation of the exception,
  /// including the asset path and the underlying cause, if present.
  @override
  String toString() {
    final buffer = StringBuffer('AssetLoaderException: $message');
    buffer.writeln('\nAsset path: $assetPath');
    if (cause != null) {
      buffer.writeln('Caused by: $cause');
    }
    return buffer.toString();
  }
}