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

import 'dart:typed_data';

import '../../exceptions.dart';
import 'input_stream.dart';

/// {@template byte_array_input_stream}
/// A byte-based input stream that reads from a [Uint8List] buffer.
///
/// `ByteArrayInputStream` provides a non-blocking, in-memory implementation of
/// the [InputStream] interface over a Dart [Uint8List]. It's particularly useful
/// for:
///
/// - Testing input-based logic without relying on external files or sockets.
/// - Wrapping encoded or serialized in-memory data for streaming processing.
/// - Implementing low-latency input pipelines (e.g., compression, decryption).
///
/// Unlike traditional [Stream]s in Dart, this class offers fine-grained control
/// over the byte cursor, with support for methods like `mark()` and `reset()` if
/// implemented in the extended [InputStream] class.
///
/// ---
///
/// ### 🔧 Example:
/// ```dart
/// final bytes = Uint8List.fromList([104, 101, 108, 108, 111]); // "hello"
/// final inputStream = ByteArrayInputStream(bytes);
///
/// final char1 = inputStream.read(); // 104 (h)
/// final char2 = inputStream.read(); // 101 (e)
/// ```
///
/// ---
///
/// ### ✅ Use Cases:
/// - Parsing binary data from a known byte array.
/// - Emulating I/O in memory-constrained or test environments.
/// - Providing a readable wrapper for encoded API payloads.
/// {@endtemplate}
class ByteArrayInputStream extends InputStream {
  final Uint8List _buffer;
  int _position = 0;
  int _mark = -1;

  /// {@macro byte_array_input_stream}
  ///
  /// Creates a [ByteArrayInputStream] that reads from the entire [buffer].
  ///
  /// The internal read cursor is set to the beginning of the buffer.
  ByteArrayInputStream(this._buffer);

  /// {@macro byte_array_input_stream}
  ///
  /// Creates a [ByteArrayInputStream] that reads from a slice of the [buffer]
  /// starting at [offset] and spanning [length] bytes.
  ///
  /// This is useful when you want to expose only a portion of a larger buffer
  /// as an input stream.
  ///
  /// Throws a [RangeError] if the slice is out of bounds.
  ByteArrayInputStream.fromRange(Uint8List buffer, int offset, int length)
      : _buffer = buffer.sublist(offset, offset + length);
  
  @override
  Future<int> readByte() async {
    if (isClosed) {
      throw StreamClosedException();
    }
    
    if (_position >= _buffer.length) {
      return -1; // End of stream
    }
    
    return _buffer[_position++];
  }
  
  @override
  Future<int> read(List<int> b, [int offset = 0, int? length]) async {
    if (isClosed) {
      throw StreamClosedException();
    }
    
    length ??= b.length - offset;
    
    if (offset < 0 || length < 0 || offset + length > b.length) {
      throw ArgumentError('Invalid offset or length');
    }
    
    if (length == 0) {
      return 0;
    }
    
    if (_position >= _buffer.length) {
      return -1; // End of stream
    }
    
    final available = _buffer.length - _position;
    final bytesToRead = length < available ? length : available;
    
    for (int i = 0; i < bytesToRead; i++) {
      b[offset + i] = _buffer[_position + i];
    }
    
    _position += bytesToRead;
    return bytesToRead;
  }
  
  @override
  Future<int> available() async {
    if (isClosed) {
      throw StreamClosedException();
    }
    return _buffer.length - _position;
  }
  
  @override
  Future<int> skip(int n) async {
    if (isClosed) {
      throw StreamClosedException();
    }
    
    if (n <= 0) {
      return 0;
    }
    
    final available = _buffer.length - _position;
    final bytesToSkip = n < available ? n : available;
    
    _position += bytesToSkip;
    return bytesToSkip;
  }
  
  @override
  bool markSupported() => true;
  
  @override
  void mark(int readLimit) {
    _mark = _position;
  }
  
  @override
  Future<void> reset() async {
    if (isClosed) {
      throw StreamClosedException();
    }
    
    if (_mark < 0) {
      throw StateError('Mark not set');
    }
    
    _position = _mark;
  }
  
  /// Returns the current position in the buffer.
  int get position => _position;
  
  /// Returns the size of the buffer.
  int get size => _buffer.length;
  
  /// Returns true if all data has been read.
  bool get isAtEnd => _position >= _buffer.length;
}