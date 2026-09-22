-- Dokumentierte DDL des Datenlayers (Version 0001_initial).
--
-- Quelle der Wahrheit sind die Drift-Tabellen in `lib/data/drift/app_database.dart`;
-- diese Datei ist die menschlich lesbare Fassung aus `doc/plan/grundlagen/2_Datenbank.md`.
-- Der Test `test/data/migrations_test.dart` prueft, dass Tabellen und Spalten dieser
-- Datei im tatsaechlich angelegten Schema vorkommen.
--
-- Verbindungsweite Einstellungen (siehe beforeOpen in app_database.dart):
--   PRAGMA foreign_keys = ON;
--   PRAGMA journal_mode = WAL;

CREATE TABLE maschine (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    geraete_id   TEXT    NOT NULL UNIQUE,
    standort     TEXT    NOT NULL,
    status       TEXT    NOT NULL CHECK (status IN ('aktiv', 'inaktiv', 'stoerung')),
    kundennummer TEXT    NOT NULL
);

CREATE TABLE verkaeufe (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    maschine_id       INTEGER NOT NULL REFERENCES maschine(id),
    timestamp         TEXT    NOT NULL,
    parkdauer_minuten INTEGER NOT NULL CHECK (parkdauer_minuten > 0),
    betrag_cent       INTEGER NOT NULL CHECK (betrag_cent >= 0),
    zahlungsart       TEXT    NOT NULL CHECK (zahlungsart IN ('bar', 'karte')),
    belegnummer       INTEGER NOT NULL UNIQUE
);

CREATE INDEX idx_verkaeufe_maschine_zeit ON verkaeufe (maschine_id, timestamp);

CREATE TABLE preissetting (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    takt_minuten        INTEGER NOT NULL CHECK (takt_minuten > 0),
    preis_pro_takt_cent INTEGER NOT NULL CHECK (preis_pro_takt_cent >= 0),
    waehrung            TEXT    NOT NULL DEFAULT 'EUR',
    gueltig_von         TEXT    NOT NULL,
    gueltig_bis         TEXT,
    CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)
);

CREATE TABLE verkaufszeit (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    wochentag   INTEGER NOT NULL CHECK (wochentag BETWEEN 1 AND 7),
    beginn      TEXT    NOT NULL CHECK (beginn GLOB '[0-2][0-9]:[0-5][0-9]' AND beginn < '24:00' OR beginn = '24:00'),
    ende        TEXT    NOT NULL CHECK (ende   GLOB '[0-2][0-9]:[0-5][0-9]' AND ende   < '24:00' OR ende   = '24:00'),
    gueltig_von TEXT,
    gueltig_bis TEXT,
    CHECK (ende > beginn),
    CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)
);

CREATE TABLE telemetrie (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    maschine_id           INTEGER NOT NULL REFERENCES maschine(id),
    timestamp             TEXT    NOT NULL,
    stromverbrauch_watt   INTEGER NOT NULL CHECK (stromverbrauch_watt >= 0),
    batteriestand_prozent INTEGER NOT NULL CHECK (batteriestand_prozent BETWEEN 0 AND 100),
    signal_staerke_dbm    INTEGER NOT NULL CHECK (signal_staerke_dbm <= 0),
    packetloss_prozent    INTEGER NOT NULL CHECK (packetloss_prozent BETWEEN 0 AND 100)
);

CREATE INDEX idx_telemetrie_maschine_zeit ON telemetrie (maschine_id, timestamp);

CREATE TABLE schema_version (
    version    INTEGER PRIMARY KEY,
    name       TEXT    NOT NULL,
    applied_at TEXT    NOT NULL,
    checksum   TEXT    NOT NULL
);