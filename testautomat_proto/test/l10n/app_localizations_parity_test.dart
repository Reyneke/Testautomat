// i18n-Paritaet: de und en muessen dieselben Schluessel tragen (E-39).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';

void main() {
  final de = AppLocalizations.werteFuer('de');
  final en = AppLocalizations.werteFuer('en');

  group('i18n-Paritaet de/en (E-39)', () {
    test('beide Sprachen tragen dieselben Schluessel', () {
      final nurEn = en.keys.toSet().difference(de.keys.toSet());
      final nurDe = de.keys.toSet().difference(en.keys.toSet());

      expect(nurEn, isEmpty, reason: 'Nur in en vorhanden: $nurEn');
      expect(nurDe, isEmpty, reason: 'Nur in de vorhanden: $nurDe');
    });

    test('kein Wert ist leer', () {
      for (final eintrag in de.entries) {
        expect(eintrag.value.trim(), isNotEmpty, reason: 'de.${eintrag.key}');
      }
      for (final eintrag in en.entries) {
        expect(eintrag.value.trim(), isNotEmpty, reason: 'en.${eintrag.key}');
      }
    });

    test('die Schluesselmenge bleibt vollstaendig', () {
      expect(de.keys.length, greaterThanOrEqualTo(70));
      expect(en.keys.length, de.keys.length);
    });

    test('Getter liefern echte Texte statt Schluesselnamen', () {
      for (final sprache in <String>['de', 'en']) {
        final texte = AppLocalizations(Locale(sprache));
        expect(texte.appTitle, isNot('appTitle'));
        expect(texte.startSale, isNot('startSale'));
        expect(texte.weiter, isNot('weiter'));
        expect(texte.debugTitle, isNot('debugTitle'));
        expect(texte.zahlungsartBar, isNot('zahlungsartBar'));
        expect(texte.automatAusserBetrieb, isNot('automatAusserBetrieb'));
      }
    });

    test('unbekannte Sprache faellt auf Deutsch zurueck', () {
      final texte = AppLocalizations(const Locale('fr'));
      expect(texte.appTitle, 'Parkautomat Weiden');
    });

    test('die Sprachen unterscheiden sich inhaltlich', () {
      expect(de['startSale'], isNot(en['startSale']));
      expect(de['belegTitle'], isNot(en['belegTitle']));
    });
  });
}
