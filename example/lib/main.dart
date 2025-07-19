import 'package:jetleaf/core.dart';

import 'check.dart';

void main(List<String> args) {
  JetApplication.run(Main, args);
}

@JetLeafApplication()
class Main {
  final Check check;

  Main(this.check);

  void run() {
    check.check();
  }
}