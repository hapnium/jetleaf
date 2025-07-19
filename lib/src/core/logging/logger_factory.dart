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

import 'package:jetleaf/lang.dart';
import 'package:jetleaf/logging.dart';

/// The log content.
/// 
/// This is a map of key-value pairs representing the log content.
typedef LogContent = Map<String, dynamic>;

/// The log details.
/// 
/// This is a map of key-value pairs representing the log details.
typedef _LogDetails = Map<DateTime, LogContent>;

/// The log information.
/// 
/// This is a map of key-value pairs representing the log information.
typedef _LogInformation = Map<LogLevel, _LogDetails>;

/// The log entry.
/// 
/// This is a map of key-value pairs representing the log entry.
typedef LogEntry = Map<String, _LogInformation>;

/// {@template logger_factory}
/// A base class for building structured logging mechanisms within Jet-based applications.
///
/// This class provides an in-memory logging facility with support for multiple [LogLevel]s.
/// Subclasses can extend this base to implement custom logging strategies (e.g., file, console, remote).
///
/// Each logger instance is tagged with a custom [tag] to allow filtering or identification in composite logs.
///
/// ### Usage
///
/// Extend this class to build a concrete logger:
/// ```dart
/// class ConsoleLogger extends LoggerFactory {
///   ConsoleLogger(String tag) : super(tag);
///
///   void flush() {
///     _logs.forEach((level, messages) {
///       for (final message in messages) {
///         print('[$tag][$level] $message');
///       }
///     });
///   }
/// }
/// ```
///
/// Then use:
/// ```dart
/// final logger = ConsoleLogger("MyService");
/// logger.add(LogLevel.info, "Service started.");
/// logger.add(LogLevel.error, "Something went wrong.");
/// logger.flush();
/// ```
///
/// {@endtemplate}
abstract class LoggerFactory {
  /// A custom label or category used to identify the logger instance.
  ///
  /// Commonly used to associate logs with a specific class, service, or module.
  final String tag;

  /// Whether the logger can publish logs to the console.
  final bool canPublish;

  /// Internal log storage mapping each [LogLevel] to a list of log messages.
  _LogInformation _logs;

  /// Internal log entry storage mapping each [tag] to a list of log messages.
  /// 
  /// Mostly used when combining multiple loggers, in order to keep track of logs per tags.
  LogEntry _superEntry = {};

  /// Constructs the logger factory with the given [tag].
  ///
  /// Initializes an empty log store for all levels.
  /// 
  /// {@macro logger_factory}
  LoggerFactory(this.tag, {this.canPublish = true}) : _logs = {
    LogLevel.INFO: {},
    LogLevel.WARN: {},
    LogLevel.ERROR: {},
    LogLevel.DEBUG: {},
    LogLevel.FATAL: {},
    LogLevel.OFF: {},
    LogLevel.TRACE: {},
  };

  /// Whether the logger is allowed to publish logs to the console.
  /// 
  /// This is used to determine whether the logger should publish or store logs to the console/factory.
  /// 
  /// {@macro logger_factory}
  bool get isAllowed => true;

  /// Adds a [message] to the log buffer under the specified [level].
  ///
  /// If the level already contains entries, the new message is appended.
  ///
  /// Example:
  /// ```dart
  /// logger.add(LogLevel.debug, "Fetching user profile...");
  /// ```
  /// 
  /// If [canPublish] is true, the log is published to the console.
  /// 
  /// If [canPublish] is false, the log is stored in the internal log buffer.
  /// 
  /// {@macro logger_factory}
  void add(LogLevel level, String message, {Object? error, StackTrace? stacktrace}) {
    if(!isAllowed) {
      return;
    }

    final timestamp = DateTime.now();

    if(canPublish){
      // if(isInitialized) {
      //   context.logListener.onLog(level, message, tag, error: error, stacktrace: stacktrace);
      // }
    } else {
      _logs.update(
        level,
        (details) => details..add(timestamp, _prepareContent(message, error: error, stacktrace: stacktrace)),
        ifAbsent: () => {timestamp: _prepareContent(message, error: error, stacktrace: stacktrace)},
      );
    }
  }

  /// Prepares a log content.
  /// 
  /// This method takes a [message] and optional [error] and [stacktrace],
  /// and returns a map containing the log content.
  /// 
  /// {@macro logger_factory}
  LogContent _prepareContent(String message, {Object? error, StackTrace? stacktrace}) {
    LogContent content = {
      "message": message,
    };

    if(error != null) {
      content["error"] = error;
    }

    if(stacktrace != null) {
      content["stacktrace"] = stacktrace;
    }

    return content;
  }

  /// Returns the log entry for the current logger.
  /// 
  /// This is mostly used when combining multiple loggers, in order to keep track of logs per tags. 
  /// 
  /// {@macro logger_factory}
  LogEntry get entry => {tag: _logs};

  /// Adds all logs from the given [entry] to the internal super entry buffer.
  /// 
  /// This is mostly used when combining multiple loggers, in order to keep track of logs per tags. 
  /// 
  /// {@macro logger_factory}
  void addAll(LogEntry entry) {
    _superEntry.addAll(entry);
  }

  /// Clears all logs from every [LogLevel].
  ///
  /// Useful for resetting the internal state or reusing the logger.
  ///
  /// Example:
  /// ```dart
  /// logger.clear(); // Empties all stored logs
  /// ```
  void clear() {
    _logs = {
      LogLevel.INFO: {},
      LogLevel.WARN: {},
      LogLevel.ERROR: {},
      LogLevel.DEBUG: {},
      LogLevel.FATAL: {},
      LogLevel.OFF: {},
      LogLevel.TRACE: {},
    };

    _superEntry = {};
  }

  /// Publishes all logs to the console.
  /// 
  /// This method iterates through all log levels and their associated messages,
  /// and publishes them to the console if [canPublish] is false.
  /// 
  /// Example:
  /// ```dart
  /// logger.publish();
  /// ```
  /// 
  /// This is mostly used when the extending class was initially created with [canPublish] set to false.
  void publish() {
    if(canPublish.isFalse) {
      if(_logs.isNotEmpty) {
        _logs.forEach((LogLevel level, _LogDetails details) {
          details.forEach((timestamp, content) {
            // if(isInitialized) {
            //   context.logListener.onLog(level, getMessage(content), tag, error: getError(content), stacktrace: getStackTrace(content));
            // }
          });
        });
      }

      if(_superEntry.isNotEmpty) {
        _superEntry.forEach((tag, details) {
          details.forEach((level, updates) {
            updates.forEach((timestamp, content) {
              // if(isInitialized) {
              //   context.logListener.onLog(level, getMessage(content), tag, error: getError(content), stacktrace: getStackTrace(content));
              // }
            });
          });
        });
      }

      clear();
    }
  }

  /// Returns the message from the given [content].
  /// 
  /// {@macro logger_factory}
  String getMessage(LogContent content) {
    return content["message"];
  }

  /// Returns the error from the given [content].
  /// 
  /// {@macro logger_factory}
  Object? getError(LogContent content) {
    return content["error"];
  }

  /// Returns the stack trace from the given [content].
  /// 
  /// {@macro logger_factory}
  StackTrace? getStackTrace(LogContent content) {
    return content["stacktrace"];
  }
}