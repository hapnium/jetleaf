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

import '../command_line/command_line_args.dart';
import 'property_source.dart';

/// {@template simple_command_line_property_source}
/// A [PropertySource] implementation that wraps [CommandLineArgs] to expose
/// command-line arguments as resolvable properties.
///
/// This class treats each command-line option as a property key. If an option
/// has multiple values, the property will return a list. If the option has
/// exactly one value, it returns that single value. If no value exists for
/// the option, it returns `null`.
///
/// This is useful for supporting `--option=value` or `--option value`-style
/// flags during application startup.
///
/// ### Example usage:
///
/// ```dart
/// final args = CommandLineArgs();
/// args.addOptionArg('env', 'dev');
/// args.addOptionArg('debug', 'true');
/// args.addOptionArg('list', 'a');
/// args.addOptionArg('list', 'b');
///
/// final propertySource = SimpleCommandLinePropertySource('cli', args);
///
/// print(propertySource.getProperty('env'));   // dev
/// print(propertySource.getProperty('debug')); // true
/// print(propertySource.getProperty('list'));  // [a, b]
/// ```
///
/// Typically used in combination with [MutablePropertySources] for integration
/// into a property resolution system like [PropertySourcesPropertyResolver].
/// {@endtemplate}
class SimpleCommandLinePropertySource extends PropertySource<CommandLineArgs> {
  /// {@macro simple_command_line_property_source}
  SimpleCommandLinePropertySource(String name, CommandLineArgs source) : super(name, source);

  @override
  bool containsProperty(String name) => source.containsOption(name);

  @override
  Object? getProperty(String name) {
    final values = source.getOptionValues(name);
    if (values == null || values.isEmpty) return null;
    return values.length == 1 ? values.first : values;
  }
}