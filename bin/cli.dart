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

import '../cli/runner/cli_runner.dart';
import '../cli/runner/_cli_runner.dart';

/// JetLeaf CLI - Entry point for building and running JetLeaf applications
/// 
/// Usage:
/// dart jl --use=dev     # Development mode (no build)
/// dart jl --use=builder # Build and run mode
/// dart jl --file=custom.dill --force
void main(List<String> arguments) async {
  print(r'''
🍃      _      _   _                __  ______  
🍃     | | ___| |_| |    ___  __ _ / _| \ \ \ \ 
🍃  _  | |/ _ \ __| |   / _ \/ _` | |_   \ \ \ \
🍃 | |_| |  __/ |_| |__|  __/ (_| |  _|  / / / /
🍃  \___/ \___|\__|_____\___|\__,_|_|   /_/_/_/ 
🍃''');

  CliRunner runner = CliRunnerImpl();
  await runner.run(arguments);
}