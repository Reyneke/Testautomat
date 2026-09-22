import 'package:drift/drift.dart';
import 'package:sqlite3/sqlite3.dart' show SqliteException;

import 'belegnummer.dart';
import 'drift/app_database.dart';
import 'drift/connection.dart';
import 'drift/mappings.dart';
import 'dto.dart';
import 'json_utils.dart';
import 'parkautomat_repository.dart';
import 'repository_exception.dart';
import 'sale_validation.dart';

/// SQLite-Repository des Desktop-Prototyps (E-49).
///
/// Liest und schreibt die lokale Datenbankdatei. `createSale` laeuft in einer
/// Transaktion: Validierung, Belegnummernvergabe und INSERT sind atomar; bei
/// einer Belegnummern-Kollision wird der naechste Zaehler verwendet (E-16).
class SqliteRepository implements ParkautomatRepository {
  SqliteRepository(this._db, {DateTime? einschaltzeit})
    : _einschaltzeit = einschaltzeit ?? DateTime.now();

  /// Repository auf der lokalen Datenbankdatei des Prototyps.
  factory SqliteRepository.desktop({DateTime? einschaltzeit}) =>
      SqliteRepository(
        AppDatabase(openAppDatabase()),
        einschaltzeit: einschaltzeit,
      );

  /// Repository auf einer Datenbank im Arbeitsspeicher (Tests).
  factory SqliteRepository.memory({DateTime? einschaltzeit}) =>
      SqliteRepository(AppDatabase.memory(), einschaltzeit: einschaltzeit);

  /// Anzahl der Versuche, eine freie Belegnummer zu vergeben.
  static const int maxBelegnummerVersuche = 5;

  /// SQLite meldet einen UNIQUE-Verstoss als `SQLITE_CONSTRAINT_UNIQUE`.
  static const int _sqliteConstraintUnique = 2067;

  final AppDatabase _db;
  final DateTime _einschaltzeit;
  final Map<int, BelegnummerGenerator> _generatoren =
      <int, BelegnummerGenerator>{};

  @override
  Future<Maschine> getMachine() async {
    final zeile =
        await (_db.select(_db.maschinen)
              ..where((t) => t.status.equals(MaschinenStatus.aktiv.name)))
            .getSingleOrNull();
    if (zeile == null) {
      throw const RepositoryException('Keine aktive Maschine vorhanden.');
    }
    return zeile.toDto();
  }

  @override
  Future<List<Preissetting>> getPreissettings() async {
    final zeilen =
        await (_db.select(_db.preissettings)
              ..orderBy(<OrderClauseGenerator<$PreissettingsTable>>[
                (t) => OrderingTerm(expression: t.id),
              ]))
            .get();
    return List<Preissetting>.unmodifiable(zeilen.map((z) => z.toDto()));
  }

  @override
  Future<List<Verkaufszeit>> getVerkaufszeiten() async {
    final zeilen =
        await (_db.select(_db.verkaufszeiten)
              ..orderBy(<OrderClauseGenerator<$VerkaufszeitenTable>>[
                (t) => OrderingTerm(expression: t.wochentag),
              ]))
            .get();
    return List<Verkaufszeit>.unmodifiable(zeilen.map((z) => z.toDto()));
  }

  @override
  Future<List<Telemetrie>> getTelemetrie({DateTime? von, DateTime? bis}) async {
    final abfrage = _db.select(_db.telemetrien)
      ..orderBy(<OrderClauseGenerator<$TelemetrienTable>>[
        (t) => OrderingTerm(expression: t.timestamp),
      ]);
    if (von != null) {
      abfrage.where((t) => t.timestamp.isBiggerOrEqualValue(formatUtc(von)));
    }
    if (bis != null) {
      abfrage.where((t) => t.timestamp.isSmallerThanValue(formatUtc(bis)));
    }
    final zeilen = await abfrage.get();
    return List<Telemetrie>.unmodifiable(zeilen.map((z) => z.toDto()));
  }

  @override
  Future<List<Tagesumsatz>> getTagesumsaetze(DateTime von, DateTime bis) async {
    final zeilen = await _db
        .customSelect(
          'SELECT substr(timestamp, 1, 10) AS tag, SUM(betrag_cent) AS umsatz_cent '
          'FROM verkaeufe WHERE timestamp >= ? AND timestamp < ? '
          'GROUP BY tag ORDER BY tag',
          variables: <Variable<Object>>[
            Variable<String>(formatUtc(von)),
            Variable<String>(formatUtc(bis)),
          ],
          readsFrom: {_db.verkaeufe},
        )
        .get();
    return zeilen
        .map(
          (zeile) => Tagesumsatz(
            tag: zeile.read<String>('tag'),
            umsatzCent: zeile.read<int>('umsatz_cent'),
          ),
        )
        .toList();
  }

  @override
  Future<Verkauf> createSale(VerkaufDraft draft) async {
    final geprueft = validateVerkaufDraft(draft);
    return _db.transaction(() async {
      final maschine = await (_db.select(
        _db.maschinen,
      )..where((t) => t.id.equals(geprueft.maschineId))).getSingleOrNull();
      if (maschine == null) {
        throw RepositoryException(
          'Unbekannte Maschine: ${geprueft.maschineId}',
        );
      }
      final generator = _generatorFuer(
        maschine,
        startZaehler: await _zaehlerStand(maschine.id),
      );
      final timestamp = formatUtc(geprueft.timestamp);
      for (var versuch = 0; versuch < maxBelegnummerVersuche; versuch++) {
        final belegnummer = generator.next();
        try {
          final id = await _db
              .into(_db.verkaeufe)
              .insert(
                VerkaeufeCompanion.insert(
                  maschineId: maschine.id,
                  timestamp: timestamp,
                  parkdauerMinuten: geprueft.parkdauerMinuten,
                  betragCent: geprueft.betragCent,
                  zahlungsart: geprueft.zahlungsart.dbValue,
                  belegnummer: belegnummer,
                ),
              );
          return Verkauf(
            id: id,
            maschineId: maschine.id,
            timestamp: truncateToSecondsUtc(geprueft.timestamp),
            parkdauerMinuten: geprueft.parkdauerMinuten,
            betragCent: geprueft.betragCent,
            zahlungsart: geprueft.zahlungsart,
            belegnummer: belegnummer,
          );
        } on SqliteException catch (fehler) {
          if (fehler.extendedResultCode != _sqliteConstraintUnique) {
            rethrow;
          }
          // Belegnummer schon vergeben: mit dem naechsten Zaehler erneut (E-16).
        }
      }
      throw const RepositoryException(
        'Es konnte keine freie Belegnummer '
        'vergeben werden.',
      );
    });
  }

  @override
  Future<void> updatePreissetting(Preissetting setting) async {
    final betroffen =
        await (_db.update(
          _db.preissettings,
        )..where((t) => t.id.equals(setting.id))).write(
          PreissettingsCompanion(
            taktMinuten: Value<int>(setting.taktMinuten),
            preisProTaktCent: Value<int>(setting.preisProTaktCent),
            waehrung: Value<String>(setting.waehrung),
            gueltigVon: Value<String>(formatUtc(setting.gueltigVon)),
            gueltigBis: Value<String?>(formatUtcOrNull(setting.gueltigBis)),
          ),
        );
    if (betroffen == 0) {
      throw RepositoryException('Preissetting ${setting.id} existiert nicht.');
    }
  }

  @override
  Future<void> updateVerkaufszeit(Verkaufszeit zeit) async {
    final betroffen =
        await (_db.update(
          _db.verkaufszeiten,
        )..where((t) => t.id.equals(zeit.id))).write(
          VerkaufszeitenCompanion(
            wochentag: Value<int>(zeit.wochentag),
            beginn: Value<String>(zeit.beginn),
            ende: Value<String>(zeit.ende),
            gueltigVon: Value<String?>(formatUtcOrNull(zeit.gueltigVon)),
            gueltigBis: Value<String?>(formatUtcOrNull(zeit.gueltigBis)),
          ),
        );
    if (betroffen == 0) {
      throw RepositoryException('Verkaufszeit ${zeit.id} existiert nicht.');
    }
  }

  @override
  Future<void> close() => _db.close();

  Future<int> _zaehlerStand(int maschineId) async {
    final zeile = await _db
        .customSelect(
          'SELECT COUNT(*) AS anzahl FROM verkaeufe WHERE maschine_id = ?',
          variables: <Variable<Object>>[Variable<int>(maschineId)],
          readsFrom: {_db.verkaeufe},
        )
        .getSingle();
    return zeile.read<int>('anzahl');
  }

  BelegnummerGenerator _generatorFuer(
    MaschineRow maschine, {
    required int startZaehler,
  }) => _generatoren.putIfAbsent(
    maschine.id,
    () => BelegnummerGenerator(
      geraeteId: maschine.geraeteId,
      einschaltzeit: _einschaltzeit,
      startZaehler: startZaehler,
    ),
  );
}
