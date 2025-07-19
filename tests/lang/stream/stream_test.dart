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

import 'package:test/test.dart';
import 'package:jetleaf/lang.dart';

void main() {
  group('Stream', () {
    test('stream creates GenericStream from iterable', () {
      final stream = Streaming.stream([1, 2, 3]);
      expect(stream.toList(), [1, 2, 3]);
    });

    test('intStream creates IntStream from iterable', () {
      final stream = Streaming.intStream([4, 5, 6]);
      expect(stream.toList(), [4, 5, 6]);
    });

    test('doubleStream creates DoubleStream from iterable', () {
      final stream = Streaming.doubleStream([1.1, 2.2]);
      expect(stream.toList(), [1.1, 2.2]);
    });

    test('empty returns empty GenericStream', () {
      final stream = Streaming.empty<String>();
      expect(stream.toList(), isEmpty);
    });

    test('emptyIntStream returns empty IntStream', () {
      final stream = Streaming.emptyIntStream();
      expect(stream.toList(), isEmpty);
    });

    test('emptyDoubleStream returns empty DoubleStream', () {
      final stream = Streaming.emptyDoubleStream();
      expect(stream.toList(), isEmpty);
    });

    test('ofSingle returns stream with one item', () {
      final stream = Streaming.ofSingle('OnlyOne');
      expect(stream.toList(), ['OnlyOne']);
    });

    test('generate creates infinite stream with limit', () {
      int i = 0;
      final stream = Streaming.generate(() => ++i).limit(3);
      expect(stream.toList(), [1, 2, 3]);
    });

    test('iterate applies function repeatedly', () {
      final stream = Streaming.iterate(1, (n) => n * 2).limit(4);
      expect(stream.toList(), [1, 2, 4, 8]);
    });

    test('concat combines two streams', () {
      final a = GenericStream.of([1, 2]);
      final b = GenericStream.of([3, 4]);
      final stream = Streaming.concat(a, b);
      expect(stream.toList(), [1, 2, 3, 4]);
    });

    test('of creates stream from up to 5 values', () {
      final stream = Streaming.of('a', 'b', 'c');
      expect(stream.toList(), ['a', 'b', 'c']);
    });

    test('ofAll creates stream from list', () {
      final stream = Streaming.ofAll([10, 20, 30]);
      expect(stream.toList(), [10, 20, 30]);
    });

    test('builder creates stream via StreamBuilder', () {
      final stream = Streaming.builder<String>()
        ..add('one')
        ..add('two');
      final built = stream.build();
      expect(built.toList(), ['one', 'two']);
    });
  });
}