# Testautomat — Prototyp

## Worum geht es?

Frontend für einen Parkautomaten. Der Prototyp bildet den Kaufablauf am Automaten ab
(Begrüßung → Parkzone und Parkzeit → Zahlungsauswahl → Parkinformation → Verabschiedung) und läuft
auf Android, Windows, Linux und im Browser. Alle Zahlungen und Parkscheine werden
ausschließlich simuliert.

Die fachlichen Grundlagen und der Umsetzungsstand stehen unter [`doc/plan/`](doc/plan/) —
Einstieg über die Übersichtsseite [`doc/plan/README.md`](doc/plan/README.md), die alle Grundlagendokumente kurz beschreibt und die Lesereihenfolge festhält.

## Status

[![Build](https://github.com/Reyneke/Testautomat/actions/workflows/build.yml/badge.svg?branch=main)](https://github.com/Reyneke/Testautomat/actions/workflows/build.yml)

- **Umsetzungsstand:** [`5_Umsetzungsplan.md`](doc/plan/grundlagen/5_Umsetzungsplan.md) (Meilensteine M0–M5, Arbeitspakete U-01…U-77)
- **Letztes Release:** [Releases](https://github.com/Reyneke/Testautomat/releases/latest)
- **Version:** aus `pubspec.yaml` (`1.0.0+1`), Tags nach `vX.Y.Z` (E-33)

> Die CI/CD-Pipeline (`.github/workflows/build.yml`) entsteht mit Arbeitspaket `U-60`; bis
dahin zeigt das Badge noch keinen Status.

## Zielplattformen

| Plattform | Artefakt | Anmerkung |
|---|---|---|
| Android | APK (direkte Installation), AAB (Store) | im Prototyp un-signiert (E-42) |
| Windows | Installer (MSIX/EXE) | im Prototyp un-signiert (E-42) |
| Linux | Paket (AppImage/DEB) | im Prototyp un-signiert (E-42) |
| Web | statische Build-Ausgabe (`build/web`) | Hosting über GitHub Pages |

**Nicht-Zielplattformen:** macOS und iOS. Dafür wären ein Macintosh bzw. ein
Apple-Developer-Account nötig; die Releases beschränken sich auf Plattformen, die sich mit
kostenlosen GitHub-Runnern bauen lassen (E-01, E-28).

## Getting Started

**Voraussetzungen:** Flutter SDK (Stable-Channel) mit Dart `^3.12.2` laut `pubspec.yaml`; für
Android zusätzlich Java 17 und das Android-SDK. Web braucht nur ein installiertes Chrome.

```bash
flutter pub get     # Abhängigkeiten laden
flutter run         # Ziel wählen: Windows, Android oder Chrome (Web)
flutter test        # Widget-Tests
flutter analyze     # Statische Analyse
```

**Gate lokal** (Formatierung, Analyse, Tests - Arbeitspaket `U-52`):

```powershell
powershell -ExecutionPolicy Bypass -File tool/gate.ps1
```

**Aktueller Funktionsumfang:** Startbildschirm mit Uhrzeit/Datum, uhrzeitangemessener
Begrüßung und Start-Button; Theme (Hell/Dunkel/System, Standard Dunkel) und Sprache
(Deutsch/Englisch) sind zur Laufzeit umschaltbar. Die Debug-Angaben zeigen noch Platzhalter.
Datenlayer (SQLite über `drift`), Navigation, Kaufablauf und Debug-Bildschirm folgen gemäß
`5_Umsetzungsplan.md` (Phasen 1–4).

| Umgebung | Datenhaltung |
|---|---|
| Desktop (Prototyp) | lokale SQLite-Datei über `drift` — geplant, `lib/data/` (E-49, E-50) |
| Web (Prototyp) | `InMemoryRepository` mit denselben Seed-Daten, ohne Persistenz (E-11) |
| Produktion (Perspektive) | gehostete Postgres-Datenbank mit REST-Schicht und Token-Authentifizierung (E-43) |

## Downloads

Fertige Builds hängen an den GitHub-Releases: [Releases](https://github.com/Reyneke/Testautomat/releases/latest).
Artefakte entstehen nur bei Tags `v*` und liegen nicht im Repository (E-33). Sie sind im
Prototyp **un-signiert**, daher ist bei der Installation eine Warnung des Betriebssystems zu
erwarten (E-42). Der Web-Build läuft auf der GitHub-Pages-Projektseite.

## Projektstruktur

| Pfad | Inhalt |
|---|---|
| `lib/main.dart` | Einstiegspunkt; bindet Theme- und Sprachzustand an die `MaterialApp` |
| `lib/screens/` | Bildschirme (aktuell der Startbildschirm) |
| `lib/theme/` | `AppTheme` — helles/dunkles Theme und Textstile |
| `lib/l10n/` | `AppLocale` (Sprachzustand) und `AppLocalizations` (Texte de/en) |
| `lib/widgets/` | Wiederverwendbare Widgets (Theme- und Sprachauswahl) |
| `assets/` | Bilder, u. a. das Wappen der Stadt Weiden |
| `test/` | Widget-Tests |
| `doc/plan/` | Planungs- und Grundlagendokumente |

## Dokumentation

| Dokument | Inhalt |
|---|---|
| [`README.md`](doc/plan/README.md) | Übersicht: Kurzbeschreibung aller Dokumente und empfohlene Lesereihenfolge |
| [`0_Einfuehrung.md`](doc/plan/grundlagen/0_Einfuehrung.md) | Basisdokument: Bildschirme, Datenbank, Grenzen, Bauziele |
| [`1_Frontendstruktur.md`](doc/plan/grundlagen/1_Frontendstruktur.md) | Theme, Mehrsprachigkeit, Aufbau der Bildschirme |
| [`2_Datenbank.md`](doc/plan/grundlagen/2_Datenbank.md) | Schema, Repository-Vertrag, Migrationen, Seed-Daten |
| [`3_Git_Shenanigans.md`](doc/plan/grundlagen/3_Git_Shenanigans.md) | Build, Release und Hosting (CI/CD) |
| [`4_Offene_Fragen.md`](doc/plan/grundlagen/4_Offene_Fragen.md) | Fragenkatalog (F-01…F-59) und Entscheidungslog (E-01…E-59) |
| [`5_Umsetzungsplan.md`](doc/plan/grundlagen/5_Umsetzungsplan.md) | Arbeitspakete, Meilensteine, Definition of Done |
| [`6_Logging_und_Datenschutz.md`](doc/plan/grundlagen/6_Logging_und_Datenschutz.md) | Protokollierung, Rotation und Aufbewahrung |
| [`7_Neue_Zahlmoeglichkeiten.md`](doc/plan/grundlagen/7_Neue_Zahlmoeglichkeiten.md) | Zahlungsarten, PDF-Beleg, Kennzeichen und Parkzonen |

Empfohlene Lesereihenfolge: `0_` → `1_` → `2_` → `3_` → `4_` → `5_` → `6_` → `7_`.

## Hinweise (DSGVO)

- Verkäufe sind **anonym** (Zeitstempel, Betrag, Zahlungsart, Belegnummer), solange der Kunde kein
  Kennzeichen angibt. Das **optionale Kennzeichen** ist personenbeziehbar: es wird nie protokolliert
  und nur mit dem Verkaufsdatensatz gespeichert (E-58, E-54).
- Alle **Zahlungen und Parkscheine werden simuliert** — es findet keine echte Zahlung statt.
- Protokollierung, Rotation sowie das Aufbewahrungs- und Purge-Konzept sind in
  [`doc/plan/grundlagen/6_Logging_und_Datenschutz.md`](doc/plan/grundlagen/6_Logging_und_Datenschutz.md)
  beschrieben (E-48, E-54): Logs enthalten nur Betriebsdaten und rotieren; das Löschkonzept ist
  festgelegt, im Prototyp aber nicht implementiert.
- Die Schriften (Poppins/Lato) werden als Assets gebündelt ausgeliefert, damit im Betrieb kein
  Netzabruf nötig ist (E-38; Umsetzung in `U-72`).