import 'dart:math' as math;

import 'package:jetleaf/lang.dart';
import 'package:jetleaf/logging.dart';
import 'package:jetleaf/reflection.dart';

import '../../env/environment.dart';
import 'banner.dart';

final class JetLeafBanner implements Banner {
  static final String BANNER = r'''
🍃      _      _   _                __  ______  
🍃     | | ___| |_| |    ___  __ _ / _| \ \ \ \ 
🍃  _  | |/ _ \ __| |   / _ \/ _` | |_   \ \ \ \
🍃 | |_| |  __/ |_| |__|  __/ (_| |  _|  / / / /
🍃  \___/ \___|\__|_____\___|\__,_|_|   /_/_/_/ 
🍃                                              
''';

	static final String JET_LEAF = " || 🍃 JetLeaf || ";

	static final int STRAP_LINE_SIZE = 42;

  @override
  void printBanner(Environment environment, Class<Object> sourceClass, PrintStream printStream) {
    printStream.println();
    printStream.println(BANNER);

    // String version = " (v${JetLeafVersion.getVersion()})";
    // final int paddingSize = math.max(0, STRAP_LINE_SIZE - (JET_LEAF.length + version.length));
    // final String padding = ' ' * paddingSize;

		// printStream.println(AnsiOutput.apply(AnsiColor.GREEN,'$JET_LEAF$padding') + AnsiOutput.apply(AnsiColor.GRAY, version));
		// printStream.println();
  }
}