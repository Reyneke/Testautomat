# Datenbank

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) beschreibt dieses Dokument die Datenbank, die das Backend für die Simulation darstellt. In der Produktion bezieht die App ihre Daten per REST als JSON aus einer gehosteten Datenbank; für den Prototypen werden dieselben Daten aus einer lokalen SQL-Datenbank geladen, die im Projekt abgelegt ist. Ziel ist ein Aufbau, der ein Umstellen auf die eigentliche Datenbank möglichst reibungslos macht.

## Vorbedingungen

- **Datenquelle für die App:** Die Datenbank liefert alle Daten, die die Bildschirme aus `1_Frontendstruktur.md` benötigen: Verkäufe, Preissettings, Verkaufszeiten und Maschineninformationen (vgl. `0_Einfuehrung.md`).
- **Contract first:** Alle Zugriffe laufen über eine Repository-Schnittstelle mit JSON-fähigen DTOs. Die App kennt nur diese Schnittstelle, nicht die konkrete Datenquelle (SQLite im Prototyp, REST in der Produktion). Kein Widget greift direkt auf die Datenbank zu.
- **DSGVO:** Es werden keine personenbezogenen Daten gespeichert. Verkäufe sind anonym (Zeitstempel, Betrag, Zahlungsart und Belegnummer).
- **Schema-Erweiterbarkeit:** Änderungen am Schema laufen über Migrationsskripte und eine `schema_version`-Tabelle, damit Seed- und Bestandsdaten nachvollziehbar bleiben.

## Konzept

Aufbau der Datenbank in Tabellen (Schemata), abgeleitet aus den vier Entitäten der Einführung.

### Entitäten

| Tabelle | Inhalt | Wichtige Felder |
|---|---|---|
| `maschine` | Automateninformationen | `geraete_id` (UNIQUE), `standort`, `status` |
| `verkaeufe` | simulierte Parkverkäufe | `timestamp` (UTC), `maschine_id` (FK), `parkdauer_minuten`, `betrag_cent`, `zahlungsart` |
| `preissetting` | Preisregeln | `takt_minuten`, `preis_pro_takt_cent`, `waehrung`, `gueltig_von`/`gueltig_bis` |
| `verkaufszeit` | Zeiten, in denen der Automat aktiv ist | `wochentag`, `beginn`, `ende` |

Beziehungen: `verkaeufe.maschine_id → maschine.id` (1:n); `preissetting` und `verkaufszeit` sind zeitlich gültig (`gueltig_von`/`gueltig_bis`).

### Konventionen

- **IDs:** `INTEGER PRIMARY KEY AUTOINCREMENT`; die Maschine trägt zusätzlich eine lesbare, eindeutige `geraete_id`.
- **Geldbeträge:** immer ganze Cent als `INTEGER` (`betrag_cent`, `preis_pro_takt_cent`) — niemals `DOUBLE`, um Rundungsfehler zu vermeiden.
- **Zeitstempel:** Speicherung in UTC, Anzeige lokal; `verkaufszeit.beginn`/`ende` als `HH:MM`.
- **Constraints:** `NOT NULL` und `CHECK` verwenden, z. B. `parkdauer_minuten > 0` und `zahlungsart IN ('bar', 'karte')`; Fremdschlüssel explizit deklarieren.
- **Versionierung:** `schema_version`-Tabelle für Migrationsmanagement.

### Seed-Daten

Für Demozwecke enthält das Projekt Seed-Daten, die den bisherigen Platzhaltern im `StartScreen` entsprechen (und diese mittelfristig ersetzen):

- Maschine mit `geraete_id` `4711`, Standort `Weiden i. d. OPf.`, Status `aktiv`
- Standard-Preissetting (z. B. Parktakt von 240 Minuten)
- Verkaufszeiten für alle Wochentage

## Handover

Damit das Umstellen auf die eigentliche (gehostete) Datenbank so einfach wie möglich ist, gilt „Contract first": Die JSON-Struktur wird als Vertrag festgelegt, und alle Zugriffe laufen über eine zentrale Schnittstelle.

### Repository-Schnittstelle

Die App verwendet ausschließlich ein Interface, z. B. `ParkautomatRepository`:

- `Future<Maschine> getMachine()`
- `Future<List<Preissetting>> getPreissettings()`
- `Future<List<Verkaufszeit>> getVerkaufszeiten()`
- `Future<Verkaeufe> createSale(VerkaeufeDraft draft)`

Zwei Implementierungen:

1. **`SqliteRepository`** (Prototyp) — liest und schreibt die lokale SQLite-Datei im Projekt.
2. **`RestRepository`** (Produktion) — spricht den gehosteten Dienst per REST/JSON an.

Die Auswahl der Implementierung erfolgt an genau einer Stelle (Composition Root, z. B. in `lib/main.dart`) — nicht über die App verteilt. Dadurch bleibt der Umstieg eine reine Austausch-Entscheidung.

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

Die DTOs sind unveränderlich und besitzen nur `fromJson`/`toJson`; sie leben isoliert von Widgets und Repository in einem eigenen Datenlayer.

## Mögliche Probleme

- **Flutter Web und SQLite:** Eine lokale Datei existiert im Browser nicht. Für Web muss früh entschieden werden, ob ein web-fähiges Backend (z. B. die REST-Simulation) oder ein alternativer Speicher genutzt wird.
- **Geldbeträge als `double`:** Fließkommazahlen verursachen Rundungsfehler; Beträge konsequent in Cent als `INTEGER` führen.
- **Zeitzonen:** Zeitstempel in lokaler Zeit sorgen für Fehler zu DST-Änderungen; in UTC speichern und erst für die Anzeige lokalisieren.
- **Migrationen:** Ohne Versionstabelle sind Schemaänderungen und Seed-Aktualisierungen nicht nachvollziehbar.
- **Transaktionen:** `createSale` muss atomar sein (z. B. bei parallelem Zugriff auf denselben Automaten).
- **Platzhalter im `StartScreen`:** `'4711'` und `'Weiden i. d. OPf.'` sind in `lib/screens/start_screen.dart` hart kodiert und sollten beim Aufbau des Datenlayers durch Repository-Aufrufe ersetzt werden.