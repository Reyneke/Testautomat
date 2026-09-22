/// Versionsangaben des Datenlayers (siehe `doc/plan/grundlagen/2_Datenbank.md`).
library;

/// Aktuelle Schema-Version; wird in `schema_version` protokolliert.
const int aktuellesSchemaVersion = 1;

/// Name des Migrationsschritts, der die aktuelle Version erzeugt.
const String aktuellesSchemaName = '0001_initial';

/// Dokumentierte DDL des aktuellen Schemas (Mensch-lesbare Fassung).
const String schemaDokumentPfad = 'lib/data/migrations/0001_initial.sql';
