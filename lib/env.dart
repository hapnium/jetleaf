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

library env;

export 'src/env/command_line/command_line_args.dart';
export 'src/env/command_line/simple_command_line_arg_parser.dart';

export 'src/env/property_resolver/abstract_property_resolver.dart';
export 'src/env/property_resolver/property_resolver.dart';
export 'src/env/property_resolver/property_sources_property_resolver.dart';
export 'src/env/property_resolver/configurable_property_resolver.dart';

export 'src/env/property_source/property_source.dart';
export 'src/env/property_source/map_property_source.dart';
export 'src/env/property_source/properties_property_source.dart';
export 'src/env/property_source/system_environment_property_source.dart';
export 'src/env/property_source/simple_command_line_property_source.dart';
export 'src/env/property_source/mutable_property_sources.dart';

export 'src/env/abstract_environment.dart';
export 'src/env/configurable_environment.dart';
export 'src/env/environment.dart';
export 'src/env/exceptions.dart';
export 'src/env/standard_environment.dart';