/// Versionsangaben des Datenlayers (siehe `doc/plan/grundlagen/2_Datenbank.md`).
library;

/// Aktuelle Schema-Version; wird in `schema_version` protokolliert.
const int aktuellesSchemaVersion = 2;

/// Name des Migrationsschritts, der die aktuelle Version erzeugt.
const String aktuellesSchemaName = '0002_zahlungsarten_kennzeichen_parkzonen';

/// Dokumentierte DDL des aktuellen Schemas (Mensch-lesbare Fassung).
const String schemaDokumentPfad =
    'lib/data/migrations/0002_zahlungsarten_kennzeichen_parkzonen.sql';
