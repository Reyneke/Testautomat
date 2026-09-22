// intl-Formatierung: Datum und Uhrzeit folgen der Sprache (E-18, U-70).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/l10n/app_format.dart';

void main() {
  final vormittag = DateTime(2026, 9, 18, 8, 5);
  final nachmittag = DateTime(2026, 9, 18, 17, 30);

  group('intl-Formatierung (E-18)', () {
    test('Deutsch: 24-Stunden-Format und Punktdatum', () {
      expect(AppFormat.zeit(vormittag, const Locale('de')), '08:05');
      expect(AppFormat.zeit(nachmittag, const Locale('de')), '17:30');
      // CLDR schreibt das deutsche Datum ohne fuehrende Nullen (d.M.y).
      expect(AppFormat.datum(vormittag, const Locale('de')), '18.9.2026');
    });

    test('Englisch: 12-Stunden-Format mit AM/PM', () {
      final morgens = AppFormat.zeit(vormittag, const Locale('en'));
      expect(morgens, contains('AM'));
      expect(morgens, contains('8:05'));

      final abends = AppFormat.zeit(nachmittag, const Locale('en'));
      expect(abends, contains('PM'));
      expect(abends, contains('5:30'));
    });

    test('Englisch: Monat vor Tag im Datum', () {
      expect(AppFormat.datum(vormittag, const Locale('en')), contains('2026'));
      expect(
        AppFormat.datum(vormittag, const Locale('en')),
        startsWith('9/18'),
        reason: 'Englisch schreibt den Monat zuerst (M/d/y).',
      );
    });

    test('unbekannte Sprache faellt auf Deutsch zurueck', () {
      expect(AppFormat.zeit(vormittag, const Locale('fr')), '08:05');
      expect(AppFormat.datum(vormittag, const Locale('fr')), '18.9.2026');
    });

    test('die Sprachkuerzel sind de oder en', () {
      expect(AppFormat.sprachkuerzel(const Locale('de')), 'de');
      expect(AppFormat.sprachkuerzel(const Locale('en')), 'en');
      expect(AppFormat.sprachkuerzel(const Locale('en', 'US')), 'en');
      expect(AppFormat.sprachkuerzel(const Locale('fr')), 'de');
    });
  });
}
