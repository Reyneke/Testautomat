import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/drift/app_database.dart';
import 'package:testautomat_proto/data/drift/schema_info.dart';
import 'package:testautomat_proto/data/seed_data.dart';

void main() {
  group('Migrationen und Seeds (E-50, E-52)', () {
    test('legt das Schema an und protokolliert die Version', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final zeilen = await db
          .customSelect(
            'SELECT version, name, applied_at, checksum FROM schema_version',
          )
          .get();

      expect(zeilen, hasLength(1));
      expect(zeilen.single.read<int>('version'), aktuellesSchemaVersion);
      expect(zeilen.single.read<String>('name'), aktuellesSchemaName);
      expect(zeilen.single.read<String>('applied_at'), endsWith('Z'));
      expect(
        zeilen.single.read<String>('checksum'),
        matches(RegExp(r'^[0-9a-f]{64}$')),
      );
    });

    test('legt Tabellen und Indizes an', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final tabellen = await db
          .customSelect("SELECT name FROM sqlite_master WHERE type = 'table'")
          .get();
      final namen = tabellen.map((zeile) => zeile.read<String>('name'));

      expect(
        namen,
        containsAll(<String>[
          'maschine',
          'verkaeufe',
          'preissetting',
          'verkaufszeit',
          'telemetrie',
          'schema_version',
        ]),
      );

      final indizes = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'index' AND name LIKE 'idx_%'",
          )
          .get();

      expect(
        indizes.map((zeile) => zeile.read<String>('name')),
        containsAll(<String>[
          'idx_verkaeufe_maschine_zeit',
          'idx_telemetrie_maschine_zeit',
        ]),
      );
    });

    test(
      'fuellt die Seeds und wiederholt sie beim erneuten Oeffnen nicht',
      () async {
        final verzeichnis = Directory.systemTemp.createTempSync(
          'testautomat_migration',
        );
        addTearDown(() => verzeichnis.deleteSync(recursive: true));
        final datei = File(
          '${verzeichnis.path}${Platform.pathSeparator}test.sqlite',
        );

        final ersterLauf = AppDatabase(NativeDatabase(datei));
        final ersteZaehlung = await _zaehle(ersterLauf);
        await ersterLauf.close();

        final zweiterLauf = AppDatabase(NativeDatabase(datei));
        final zweiteZaehlung = await _zaehle(zweiterLauf);
        await zweiterLauf.close();

        expect(ersteZaehlung['maschine'], 1);
        expect(ersteZaehlung['preissetting'], 1);
        expect(ersteZaehlung['verkaufszeit'], 7);
        expect(ersteZaehlung['telemetrie'], SeedData.telemetriePunkte);
        expect(ersteZaehlung['schema_version'], 1);
        expect(zweiteZaehlung, ersteZaehlung);
      },
    );

    test('passt zur dokumentierten DDL', () async {
      final db = AppDatabase.memory();
      addTearDown(db.close);

      final ddl = File(schemaDokumentPfad).readAsStringSync();
      final tabellen = RegExp(
        r'CREATE TABLE (\w+) \(([^;]*?)\);',
        dotAll: true,
      ).allMatches(ddl);

      expect(
        tabellen,
        isNotEmpty,
        reason: 'Die dokumentierte DDL wurde nicht gefunden.',
      );

      for (final treffer in tabellen) {
        final name = treffer.group(1)!;
        final spaltenAusDoku = <String>{};
        for (final zeile in treffer.group(2)!.split('\n')) {
          final spalte = RegExp(r'^\s*([a-z_]+)\s+[A-Z]').firstMatch(zeile);
          if (spalte != null) {
            spaltenAusDoku.add(spalte.group(1)!);
          }
        }

        final info = await db.customSelect('PRAGMA table_info($name)').get();
        final spaltenImSchema = info
            .map((zeile) => zeile.read<String>('name'))
            .toSet();

        expect(
          spaltenImSchema,
          containsAll(spaltenAusDoku),
          reason: 'Tabelle $name',
        );
      }
    });
  });
}

Future<Map<String, int>> _zaehle(AppDatabase db) async {
  final ergebnis = <String, int>{};
  for (final tabelle in <String>[
    'maschine',
    'preissetting',
    'verkaufszeit',
    'telemetrie',
    'schema_version',
  ]) {
    final zeile = await db
        .customSelect('SELECT COUNT(*) AS anzahl FROM $tabelle')
        .getSingle();
    ergebnis[tabelle] = zeile.read<int>('anzahl');
  }
  return ergebnis;
}
