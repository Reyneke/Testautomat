import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import '../dto.dart';
import '../json_utils.dart';
import '../seed_data.dart';
import 'schema_info.dart';

part 'app_database.g.dart';

/// Automaten-Stammdaten (Tabelle `maschine`).
@DataClassName('MaschineRow')
class Maschinen extends Table {
  @override
  String get tableName => 'maschine';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get geraeteId => text().named('geraete_id').unique()();
  TextColumn get standort => text()();
  TextColumn get status => text().customConstraint(
    "NOT NULL CHECK (status IN ('aktiv', 'inaktiv', 'stoerung'))",
  )();
  TextColumn get kundennummer => text()();
}

/// Simulierte Parkverkaeufe (Tabelle `verkaeufe`).
@TableIndex(
  name: 'idx_verkaeufe_maschine_zeit',
  columns: {#maschineId, #timestamp},
)
@DataClassName('VerkaufRow')
class Verkaeufe extends Table {
  @override
  String get tableName => 'verkaeufe';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get maschineId =>
      integer().named('maschine_id').references(Maschinen, #id)();
  TextColumn get timestamp => text()();
  IntColumn get parkdauerMinuten => integer()
      .named('parkdauer_minuten')
      .customConstraint('NOT NULL CHECK (parkdauer_minuten > 0)')();
  IntColumn get betragCent => integer()
      .named('betrag_cent')
      .customConstraint('NOT NULL CHECK (betrag_cent >= 0)')();
  TextColumn get zahlungsart => text().customConstraint(
    "NOT NULL CHECK (zahlungsart IN ('bar', 'karte'))",
  )();
  IntColumn get belegnummer => integer().unique()();
}

/// Preisregeln (Tabelle `preissetting`).
@DataClassName('PreissettingRow')
class Preissettings extends Table {
  @override
  String get tableName => 'preissetting';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get taktMinuten => integer()
      .named('takt_minuten')
      .customConstraint('NOT NULL CHECK (takt_minuten > 0)')();
  IntColumn get preisProTaktCent => integer()
      .named('preis_pro_takt_cent')
      .customConstraint('NOT NULL CHECK (preis_pro_takt_cent >= 0)')();
  TextColumn get waehrung => text().withDefault(const Constant('EUR'))();
  TextColumn get gueltigVon => text().named('gueltig_von')();
  TextColumn get gueltigBis => text().named('gueltig_bis').nullable()();

  @override
  List<String> get customConstraints => <String>[
    'CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)',
  ];
}

/// Verkaufszeit-Fenster je Wochentag (Tabelle `verkaufszeit`).
@DataClassName('VerkaufszeitRow')
class Verkaufszeiten extends Table {
  @override
  String get tableName => 'verkaufszeit';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get wochentag => integer().customConstraint(
    'NOT NULL CHECK (wochentag BETWEEN 1 AND 7)',
  )();
  TextColumn get beginn => text().customConstraint(
    "NOT NULL CHECK (beginn GLOB '[0-2][0-9]:[0-5][0-9]' AND beginn < '24:00' OR beginn = '24:00')",
  )();
  TextColumn get ende => text().customConstraint(
    "NOT NULL CHECK (ende GLOB '[0-2][0-9]:[0-5][0-9]' AND ende < '24:00' OR ende = '24:00')",
  )();
  TextColumn get gueltigVon => text().named('gueltig_von').nullable()();
  TextColumn get gueltigBis => text().named('gueltig_bis').nullable()();

  @override
  List<String> get customConstraints => <String>[
    'CHECK (ende > beginn)',
    'CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)',
  ];
}

/// Betriebsdaten des Automaten (Tabelle `telemetrie`, nur lesend).
@TableIndex(
  name: 'idx_telemetrie_maschine_zeit',
  columns: {#maschineId, #timestamp},
)
@DataClassName('TelemetrieRow')
class Telemetrien extends Table {
  @override
  String get tableName => 'telemetrie';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get maschineId =>
      integer().named('maschine_id').references(Maschinen, #id)();
  TextColumn get timestamp => text()();
  IntColumn get stromverbrauchWatt => integer()
      .named('stromverbrauch_watt')
      .customConstraint('NOT NULL CHECK (stromverbrauch_watt >= 0)')();
  IntColumn get batteriestandProzent => integer()
      .named('batteriestand_prozent')
      .customConstraint(
        'NOT NULL CHECK (batteriestand_prozent BETWEEN 0 AND 100)',
      )();
  IntColumn get signalStaerkeDbm => integer()
      .named('signal_staerke_dbm')
      .customConstraint('NOT NULL CHECK (signal_staerke_dbm <= 0)')();
  IntColumn get packetlossProzent => integer()
      .named('packetloss_prozent')
      .customConstraint(
        'NOT NULL CHECK (packetloss_prozent BETWEEN 0 AND 100)',
      )();
}

/// Protokoll der angewandten Schema-Versionen (Tabelle `schema_version`).
@DataClassName('SchemaVersionRow')
class SchemaVersionen extends Table {
  @override
  String get tableName => 'schema_version';

  IntColumn get version => integer()();
  TextColumn get name => text()();
  TextColumn get appliedAt => text().named('applied_at')();
  TextColumn get checksum => text()();

  @override
  Set<Column> get primaryKey => <Column>{version};
}

/// SQLite-Datenbank des Prototyps.
///
/// Die Tabellen spiegeln die DDL aus `doc/plan/grundlagen/2_Datenbank.md`.
/// Das Schema wird beim ersten Oeffnen angelegt (`onCreate`); jedes Oeffnen
/// protokolliert Version, Name, Zeitpunkt und Pruefsumme in `schema_version`
/// und legt die deterministischen Seeds an, solange die Tabelle leer ist (E-52).
@DriftDatabase(
  tables: <Type>[
    Maschinen,
    Verkaeufe,
    Preissettings,
    Verkaufszeiten,
    Telemetrien,
    SchemaVersionen,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Datenbank im Arbeitsspeicher (nur fuer Tests).
  AppDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => aktuellesSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) => m.createAll(),
    beforeOpen: (OpeningDetails details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customSelect('PRAGMA journal_mode = WAL').get();
      await _protokolliereSchemaVersion();
      await _seedFallsLeer();
    },
  );

  Future<void> _protokolliereSchemaVersion() async {
    await into(schemaVersionen).insertOnConflictUpdate(
      SchemaVersionenCompanion.insert(
        version: Value<int>(aktuellesSchemaVersion),
        name: aktuellesSchemaName,
        appliedAt: formatUtc(DateTime.now()),
        checksum: await _schemaPruefsumme(),
      ),
    );
  }

  /// SHA-256 ueber alle angelegten Objekte - aendert sich mit dem Schema.
  Future<String> _schemaPruefsumme() async {
    final rows = await customSelect(
      "SELECT type, name, sql FROM sqlite_master "
      "WHERE sql IS NOT NULL AND name NOT LIKE 'sqlite_%' ORDER BY name",
    ).get();
    final buffer = StringBuffer();
    for (final row in rows) {
      buffer
        ..write(row.read<String>('type'))
        ..write('|')
        ..write(row.read<String>('name'))
        ..write('|')
        ..write(row.read<String>('sql'))
        ..write('\n');
    }
    return sha256.convert(utf8.encode(buffer.toString())).toString();
  }

  Future<void> _seedFallsLeer() async {
    final vorhanden = await customSelect(
      'SELECT COUNT(*) AS anzahl FROM maschine',
    ).getSingle();
    if (vorhanden.read<int>('anzahl') > 0) {
      return;
    }
    for (final maschine in SeedData.maschinen()) {
      await into(maschinen).insert(_maschinenCompanion(maschine));
    }
    for (final setting in SeedData.preissettings()) {
      await into(preissettings).insert(_preissettingsCompanion(setting));
    }
    for (final zeit in SeedData.verkaufszeiten()) {
      await into(verkaufszeiten).insert(_verkaufszeitenCompanion(zeit));
    }
    for (final messwert in SeedData.telemetrie()) {
      await into(telemetrien).insert(_telemetrienCompanion(messwert));
    }
  }
}

MaschinenCompanion _maschinenCompanion(Maschine maschine) =>
    MaschinenCompanion.insert(
      id: Value<int>(maschine.id),
      geraeteId: maschine.geraeteId,
      standort: maschine.standort,
      status: maschine.status.dbValue,
      kundennummer: maschine.kundennummer,
    );

PreissettingsCompanion _preissettingsCompanion(Preissetting setting) =>
    PreissettingsCompanion.insert(
      id: Value<int>(setting.id),
      taktMinuten: setting.taktMinuten,
      preisProTaktCent: setting.preisProTaktCent,
      waehrung: Value<String>(setting.waehrung),
      gueltigVon: formatUtc(setting.gueltigVon),
      gueltigBis: Value<String?>(formatUtcOrNull(setting.gueltigBis)),
    );

VerkaufszeitenCompanion _verkaufszeitenCompanion(Verkaufszeit zeit) =>
    VerkaufszeitenCompanion.insert(
      id: Value<int>(zeit.id),
      wochentag: zeit.wochentag,
      beginn: zeit.beginn,
      ende: zeit.ende,
      gueltigVon: Value<String?>(formatUtcOrNull(zeit.gueltigVon)),
      gueltigBis: Value<String?>(formatUtcOrNull(zeit.gueltigBis)),
    );

TelemetrienCompanion _telemetrienCompanion(Telemetrie messwert) =>
    TelemetrienCompanion.insert(
      id: Value<int>(messwert.id),
      maschineId: messwert.maschineId,
      timestamp: formatUtc(messwert.timestamp),
      stromverbrauchWatt: messwert.stromverbrauchWatt,
      batteriestandProzent: messwert.batteriestandProzent,
      signalStaerkeDbm: messwert.signalStaerkeDbm,
      packetlossProzent: messwert.packetlossProzent,
    );
