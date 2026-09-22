// Gemerkte Einstellungen: Theme und Sprache ueberleben einen Neustart (E-20, U-70).

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/state/app_state.dart';
import 'package:testautomat_proto/state/settings_store.dart';

void main() {
  late Directory ordner;

  setUp(() async {
    ordner = await Directory.systemTemp.createTemp('testautomat_settings_');
  });

  tearDown(() {
    if (ordner.existsSync()) {
      ordner.deleteSync(recursive: true);
    }
  });

  SettingsStore store() => SettingsStore(verzeichnis: () async => ordner);

  group('Ablage der Einstellungen (E-20)', () {
    test('schreibt Theme und Sprache und liest sie wieder ein', () async {
      final einstellungen = store();
      await einstellungen.speichere(
        const AppSettings(themeMode: ThemeMode.light, locale: Locale('en')),
      );

      expect(
        File(
          '${ordner.path}${Platform.pathSeparator}settings.json',
        ).existsSync(),
        isTrue,
      );

      final gelesen = await store().lade();
      expect(
        gelesen,
        const AppSettings(themeMode: ThemeMode.light, locale: Locale('en')),
      );
    });

    test('ohne Ablage kommt null zurueck (erster Start)', () async {
      expect(await store().lade(), isNull);
    });

    test('eine unlesbare Ablage blockiert den Start nicht', () async {
      final datei = File(
        '${ordner.path}${Platform.pathSeparator}settings.json',
      );
      datei.writeAsStringSync('kein gueltiges json {');

      expect(await store().lade(), isNull);
    });

    test('unbekannte Werte fallen auf die Standardwerte zurueck', () async {
      final datei = File(
        '${ordner.path}${Platform.pathSeparator}settings.json',
      );
      datei.writeAsStringSync('{"themeMode":"neon","language":"fr"}');

      expect(await store().lade(), const AppSettings());
    });

    test('binden merkt jede Aenderung am Zustand', () async {
      final einstellungen = store();
      final zustand = AppState()..reset();

      einstellungen.binde(zustand);
      zustand.setzeThemeMode(ThemeMode.light);
      await einstellungen.letzterAuftrag;
      expect((await store().lade())?.themeMode, ThemeMode.light);

      zustand.setLocale(const Locale('en'));
      await einstellungen.letzterAuftrag;
      expect((await store().lade())?.locale, const Locale('en'));

      einstellungen.loese();
      await einstellungen.letzterAuftrag;
      zustand.setzeThemeMode(ThemeMode.system);
      await Future<void>.delayed(Duration.zero);
      expect(
        (await store().lade())?.themeMode,
        ThemeMode.light,
        reason: 'nach loese() wird nichts mehr gemerkt',
      );
    });
  });
}
