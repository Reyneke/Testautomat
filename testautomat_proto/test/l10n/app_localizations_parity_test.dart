// i18n-Paritaet: de und en muessen dieselben Schluessel tragen (E-39, U-70).
//
// Seit der ARB-Migration (E-17) sind die ARB-Dateien die Quelle der Texte;
// geprueft wird deshalb direkt an ihnen (der Generator meldet zusaetzlich
// fehlende Uebersetzungen beim Erzeugen).

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/l10n/app_localizations.dart';

Map<String, Object?> _arb(String sprache) {
  final inhalt = File('lib/l10n/arb/app_$sprache.arb').readAsStringSync();
  return jsonDecode(inhalt) as Map<String, Object?>;
}

void main() {
  final de = _arb('de');
  final en = _arb('en');

  final deSchluessel = de.keys.where((k) => !k.startsWith('@')).toSet();
  final enSchluessel = en.keys.where((k) => !k.startsWith('@')).toSet();

  group('i18n-Paritaet de/en (E-39)', () {
    test('beide Sprachen tragen dieselben Schluessel', () {
      final nurEn = enSchluessel.difference(deSchluessel);
      final nurDe = deSchluessel.difference(enSchluessel);

      expect(nurEn, isEmpty, reason: 'Nur in en vorhanden: $nurEn');
      expect(nurDe, isEmpty, reason: 'Nur in de vorhanden: $nurDe');
    });

    test('kein Wert ist leer', () {
      for (final sprache in <String>['de', 'en']) {
        final werte = _arb(sprache);
        for (final eintrag in werte.entries) {
          if (eintrag.key.startsWith('@')) {
            continue;
          }
          expect(
            (eintrag.value as String).trim(),
            isNotEmpty,
            reason: '$sprache.${eintrag.key}',
          );
        }
      }
    });

    test('die Schluesselmenge bleibt vollstaendig', () {
      expect(deSchluessel.length, greaterThanOrEqualTo(70));
      expect(enSchluessel.length, deSchluessel.length);
    });

    test('Getter liefern echte Texte statt Schluesselnamen', () {
      for (final sprache in <String>['de', 'en']) {
        final texte = lookupAppLocalizations(Locale(sprache));
        expect(texte.appTitle, isNot('appTitle'));
        expect(texte.startSale, isNot('startSale'));
        expect(texte.weiter, isNot('weiter'));
        expect(texte.debugTitle, isNot('debugTitle'));
        expect(texte.zahlungsartBar, isNot('zahlungsartBar'));
        expect(texte.automatAusserBetrieb, isNot('automatAusserBetrieb'));
      }
    });

    test('nicht unterstuetzte Sprachen lehnt der Delegat ab', () {
      expect(
        AppLocalizations.delegate.isSupported(const Locale('fr')),
        isFalse,
      );
      expect(AppLocalizations.delegate.isSupported(const Locale('de')), isTrue);
      expect(AppLocalizations.delegate.isSupported(const Locale('en')), isTrue);
    });

    test('die Sprachen unterscheiden sich inhaltlich', () {
      expect(de['startSale'], isNot(en['startSale']));
      expect(de['belegTitle'], isNot(en['belegTitle']));
    });

    test('die erzeugten Klassen kennen beide Sprachen', () {
      expect(AppLocalizations.supportedLocales, hasLength(2));
      expect(
        AppLocalizations.supportedLocales.map((locale) => locale.languageCode),
        containsAll(<String>['de', 'en']),
      );
    });
  });
}
