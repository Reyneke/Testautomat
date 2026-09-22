// Sprachauswahl: unterstuetzte Sprachen und Systemeinstellung (E-08, E-19, U-70).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/l10n/app_locale.dart';

void main() {
  group('Sprachen (E-06, E-08)', () {
    test('Deutsch und Englisch sind unterstuetzt', () {
      expect(AppLocale.unterstuetzt(const Locale('de')), isTrue);
      expect(AppLocale.unterstuetzt(const Locale('en')), isTrue);
      expect(AppLocale.unterstuetzt(const Locale('fr')), isFalse);
    });

    test('Englisch wird erkannt, auch mit Region', () {
      expect(AppLocale.istEnglisch(const Locale('en')), isTrue);
      expect(AppLocale.istEnglisch(const Locale('en', 'US')), isTrue);
      expect(AppLocale.istEnglisch(const Locale('de')), isFalse);
    });
  });

  group('Systemsprache beim ersten Start (E-19)', () {
    test('eine unterstuetzte Systemsprache wird uebernommen', () {
      expect(AppLocale.vomSystem(const Locale('en')), const Locale('en'));
      expect(AppLocale.vomSystem(const Locale('en', 'US')), const Locale('en'));
      expect(AppLocale.vomSystem(const Locale('de', 'DE')), const Locale('de'));
    });

    test('alles andere faellt auf Deutsch zurueck', () {
      expect(AppLocale.vomSystem(const Locale('fr')), AppLocale.fallbackLocale);
      expect(AppLocale.vomSystem(null), AppLocale.fallbackLocale);
    });
  });
}
