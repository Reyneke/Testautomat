// Globaler Zustand: Standardwerte, Reset, Uhr-Takt und Zugang (E-46, U-51).

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/state/app_debug.dart';
import 'package:testautomat_proto/state/app_state.dart';

import '../support/app_test_helpers.dart';

void main() {
  test('AppState startet mit den Standardwerten', () {
    final zustand = zustandFrisch();

    expect(zustand.themeMode.value, ThemeMode.dark);
    expect(zustand.locale.value.languageCode, 'de');
    expect(zustand.maschine.value, isNull);
    expect(zustand.debugAngemeldet.value, isFalse);
    expect(zustand.clock.laeuft, isFalse);
  });

  test('AppState.reset setzt alles zurueck', () {
    final zustand = AppState();
    zustand.themeMode.value = ThemeMode.light;
    zustand.locale.value = const Locale('en');
    zustand.debugAngemeldet.value = true;
    zustand.clock.start();

    zustand.reset();

    expect(zustand.themeMode.value, ThemeMode.dark);
    expect(zustand.locale.value.languageCode, 'de');
    expect(zustand.maschine.value, isNull);
    expect(zustand.debugAngemeldet.value, isFalse);
    expect(zustand.clock.laeuft, isFalse);
  });

  test('nur unterstuetzte Sprachen werden uebernommen', () {
    final zustand = AppState();

    zustand.setLocale(const Locale('fr'));
    expect(zustand.locale.value.languageCode, 'de');

    zustand.setLocale(const Locale('en'));
    expect(zustand.locale.value.languageCode, 'en');
  });

  test('die Debug-PIN schaltet nur bei richtiger Eingabe frei', () {
    final zustand = AppState();

    expect(zustand.pruefeDebugPin('0000'), isFalse);
    expect(zustand.debugAngemeldet.value, isFalse);

    expect(zustand.pruefeDebugPin(AppDebug.pin), isTrue);
    expect(zustand.debugAngemeldet.value, isTrue);

    zustand.debugAbmelden();
    expect(zustand.debugAngemeldet.value, isFalse);
  });

  test('der Uhr-Takt laeuft mit Nutzern und endet beim letzten', () {
    final zustand = AppState();

    zustand.clock.start();
    zustand.clock.start();
    expect(zustand.clock.laeuft, isTrue);

    zustand.clock.stop();
    expect(zustand.clock.laeuft, isTrue, reason: 'ein Nutzer ist noch aktiv');

    zustand.clock.stop();
    expect(zustand.clock.laeuft, isFalse);
  });

  testWidgets('nach dem Abraeumen des Bildschirms laeuft kein Timer mehr', (
    tester,
  ) async {
    final zustand = await pumpeApp(tester);
    expect(zustand.clock.laeuft, isTrue);

    await beendeApp(tester);

    expect(zustand.clock.laeuft, isFalse);
  });

  test('Bearbeitungsrechte haengen am Build-Modus (E-22)', () {
    expect(AppDebug.bearbeitungErlaubt(release: false), isTrue);
    expect(AppDebug.bearbeitungErlaubt(release: true), isFalse);
    expect(AppDebug.bearbeitungErlaubtImBuild, isTrue);
  });
}
