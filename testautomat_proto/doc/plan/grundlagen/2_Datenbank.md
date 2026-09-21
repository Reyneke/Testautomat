# Datenbank

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) beschreibt dieses Dokument die Datenbank, die das Backend für die Simulation darstellt. In der Produktion bezieht die App ihre Daten per REST als JSON aus einer gehosteten Datenbank; für den Prototypen werden dieselben Daten aus einer lokalen SQL-Datenbank geladen, die im Projekt abgelegt ist. Ziel ist ein Aufbau, der ein Umstellen auf die eigentliche Datenbank möglichst reibungslos macht.

## Vorbedingungen

- **Datenquelle für die App:** Die Datenbank liefert alle Daten, die die Bildschirme aus `1_Frontendstruktur.md` benötigen: Verkäufe, Preissettings, Verkaufszeiten und Maschineninformationen (vgl. `0_Einfuehrung.md`).
- **Contract first:** Alle Zugriffe laufen über eine Repository-Schnittstelle mit JSON-fähigen DTOs. Die App kennt nur diese Schnittstelle, nicht die konkrete Datenquelle (SQLite im Prototyp, REST in der Produktion). Kein Widget greift direkt auf die Datenbank zu — das gilt auch für den Debug-Bildschirm, Schreiben inklusive.
- **DSGVO:** Es werden keine personenbezogenen Daten gespeichert. Verkäufe sind anonym (Zeitstempel, Betrag, Zahlungsart und Belegnummer).
- **Schema-Erweiterbarkeit:** Änderungen am Schema laufen über Migrationsskripte und eine `schema_version`-Tabelle, damit Seed- und Bestandsdaten nachvollziehbar bleiben.

## Konzept

Aufbau der Datenbank in Tabellen (Schemata), abgeleitet aus den vier Entitäten der Einführung; ergänzt um die technische Tabelle `schema_version` (Migrationsmanagement, s. u.).

### Entitäten

| Tabelle | Inhalt | Wichtige Felder |
|---|---|---|
| `maschine` | Automateninformationen | `geraete_id` (UNIQUE), `standort`, `status`, `kundennummer` |
| `verkaeufe` | simulierte Parkverkäufe | `timestamp` (UTC), `maschine_id` (FK), `parkdauer_minuten`, `betrag_cent`, `zahlungsart`, `belegnummer` |
| `preissetting` | Preisregeln | `takt_minuten`, `preis_pro_takt_cent`, `waehrung`, `gueltig_von`/`gueltig_bis` |
| `verkaufszeit` | Zeiten, in denen der Automat aktiv ist | `wochentag`, `beginn`, `ende`, `gueltig_von`/`gueltig_bis` (optional) |
| `telemetrie` | Betriebsdaten des Automaten | `maschine_id` (FK), `timestamp` (UTC), `stromverbrauch_watt`, `batteriestand_prozent`, `signal_staerke_dbm`, `packetloss_prozent` |

Beziehungen: `verkaeufe.maschine_id → maschine.id` (1:n); ebenso `telemetrie.maschine_id → maschine.id` (1:n). `preissetting` und `verkaufszeit` sind zeitlich gültig: `gueltig_von`/`gueltig_bis` begrenzen die Gültigkeit, `NULL` bedeutet „unbefristet". Beim `verkaufszeit`-Eintrag kommt der `wochentag` (ISO 8601, 1 = Montag) für die Wochenperiodik dazu; `gueltig_von`/`gueltig_bis` erlauben Ausnahmen wie einzelne Feiertage.

### Schema (SQLite-DDL)

SQLite kennt keinen nativen Datums-/Zeittyp — Zeitangaben werden als ISO-8601-Text in UTC gespeichert (`2026-09-18T10:42:00Z`). Der Entwurf:

```sql
PRAGMA foreign_keys = ON;  -- pro Verbindung setzen, sonst prüft SQLite keine FKs

CREATE TABLE maschine (
    id           INTEGER PRIMARY KEY AUTOINCREMENT,
    geraete_id   TEXT    NOT NULL UNIQUE,   -- lesbare Geräte-ID, z. B. '4711'
    standort     TEXT    NOT NULL,
    status       TEXT    NOT NULL CHECK (status IN ('aktiv', 'inaktiv', 'stoerung')),
    kundennummer TEXT    NOT NULL            -- Zuordnung des Automaten zum Kunden (Betreiber)
);

CREATE TABLE verkaeufe (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    maschine_id       INTEGER NOT NULL REFERENCES maschine(id),
    timestamp         TEXT    NOT NULL,     -- ISO 8601, UTC
    parkdauer_minuten INTEGER NOT NULL CHECK (parkdauer_minuten > 0),
    betrag_cent       INTEGER NOT NULL CHECK (betrag_cent >= 0),
    zahlungsart       TEXT    NOT NULL CHECK (zahlungsart IN ('bar', 'karte')),
    belegnummer       INTEGER NOT NULL UNIQUE  -- Belegnummer für den Parkschein
);

CREATE INDEX idx_verkaeufe_maschine_zeit ON verkaeufe (maschine_id, timestamp);

CREATE TABLE preissetting (
    id                  INTEGER PRIMARY KEY AUTOINCREMENT,
    takt_minuten        INTEGER NOT NULL CHECK (takt_minuten > 0),
    preis_pro_takt_cent INTEGER NOT NULL CHECK (preis_pro_takt_cent >= 0),
    waehrung            TEXT    NOT NULL DEFAULT 'EUR',
    gueltig_von         TEXT    NOT NULL,    -- ISO 8601, UTC
    gueltig_bis         TEXT,                -- NULL = unbefristet
    CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)
);

CREATE TABLE verkaufszeit (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    wochentag   INTEGER NOT NULL CHECK (wochentag BETWEEN 1 AND 7),  -- 1 = Montag
    beginn      TEXT    NOT NULL CHECK (beginn GLOB '[0-2][0-9]:[0-5][0-9]' AND beginn < '24:00' OR beginn = '24:00'),
    ende        TEXT    NOT NULL CHECK (ende   GLOB '[0-2][0-9]:[0-5][0-9]' AND ende   < '24:00' OR ende   = '24:00'),
    gueltig_von TEXT,
    gueltig_bis TEXT,
    CHECK (ende > beginn),                   -- 0:00 bis 24:00 = ganzer Tag
    CHECK (gueltig_bis IS NULL OR gueltig_bis > gueltig_von)
);

CREATE TABLE telemetrie (
    id                    INTEGER PRIMARY KEY AUTOINCREMENT,
    maschine_id           INTEGER NOT NULL REFERENCES maschine(id),
    timestamp             TEXT    NOT NULL,  -- ISO 8601, UTC
    stromverbrauch_watt   INTEGER NOT NULL CHECK (stromverbrauch_watt >= 0),
    batteriestand_prozent INTEGER NOT NULL CHECK (batteriestand_prozent BETWEEN 0 AND 100),
    signal_staerke_dbm    INTEGER NOT NULL CHECK (signal_staerke_dbm <= 0),
    packetloss_prozent    INTEGER NOT NULL CHECK (packetloss_prozent BETWEEN 0 AND 100)
);

CREATE INDEX idx_telemetrie_maschine_zeit ON telemetrie (maschine_id, timestamp);

CREATE TABLE schema_version (
    version    INTEGER PRIMARY KEY,          -- fortlaufende Nummer
    name       TEXT    NOT NULL,             -- z. B. '0002_seed'
    applied_at TEXT    NOT NULL,             -- ISO 8601, UTC
    checksum   TEXT    NOT NULL              -- SHA-256 des Skripts
);
```

Hinweise:

- `PRAGMA foreign_keys = ON` wird **pro Verbindung** gesetzt und ist innerhalb einer Transaktion wirkungslos — am besten direkt nach dem Öffnen der Verbindung.
- Indizes: `geraete_id` ist durch `UNIQUE` automatisch abgedeckt; zusätzlich reicht je Tabelle der Index auf die am häufigsten gefilterten Spalten (siehe `idx_verkaeufe_maschine_zeit` und `idx_telemetrie_maschine_zeit`).
- Die `CHECK`s erzwingen das zweistellige Format `HH:MM` (bzw. `24:00`) — nur so ist der lexikografische Vergleich `ende > beginn` korrekt.
- **`kundennummer` und DSGVO:** Die Kundennummer bezeichnet den Betreiber/Kunden des Automaten (z. B. die Stadt Weiden), nicht den Endnutzer. Sie gehört zu den Maschinen-Stammdaten und ist nicht personenbezogen.

### Konventionen

- **IDs:** `INTEGER PRIMARY KEY AUTOINCREMENT`; die Maschine trägt zusätzlich eine lesbare, eindeutige `geraete_id`.
- **Geldbeträge:** immer ganze Cent als `INTEGER` (`betrag_cent`, `preis_pro_takt_cent`) — niemals `DOUBLE`, um Rundungsfehler zu vermeiden.
- **Zeitstempel:** Speicherung in UTC als ISO-8601-Text mit `Z`, Anzeige lokal; `verkaufszeit.beginn`/`ende` als `HH:MM` (`00:00`–`24:00`).
- **Constraints:** `NOT NULL` und `CHECK` verwenden, z. B. `parkdauer_minuten > 0` und `zahlungsart IN ('bar', 'karte')`; Fremdschlüssel explizit deklarieren (`REFERENCES` plus `PRAGMA foreign_keys`).
- **Versionierung:** `schema_version`-Tabelle für Migrationsmanagement (s. u.).

### Migrationen und Seed

1. Jede Schemaänderung ist ein eigenes, nummeriertes Skript (`0001_initial.sql`, `0002_seed.sql`, …).
2. Beim Start gleicht das Datenlayer die höchste angewandte Version mit `schema_version` ab und wendet fehlende Skripte transaktional an (inkl. `checksum`).
3. Seed-Daten sind idempotent (nur einfügen, wenn die Tabelle leer ist) oder Teil eines Migrationsskripts — so bleiben sie nachvollziehbar und wiederholbar.

### Seed-Daten

Für Demozwecke enthält das Projekt Seed-Daten, die den bisherigen Platzhaltern im `StartScreen` entsprechen (und diese mittelfristig ersetzen):

- Maschine mit `geraete_id` `4711`, Standort `Weiden i. d. OPf.`, Status `aktiv`, `kundennummer` `K-0001`
- Standard-Preissetting (z. B. Parktakt von 240 Minuten)
- Verkaufszeiten für alle Wochentage
- Telemetrie-Zeitreihe für `4711` (z. B. Messwerte im 15-Minuten-Takt der letzten Stunden), damit der Debug-Bildschirm Stromverbrauch, Batteriestand, Signalstärke und Packetloss sofort anzeigen kann

## Handover

Damit das Umstellen auf die eigentliche (gehostete) Datenbank so einfach wie möglich ist, gilt „Contract first": Die JSON-Struktur wird als Vertrag festgelegt, und alle Zugriffe laufen über eine zentrale Schnittstelle. Der Vertrag lebt in einem eigenen Datenlayer (`lib/data/`), isoliert von Widgets und Repository-Implementierungen.

### Repository-Schnittstelle

Die App verwendet ausschließlich ein Interface, z. B. `ParkautomatRepository`:

- `Future<Maschine> getMachine()` — liefert die aktive Maschine (im Prototyp genau eine; das Datenmodell trägt bereits mehrere)
- `Future<List<Preissetting>> getPreissettings()`
- `Future<List<Verkaufszeit>> getVerkaufszeiten()`
- `Future<List<Telemetrie>> getTelemetrie({DateTime? von, DateTime? bis})` — Betriebsdaten, nur lesend (in der Produktion schreibt die Firmware)
- `Future<List<Tagesumsatz>> getTagesumsaetze(DateTime von, DateTime bis)` — Umsatz pro Tag für die Zeitreihe im Debug-Bildschirm
- `Future<Verkauf> createSale(VerkaufDraft draft)` — atomar, vgl. *Mögliche Probleme*
- `Future<void> updatePreissetting(Preissetting setting)` — für den Debug-Bildschirm
- `Future<void> updateVerkaufszeit(Verkaufszeit zeit)` — für den Debug-Bildschirm

Drei Implementierungen:

1. **`SqliteRepository`** (Prototyp, Desktop) — liest und schreibt die lokale SQLite-Datei im Projekt.
2. **`RestRepository`** (Produktion) — spricht den gehosteten Dienst per REST/JSON an.
3. **`InMemoryRepository`** (Web-Build) — der Browser hat kein Dateisystem; die Daten liegen im Arbeitsspeicher und werden beim Start mit denselben Seed-Daten befüllt wie die SQLite-Datei (ohne Persistenz). Damit bleibt der Web-Build ohne zusätzliche Abhängigkeiten lauffähig; ein späterer Umstieg auf einen echten REST-Dienst ändert den Vertrag nicht.

Die Auswahl der Implementierung erfolgt an genau einer Stelle (Composition Root, z. B. in `lib/main.dart`) — nicht über die App verteilt. Dadurch bleibt der Umstieg eine reine Austausch-Entscheidung.

Hinweise:

- **Singular statt Plural:** `createSale` liefert einen einzelnen Verkauf zurück — die DTOs heißen entsprechend `Verkauf`/`VerkaufDraft` statt `Verkaeufe`.
- **Schreiben nur über das Repository:** Auch der Debug-Bildschirm ändert Preissettings/Verkaufszeiten über das Interface, nie durch direkten Datenbankzugriff — sonst greift „Contract first" nicht mehr.
- **REST-Mapping für die Produktion:**

| Repository-Methode | REST-Request |
|---|---|
| `getMachine` | `GET /api/v1/maschine/{id}` (`{id}` = aktive Maschine) |
| `getPreissettings` | `GET /api/v1/preissettings` |
| `getVerkaufszeiten` | `GET /api/v1/verkaufszeiten` |
| `getTelemetrie` | `GET /api/v1/maschine/{id}/telemetrie?von=…&bis=…` |
| `getTagesumsaetze` | `GET /api/v1/verkaeufe/umsatz-pro-tag?von=…&bis=…` |
| `createSale` | `POST /api/v1/verkaeufe` |
| `updatePreissetting` | `PUT /api/v1/preissettings/{id}` |
| `updateVerkaufszeit` | `PUT /api/v1/verkaufszeiten/{id}` |

Der API-Pfad ist versioniert (`/api/v1/…`), damit Vertragsänderungen den Prototyp nicht brechen.

### JSON-Datenvertrag (Beispiele)

Maschine:

```json
{
  "geraete_id": "4711",
  "standort": "Weiden i. d. OPf.",
  "status": "aktiv"
}
```

Verkauf (Request für `createSale`):

```json
{
  "timestamp": "2026-09-18T10:42:00Z",
  "maschine_id": 1,
  "parkdauer_minuten": 240,
  "betrag_cent": 200,
  "zahlungsart": "karte"
}
```

Telemetrie (Antwort auf `getTelemetrie`):
```json
{
  "maschine_id": 1,
  "timestamp": "2026-09-18T10:42:00Z",
  "stromverbrauch_watt": 42,
  "batteriestand_prozent": 87,
  "signal_staerke_dbm": -61,
  "packetloss_prozent": 0
}
```

Tagesumsatz (Element der Antwort auf `getTagesumsaetze`):
```json
{
  "tag": "2026-09-18",
  "umsatz_cent": 400
}
```

Die DTOs sind unveränderlich (immutable) und besitzen nur `fromJson`/`toJson`; sie leben isoliert von Widgets und Repository in einem eigenen Datenlayer. Im JSON gelten durchgängig `snake_case`-Feldnamen (wie oben); Dart-Code bildet sie in `fromJson`/`toJson` auf `camelCase` ab.

## Debug-Bildschirm

Für den Prototyp soll ein Debugbildschirm erstellt werden, der alle obenstehenden Daten anzeigt und einstellbar macht. Die Verkäufe sollen dort auch dargestellt werden, einmal als Tabelle, einmal graphisch — als Zeitreihe des Umsatzes pro Tag.

Akzeptanzkriterien:

- Lesen und Schreiben ausschließlich über die Repository-Schnittstelle (Contract bleibt gewahrt).
- Die Darstellung verwendet dieselben DTOs wie `createSale` (eine Quelle der Wahrheit).
- Tabelle und Grafik zeigen dieselbe Zeitreihe aus `getTagesumsaetze`: Umsatz pro Tag, gruppiert an den UTC-Tagesgrenzen (über `substr(timestamp, 1, 10)`), Anzeige lokal.
- Zusätzlich listet der Debug-Bildschirm die Telemetrie (nur lesend über das Repository).
- Tabelle und Grafik nutzen dieselbe Zeitbasis: Speicherung in UTC, Anzeige lokal.

## Offene Punkte (Backlog)

- **Telemetriedaten:** abgeschlossen — Tabelle `telemetrie` und `kundennummer` sind in Schema, Repository, REST-Mapping und Seed eingearbeitet (s. o.).
- **Web-Entscheidung:** abgeschlossen — der Web-Build nutzt das `InMemoryRepository` (s. o.).
- **Verkaufsgrafik:** abgeschlossen — Zeitreihe in Umsatz pro Tag, tabellarisch und graphisch (s. Debug-Bildschirm).

## Mögliche Probleme

- **Flutter Web und SQLite:** Eine lokale Datei existiert im Browser nicht. Entscheidung: Der Web-Build nutzt das `InMemoryRepository` mit denselben Seed-Daten (ohne Persistenz). Braucht die Demo Persistenz über Reloads hinweg, wird sie später über `localStorage`/IndexedDB ergänzt — der Repository-Vertrag bleibt unverändert.
- **Geldbeträge als `double`:** Fließkommazahlen verursachen Rundungsfehler; daher Beträge konsequent in Cent als `INTEGER` speichern.
- **Zeitzonen:** Zeitstempel in lokaler Zeit sorgen für Fehler bei DST-Änderungen; in UTC speichern (ISO 8601 mit `Z`) und erst für die Anzeige lokalisieren.
- **Migrationen:** Ohne Versionstabelle sind Schemaänderungen und Seed-Aktualisierungen nicht nachvollziehbar.
- **Transaktionen:** `createSale` muss atomar sein (INSERT, Belegnummern-Vergabe, Validierung) — z. B. bei parallelem Zugriff auf denselben Automaten; ggf. `PRAGMA journal_mode = WAL` für bessere Nebenläufigkeit.
- **Fremdschlüssel:** SQLite prüft `REFERENCES` nur, wenn pro Verbindung `PRAGMA foreign_keys = ON` gesetzt ist.
- **Platzhalter im `StartScreen`:** `'4711'` und `'Weiden i. d. OPf.'` sind in `lib/screens/start_screen.dart` hart kodiert. Entscheidung E-55: Sie werden beim App-Start über `getMachine()` geladen und über `AppMachine.maschineNotifier` dargestellt; die Umsetzung erfolgt mit dem Datenlayer.
