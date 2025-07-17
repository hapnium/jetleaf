/// General exception for language related errors.
/// 
/// Example usage:
/// ```dart
/// try {
///   throw LangException('Invalid argument');
/// } catch (e) {
///   print(e); // LangException: Invalid argument
/// }
/// ```
class LangException implements Exception {
  /// The error message
  final String message;
  
  /// The underlying cause of this exception, if any.
  final Object? cause;

  LangException(this.message, {this.cause});
  
  @override
  String toString() => 'LangException: $message';
}

/// Exception thrown when an invalid argument is provided.
/// 
/// Example usage:
/// ```dart
/// try {
///   throw InvalidArgumentException('Invalid argument');
/// } catch (e) {
///   print(e); // InvalidArgumentException: Invalid argument
/// }
/// ```
class InvalidArgumentException extends LangException {
  InvalidArgumentException(super.message, {super.cause});
  
  @override
  String toString() => 'InvalidArgumentException: $message';
}

/// Exception thrown when an invalid format is provided.
/// 
/// Example usage:
/// ```dart
/// try {
///   throw InvalidFormatException('Invalid format');
/// } catch (e) {
///   print(e); // InvalidFormatException: Invalid format
/// }
/// ```
class InvalidFormatException extends LangException {
  InvalidFormatException(super.message, {super.cause});
  
  @override
  String toString() => 'InvalidFormatException: $message';
}

/// Exception thrown when a guarantee is not met. Mostly used to behave like [NoGuaranteeException]
/// 
/// Example usage:
/// ```dart
/// try {
///   throw NoGuaranteeException('No guarantee');
/// } catch (e) {
///   print(e); // NoGuaranteeException: No guarantee
/// }
/// ```
class NoGuaranteeException extends LangException {
  NoGuaranteeException(super.message, {super.cause});
  
  @override
  String toString() => 'NoGuaranteeException: $message';
}

/// Exception thrown when an I/O operation fails.
/// 
/// This is the base class for all I/O-related exceptions in the streams library.
/// It provides information about what went wrong during an I/O operation.
/// 
/// ## Example Usage
/// ```dart
/// try {
///   final input = FileInputStream('nonexistent.txt');
///   await input.read(buffer);
/// } catch (e) {
///   if (e is IOException) {
///     print('I/O error: ${e.message}');
///     if (e.cause != null) {
///       print('Caused by: ${e.cause}');
///     }
///   }
/// }
/// ```
class IOException implements Exception {
  /// The error message describing what went wrong.
  final String message;
  
  /// The underlying cause of this exception, if any.
  final Object? cause;
  
  /// Creates a new [IOException] with the given [message] and optional [cause].
  /// 
  /// ## Parameters
  /// - [message]: A description of the error
  /// - [cause]: The underlying exception that caused this error (optional)
  /// 
  /// ## Example
  /// ```dart
  /// throw IOException('Failed to read file', FileSystemException('File not found'));
  /// ```
  const IOException(this.message, [this.cause]);
  
  @override
  String toString() {
    if (cause != null) {
      return 'IOException: $message\nCaused by: $cause';
    }
    return 'IOException: $message';
  }
}

/// Exception thrown when an attempt is made to use a stream that has been closed.
/// 
/// This exception is thrown when operations are attempted on streams that have
/// already been closed and are no longer available for I/O operations.
/// 
/// ## Example Usage
/// ```dart
/// final input = FileInputStream('data.txt');
/// await input.close();
/// 
/// try {
///   await input.read(buffer); // This will throw StreamClosedException
/// } catch (e) {
///   if (e is StreamClosedException) {
///     print('Stream is already closed');
///   }
/// }
/// ```
class StreamClosedException extends IOException {
  /// Creates a new [StreamClosedException] with an optional [message].
  /// 
  /// ## Parameters
  /// - [message]: Optional custom message (defaults to standard message)
  /// 
  /// ## Example
  /// ```dart
  /// throw StreamClosedException('Input stream was closed unexpectedly');
  /// ```
  const StreamClosedException([String? message]) : super(message ?? 'Stream has been closed');
}

/// Exception thrown when the end of a stream is reached unexpectedly.
/// 
/// This exception indicates that an operation expected more data but the
/// end of the stream was encountered.
/// 
/// ## Example Usage
/// ```dart
/// try {
///   final data = await input.readFully(1024); // Expects exactly 1024 bytes
/// } catch (e) {
///   if (e is EndOfStreamException) {
///     print('Reached end of stream before reading all expected data');
///   }
/// }
/// ```
class EndOfStreamException extends IOException {
  /// Creates a new [EndOfStreamException] with an optional [message].
  /// 
  /// ## Parameters
  /// - [message]: Optional custom message (defaults to standard message)
  /// 
  /// ## Example
  /// ```dart
  /// throw EndOfStreamException('Expected 1024 bytes but only 512 available');
  /// ```
  const EndOfStreamException([String? message]) : super(message ?? 'End of stream reached');
}