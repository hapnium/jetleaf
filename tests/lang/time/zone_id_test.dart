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

import '../dependencies/exceptions.dart';

void main() {
  group('ZoneId', () {
    test('ZoneId.of returns a valid ZoneId with correct id', () {
      final zone = ZoneId.of('America/New_York');
      expect(zone.toString(), equals('America/New_York'));
    });

    test('ZoneId.of throws InvalidArgumentException on empty string', () {
      expect(() => ZoneId.of(''), throwsInvalidArgumentException);
    });

    test('ZoneId.systemDefault returns a valid ZoneId', () {
      final systemZone = ZoneId.systemDefault();
      expect(systemZone.toString(), isNotEmpty);
    });

    test('Predefined static ZoneIds have correct IDs', () {
      expect(ZoneId.UTC.toString(), equals('UTC'));
      expect(ZoneId.GMT.toString(), equals('GMT'));
      expect(ZoneId.EST.toString(), equals('EST'));
      expect(ZoneId.AMERICA_NEW_YORK.toString(), equals('America/New_York'));
      expect(ZoneId.EUROPE_LONDON.toString(), equals('Europe/London'));
      expect(ZoneId.ASIA_TOKYO.toString(), equals('Asia/Tokyo'));
      expect(ZoneId.AFRICA_NAIROBI.toString(), equals('Africa/Nairobi'));
      expect(ZoneId.AUSTRALIA_SYDNEY.toString(), equals('Australia/Sydney'));
    });

    test('ZoneId.toString returns correct value', () {
      final zone = ZoneId.of('Asia/Kolkata');
      expect(zone.toString(), equals('Asia/Kolkata'));
    });
  });
}