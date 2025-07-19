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

import 'package:jetleaf/core.dart';

import 'check.dart';
import 'combine.dart';
import 'check_in.dart' as checker;

void main(List<String> args) {
  JetApplication.run(Main, args);
}

@JetLeafApplication()
class Main {
  final Check check;
  final Combine combine;
  final checker.Check check_in;

  Main(this.check, this.combine, this.check_in);

  void run() {
    check.check();
    combine.combine();
    check_in.name;
  }
}