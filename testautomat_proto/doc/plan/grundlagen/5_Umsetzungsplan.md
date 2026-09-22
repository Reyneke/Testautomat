# Umsetzungsplan

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) übersetzt dieses Dokument die Entscheidungen aus `4_Offene_Fragen.md` (Fragenkatalog F-01…F-55, Entscheidungslog E-01…E-55) in eine ausführbare Reihenfolge von Arbeitspaketen. Es ist **keine** neue Fachspezifikation: Die Details stehen in `1_Frontendstruktur.md`, `2_Datenbank.md` und `3_Git_Shenanigans.md`; dieses Dokument legt fest, *was in welcher Reihenfolge gebaut wird* und *wann ein Arbeitspaket fertig ist*.

> Ein Eintrag ohne Arbeitspaket ist kein Plan. Jedes Arbeitspaket erhält eine ID (`U-xx`), einen Status und eine *Definition of Done*; umgesetzte Entscheidungen aus `4_Offene_Fragen.md` werden über ihre E-ID referenziert. Der Fortschritt wird in den Statusspalten sichtbar gehalten, Abweichungen kommen in die *Änderungshistorie*.

## Aufbau und Pflege

| Feld | Bedeutung |
|---|---|
| `ID` | Eindeutige Arbeitspaketnummer (`U-01`, `U-02`, …); einmal vergeben, nie wiederverwendet |
| `Phase` | Abschnitt aus *Der Plan (tm)*; Phasen laufen grundsätzlich in der angegebenen Reihenfolge |
| `Status` | `Offen`, `In Arbeit`, `Fertig` |
| `Bezug` | Fundstelle in Dokument oder Code |
| `E-IDs` | Umgesetzte Entscheidungen aus `4_Offene_Fragen.md` |

Regeln für die Pflege:

- Ein Arbeitspaket gilt erst als „fertig", wenn alle Punkte der *Definition of Done* der zugehörigen Phase abgehakt sind.
- Jedes Arbeitspaket schließt mindestens eine `F-`-Frage oder einen `E-`-Eintrag ab; ein neuer Eintrag in `4_Offene_Fragen.md` erzeugt hier ein neues Arbeitspaket.
- Wird ein `E-`-Eintrag überholt, kehrt das Arbeitspaket auf `In Arbeit` zurück; Begründung und Datum kommen in die *Änderungshistorie*.
- Ein „Durchstich" ist ein durchklickbarer End-to-End-Verkauf (Start → … → Verabschiedung); er ist zugleich das maßgebliche Abnahmekriterium des Prototyps.

Stand der letzten Durchsicht: **2026-09-22**.

## Offene Fragen

Alle Fragen aus `4_Offene_Fragen.md` sind entschieden (E-01…E-55); es gibt **keine P0-Frage mehr**. Verbleibend sind nur Festlegungstermine und Dokumentationsaufgaben, die hier einem Arbeitspaket zugeordnet werden:

| ID | Restfrage | Behandlung | Festlegung in |
|---|---|---|---|
| F-08 / E-17 (vgl. E-05) | Umstellung auf ARB-Dateien (`l10n.yaml`): zu welchem Zeitpunkt? | Migrationszeitpunkt wird zu Beginn von Phase 7 bestimmt | `U-70` |
| E-33 | Changelog-Struktur (basiert auf GitHub Releases) | wird mit dem ersten Tag `v*` erstellt | `U-61` |
| E-43 | Anbieterwahl für gehostete Datenbank + REST-Schicht | Entscheidung **vor** dem ersten Release | `U-62` |
| E-42 | Signierung Android/Windows/Linux | bewusst aufgeschoben (Nicht-Ziel, s. u.) | – |
| E-54 | Aufbewahrungs-/Purge-Konzept | wird dokumentiert, nicht implementiert | `U-73` |

## Mögliche, noch zu lösende Probleme

Zusammengeführt aus den *Risiken* in `4_Offene_Fragen.md` und den Abschnitten *Mögliche Probleme* der Detaildokumente. Jedes Problem ist dem Arbeitspaket zugeordnet, in dem es aufgelöst oder entschieden wird.

| Problem | Auswirkung | Auflösung in | Lösungsansatz |
|---|---|---|---|
| Datenlayer ohne Tests driftet vom REST-Vertrag ab (Contract first, E-04) | Umstieg auf die Produktionsdatenbank wird teuer | `U-15` | Repository-Unit-Tests gegen das Interface gehören zur DoD von Phase 1 — für `InMemoryRepository` und `SqliteRepository`. |
| Web-Build besitzt keine Persistenz (E-11) | Demo verliert Daten beim Reload — für den Prototyp akzeptiert | `U-14` | Für den Prototyp akzeptiert; falls später nötig: Persistenz über `localStorage`/IndexedDB hinter demselben Repository-Vertrag (vgl. `2_Datenbank.md`). |
| Globaler Zustand als `static ValueNotifier` (E-46) | parallele Tests unmöglich; Reset-Hilfe nötig | `U-51` | Zustand in ein `AppState`-Objekt bündeln, in `main()` erzeugen und über `InheritedNotifier` (Konstruktor-Parameter für Tests) bereitstellen; statische Felder entfallen. Zwischenlösung: zentrale Reset-Funktion für `setUp` (vgl. `test/widget_test.dart:14-18`). |
| `Colors.blue`-Seed erfüllt WCAG AA nicht (E-40) | Barrierefreiheitsziel verfehlt | `U-71` | Seed verdunkeln, z. B. `Colors.blue.shade900`/`Color(0xFF0D47A1)`, und Kontrast (WCAG AA ≥ 4,5:1) in Hell und Dunkel als Tabelle plus automatisiertem Check nachweisen. |
| `google_fonts` lädt Schriften zur Laufzeit (E-38/F-13/F-44) | Offline-Ausfall und DSGVO-Risiko | `U-72` | Poppins/Lato statisch als Assets bündeln (OFL), `fonts:`-Block in `pubspec.yaml`, `GoogleFonts.*` durch `TextStyle(fontFamily: …)` ersetzen, Abhängigkeit entfernen; Offline-Check. |
| Gemischte Zeilenenden CRLF/LF (E-36) | Rausch-Diffs in der Dokumentation | `U-02` | `.gitattributes` (`* text=auto`, `*.md text eol=lf`) ist angelegt; die Grundlagendokumente sind auf LF normalisiert (`git ls-files --eol`), der `git diff` ist rauschfrei. |
| Gemischte Dateinamen, doppelte Backlogs in `1_`/`3_` (E-35) | Verweise brechen, Inhalte duplizieren | `U-01`, `U-03` | Dateiname an die übrigen Grundlagendokumente angeglichen (`git mv` → `4_Offene_Fragen.md`, E-35) und alle Verweise mitgezogen (Suche leer); doppelte Backlog-Einträge auf einen Verweis je F-/E-ID reduziert. |
| `1_Frontendstruktur.md` behauptet, `flutter_localizations` fehle — ist vorhanden | veraltete Doku führt zu Fehlentscheidungen | `U-03` (Dokumentationsabgleich) | Punkt am 2026-09-22 in `1_Frontendstruktur.md` korrigiert (E-05: `Map` je Sprache; ARB-Migration folgt mit F-08/E-17) und im Dokumentationsabgleich von `4_Offene_Fragen.md` gestrichen. |
| CI-Runner ohne Android-SDK/Java (F-32) | Android-Build bricht | `U-60` | GitHub-Runner liefern das Android-SDK bereits; im Workflow `actions/setup-java@v4` (Temurin 17) vor `subosito/flutter-action@v2`, Lizenzen via `flutter doctor --android-licenses` akzeptieren. |
| Flutter-Artefakte sind mehrere 10 MB groß | Repository bläht auf | `U-60` (Artefakte nur bei Tags) | Nichts committen (`build/` bleibt in `.gitignore`); bei `main` als Workflow-Artifact mit `retention-days: 90`, bei Tags als GitHub Release (`softprops/action-gh-release`). |
| Fehlendes `--base-href` (E-44/F-38) | Web-Build lädt Ressourcen von falscher Wurzel | `U-62` | Im Deploy-Job `flutter build web --release --base-href` mit `/<repo>/` (Slug exakt, z. B. `/Testautomat/`; Wert dynamisch aus `github.event.repository.name`); danach `<base href>` in `build/web/index.html` prüfen. |
| Preis-/Verkaufszeitlogik ohne Tests (F-40) | Rechenfehler wandern unbemerkt in die Simulation | `U-34` | Logik in reine Klassen (`lib/logic/`) extrahieren; parametrisierte Unit-Tests für Taktraster/Aufrunden und Cent-Werte (E-15/E-02), UTC-Grenzfälle der Verkaufszeit (E-14/E-03) sowie Belegnummern (E-16). |
| Laufender Uhr-Timer in Tests | hängende Tests | `U-51` | Uhr über eine injizierbare `Clock` statt `Timer.periodic` im Widget-State führen; Tests pinnen die Zeit (`tester.pump`) und räumen über einen zentralen `disposeApp`-Helfer auf; Timer pausiert im Hintergrund (E-26/U-71). |

## Der Plan (tm)

**Ziel:** Ein durchklickbarer Prototyp (sechs Bildschirme, simulierte Zahlung, Debug-Bildschirm, CI/CD, Web-Hosting), der die Entscheidungen E-01…E-55 nachweist.

**Nicht-Ziele** (bewusst nicht im Prototyp): Store-Distribution (E-30), Signierung (E-42), macOS/iOS (E-01/E-28), Self-Update-Rollout (E-31), Kiosk-Betrieb (E-32), Löschung von Verkaufsdaten (E-54).

Damit ist jeder Eintrag E-01…E-55 mindestens einmal einem Arbeitspaket, einem Nicht-Ziel oder dem Abschnitt *Bestand* zugeordnet.

### Meilensteine

| Meilenstein | Inhalt | Phase |
|---|---|---|
| M0 | Dokumentation konsolidiert (Dateinamen, Zeilenenden, Index, README) | 0 |
| M1 | Datenlayer: alle Repository-Methoden, Migrationen, deterministische Seeds | 1 |
| M2 | Durchklickbarer Kaufablauf inklusive Fehlerbildschirm | 2–3 |
| M3 | Debug-Bildschirm liest und schreibt über den Repository-Vertrag | 4 |
| M4 | CI/CD grün, Erst-Release mit Artefakten, Web auf GitHub Pages | 5–6 |

### Bestand (bereits umgesetzt)

Diese Entscheidungen sind im aktuellen Stand bereits umgesetzt; sie benötigen kein eigenes Arbeitspaket und werden über die Tests aus Phase 5 abgesichert.

| E-IDs | Umsetzung | Bezug |
|---|---|---|
| E-05 | Mehrsprachigkeit über eine schlanke `Map` je Sprache; die ARB-Migration folgt in `U-70` | `lib/l10n/app_localizations.dart` |
| E-08 | Die Sprachauswahl beschriftet sich selbst („Deutsch"/„English") | `lib/widgets/language_selector.dart` |
| E-09 | Die Selektoren nutzen ihre Tooltips zugleich als Semantik-Label | `lib/widgets/theme_selector.dart` |

### Phase 0 — Dokumentations-Hygiene

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-01` | Dateinamen an die übrigen Grundlagendokumente angeglichen (`4_Offene_Fragen.md`, E-35); alle eingehenden Verweise gezogen und geprüft | E-35 | Fertig |
| `U-02` | `.gitattributes` für einheitliche Zeilenenden angelegt; Zeilenenden der Grundlagendokumente einmalig vereinheitlicht | E-36 | Fertig |
| `U-03` | `doc/plan/README.md` als Übersichtsseite (Index, Kurzbeschreibung, Lesereihenfolge, Kennungen) angelegt; *Dokumentationsabgleich* aus `4_Offene_Fragen.md` abgearbeitet | E-37 | Fertig |
| `U-04` | README auf Projektzweck, Zielplattformen, Getting Started, Downloads, Status (CI-Badge) und DSGVO-Hinweis umgestellt | E-34 | Fertig |

**Definition of Done:** keine Verweise auf alte Dateinamen mehr (Suche leer); `git diff` nach der Normalisierung rauschfrei; README ohne Boilerplate-Texte.

### Phase 1 — Datenlayer (Contract first)

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-10` | `drift`, `drift_flutter` und `sqlite3` in `pubspec.yaml` aufgenommen; `lib/data/` angelegt | E-49 | Fertig |
| `U-11` | Unveränderliche DTOs (`Maschine`, `Preissetting`, `Verkaufszeit`, `Telemetrie`, `Verkauf`, `VerkaufDraft`, `Tagesumsatz`) mit `fromJson`/`toJson` und `snake_case`-Mapping; Interface `ParkautomatRepository` erstellt | E-04 | Fertig |
| `U-12` | Migrationsmechanik: Drift-Schema in `lib/data/drift/app_database.dart`; `schema_version` protokolliert Version, Name, Zeitpunkt und SHA-256-Prüfsumme; dokumentierte DDL in `lib/data/migrations/0001_initial.sql` | E-50 | Fertig |
| `U-13` | Deterministische, idempotente Seed-Daten (`lib/data/seed_data.dart`), identisch für Demo, Tests und CI | E-52 | Fertig |
| `U-14` | `InMemoryRepository` (Web-Build und Tests) | E-11 | Fertig |
| `U-15` | `SqliteRepository` (Desktop) auf Drift-Basis inklusive atomarem `createSale` (Transaktion, Validierung, Belegnummern-Vergabe) | E-49, E-04, E-16 | Fertig |
| `U-16` | Composition Root in `main.dart` (`createDefaultRepository` per Conditional Import: Web → InMemory, Desktop → SQLite) und `AppScope` für den Widget-Baum | E-11, E-04 | Fertig |

**Definition of Done:** alle Vertragsmethoden in beiden Implementierungen; Repository-Unit-Tests gegen das Interface; Migration von Version 0 auf aktuell reproduzierbar; `flutter test` grün.

### Phase 2 — Navigation und gemeinsames Layout

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-20` | Kopf-, Mittel- und Fußzeile als wiederverwendbare Widgets extrahiert: `AppHeader`, `AppFooter` und `ScreenShell` samt `AppClock` (30-s-Takt) | E-21 | Fertig |
| `U-21` | `Navigator` mit benannten Routen für die sechs Bildschirme (`lib/routes.dart`) inklusive Zustandsübergängen | E-13 | Fertig |
| `U-22` | Die sechs Screens als Gerüste mit dem gemeinsamen Layout aus `0_Einfuehrung.md` angelegt (`lib/screens/`) | E-06, E-07 | Fertig |
| `U-23` | Maschine beim App-Start über `getMachine()` geladen und über `AppMachine.maschineNotifier` bereitgestellt (E-53); Platzhalter entfernt; Lade- und Fehlerbildschirm „Automat außer Betrieb“ im `MachineLoader` | E-55, F-16, E-23, E-53 | Fertig |

**Definition of Done:** alle Übergänge erreichbar; kein hartkodierter Maschinenzustand; der Fehlerpfad zeigt den Fehlerbildschirm.

### Phase 3 — Fachliche Regeln und Kaufablauf

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-30` | Verkaufszeit-Prüfung in `lib/logic/verkaufszeit.dart` (GMT-Basis, optionale Zeitzone, Gültigkeitsfenster); der Einstieg des Automaten folgt der Verkaufszeit | E-14, E-03 | Fertig |
| `U-31` | Preisbildung in `lib/logic/preis.dart` (Aufrundung auf volle Takte, Cent-`INTEGER`, aktive Preisregel); Betrags- und Parkdaueranzeige | E-15, E-02 | Fertig |
| `U-32` | Belegnummer (Hash aus Geräte-ID, Zähler und Einschaltzeit) nach `lib/logic/belegnummer.dart` überführt; Eindeutigkeit in beiden Repositories abgesichert | E-16 | Fertig |
| `U-33` | Simulierter Zahlungsablauf mit Fortschritt, Timeout und Abbruch; Abschluss über das atomare `createSale`, Beleg als Anzeige auf dem Parkinfo-Bildschirm | E-51, E-16 | Fertig |
| `U-34` | Unit-Tests für Preis-, Verkaufszeit- und Belegnummernlogik sowie für den Zahlungsablauf | E-45, F-40 | Fertig |

**Definition of Done:** Meilenstein M2 erreicht — von Start bis Verabschiedung durchklickbar, ohne Datenbankzugriff aus den Widgets; alle Rechenregeln getestet.

### Phase 4 — Debug-Bildschirm

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-40` | Zugang über verborgene Geste (5× Tap auf die Fußzeilen-Debugangabe) und PIN (`AppDebug`); im Produktivbuild sind Änderungen gesperrt (schreibgeschützt, `kReleaseMode`) | E-22, F-15, F-30 | Fertig |
| `U-41` | Verkäufe als Tabelle und Balken aus derselben Zeitreihe von `getTagesumsaetze` (Gruppierung an den UTC-Tagesgrenzen, Anzeige lokal) | E-12, E-03 | Fertig |
| `U-42` | Telemetrie nur lesend als Tabelle (jüngste Messpunkte) | E-10 | Fertig |
| `U-43` | Preissettings und Verkaufszeiten über Dialoge bearbeiten — ausschließlich über `updatePreissetting`/`updateVerkaufszeit` | E-04 | Fertig |

**Definition of Done:** Akzeptanzkriterien aus `2_Datenbank.md` (Abschnitt *Debug-Bildschirm*) erfüllt; keine Widgets mit direktem Datenbankzugriff.

### Phase 5 — Qualität, Tests und CI-Grundlage

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-50` | Widget-Tests je Bildschirm (Aus, Start, Parkzeit, Parkinfo, Verabschiedung; dazu Zahlung, Debug und Bootstrap), i18n-Paritätstest `de`/`en` samt sichtbarer Debug-Meldung für fehlende Schlüssel sowie Semantik- und Fokus-Tests | E-45, E-39, E-25 | Fertig |
| `U-51` | Globaler Zustand in `AppState` gebündelt (Theme, Sprache, Maschine, Debug-Zugang, Uhr) und über den `AppScope` injiziert; statische Felder entfallen, Tests erzeugen eigene Zustände (`pumpeApp`/`pumpeBildschirm`), der Uhr-Takt endet mit dem letzten Nutzer | E-46, F-41 | Fertig |
| `U-52` | Lokales Gate `tool/gate.ps1` (`dart format --set-exit-if-changed lib test`, `flutter analyze`, `flutter test`); README und `3_Git_Shenanigans.md` verweisen darauf | E-45, E-47 | Fertig |

**Definition of Done:** Gate lokal reproduzierbar; Coverage-Schwelle folgt erst nach stabiler Basis (E-45).

### Phase 6 — CI/CD, Release und Hosting

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-60` | `.github/workflows/build.yml` im Repository-Root: Gate-Job (`test`), Build-Matrix (android, windows, linux, web), Artefakte bei `main`, Release bei Tags `v*`; un-signierte Artefakte. In mehreren CI-Läufen sind Gate und alle vier Plattform-Builds grün | E-29, E-33, E-42 | Fertig |
| `U-61` | Version aus `pubspec.yaml`, annotierter Tag `v0.1.0` gesetzt; der Tag-Lauf hat alle vier Artefakte an das Release gehängt (Changelog = Release-Notes, E-33) | E-33 | Fertig |
| `U-62` | Web-Build mit `--base-href=/<repo>/` (E-44) und Pages-Deploy über `actions/deploy-pages`; GitHub Pages ist aktiviert, der Deploy läuft bei jedem Push auf `main`; live verifiziert: `https://reyneke.github.io/Testautomat/` liefert HTTP 200 mit `<base href="/Testautomat/">` und allen Assets (`flutter_bootstrap.js`, `flutter.js`, `manifest.json`, `favicon.png`); README verweist auf `/releases/latest`, E-43 ist dokumentiert-offen | E-44, F-38, E-43 | Fertig |

**Definition of Done:** Release-Artefakte hängen an Tags; Web-Build online unter `/<repo>/`; CI grün.

### Phase 7 — i18n, Darstellung und DSGVO-Feinschliff

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-70` | `intl`-Formatierung (12-Stunden-Format für Englisch); System-Locale beim ersten Start; Persistenz von Theme und Sprache; Migrationszeitpunkt für ARB/`l10n.yaml` bestimmen und umsetzen | E-18, E-19, E-20, E-17, F-08, E-05 | Offen |
| `U-71` | Seed-Farbe verdunkeln und Kontrast gegen WCAG AA prüfen; scrollbarer Mittelbereich; „Bewegung reduzieren" respektieren; Uhr-Timer pausiert im Hintergrund (Takt bleibt 30 s) | E-40, E-41, E-24, E-27, E-26 | Offen |
| `U-72` | Schriften (Poppins/Lato) als Assets bündeln statt `google_fonts`-Laufzeitbezug | E-38, F-13, F-44 | Offen |
| `U-73` | DSGVO-konformes Log-Konzept (nur Betriebsdaten, Rotation) und Aufbewahrungs-/Purge-Konzept dokumentieren | E-48, E-54 | Offen |

**Definition of Done:** keine Netzzugriffe für Schriften; alle sichtbaren Texte über den i18n-Layer; Kontrastnachweis dokumentiert.

## Reihenfolge und Abhängigkeiten

- Phase 1 vor Phase 2 (`U-23` benötigt `getMachine`), Phase 3 vor M2, Phase 4 vor M3.
- `U-01`…`U-04` sind unabhängig und können sofort laufen.
- `U-70`…`U-73` können parallel laufen, solange die Phasen 1–4 den Key-Satz von `AppLocalizations` nicht ändern — Änderungen daran zuerst abstimmen.
- `U-60`/`U-62` erst nach `U-52`, damit das Gate vor der Build-Matrix steht.
- `U-04` (README) früh umsetzen, da sie den ersten Eindruck prägt (E-34).

## Änderungshistorie

| Datum | Änderung |
|---|---|
| 2026-09-22 | Pages-Deploy live verifiziert: Push-Lauf `35767538896` komplett grün (Gate, vier Builds, Deploy), alle Deploy-Schritte ausgeführt; `https://reyneke.github.io/Testautomat/` liefert HTTP 200 mit korrektem `<base href="/Testautomat/">` und allen Web-Assets (HTTP 200). Zwei CI-Fehler dabei behoben: die Vorprüfung über die Pages-API entfällt (der Actions-Token darf die Konfiguration nicht lesen und meldete fälschlich „nicht aktiv“; jetzt versucht der Job `actions/configure-pages` direkt und überspringt Upload/Deploy nur bei Misserfolg), und ein ungültiger Skalar (Doppelpunkt+Leerzeichen in `run:`) ist durch einen Block-Skalar ersetzt. Der Release-Job bleibt bei `main`-Pushes bewusst übersprungen (nur Tags `v*`). |
| 2026-09-22 | Phase 6 abgeschlossen: Workflow im Repository-Root mit Gate, Build-Matrix (Android, Windows, Linux, Web) und Release-Job; Tag `v0.1.0` mit vier Artefakten (APK 54,8 MB, Windows-ZIP 13,4 MB, Linux-tar.gz 11,1 MB, Web-ZIP 14,0 MB) veröffentlicht; Web-Build mit `--base-href=/Testautomat/`; GitHub Pages aktiviert, der Pages-Deploy läuft bei jedem Push auf `main`. **Meilenstein M4 erreicht.** |
| 2026-09-22 | Phase 5 umgesetzt (U-50…U-52): Widget-Tests je Bildschirm, i18n-Paritätstest, Semantik-/Fokus-Tests, globaler Zustand als injizierter `AppState` (statische Felder entfernt, Timer-Hygiene) und lokales Gate `tool/gate.ps1`; 118 Tests grün, Gate vollständig durchlaufen. CI-Grundlage für M4 gelegt. |
| 2026-09-22 | Phase 4 umgesetzt (U-40…U-43): verborgener, PIN-geschützter Debug-Bildschirm mit schreibgeschütztem Produktivmodus, Verkaufs-Zeitreihe (Tabelle und Balken aus derselben Quelle), Telemetrie nur lesend sowie Bearbeiten von Preissettings und Verkaufszeiten über das Repository; Tests grün (93 Tests). **Meilenstein M3 erreicht.** |
| 2026-09-22 | Phase 3 umgesetzt (U-30…U-34): Verkaufszeit-Prüfung mit GMT-Basis und optionaler Zeitzone, Preisbildung auf volle Takte in Cent, Belegnummernlogik in `lib/logic/`, simulierter Zahlungsablauf mit Fortschritt, Timeout, Abbruch und Beleg als Anzeige; Logik- und Ablauftests grün (83 Tests). **Meilenstein M2 erreicht.** |
| 2026-09-22 | Phase 2 umgesetzt (U-20…U-23): gemeinsame Kopf-/Fußzeile mit `AppClock`, sechs Bildschirm-Gerüste, benannte Routen und Bootstrap mit Maschinendaten (`AppMachine`) samt Fehlerbildschirm; Widget-, Navigations- und Bootstrap-Tests grün (64 Tests). Der „Aus“-Bildschirm ist über seine Route erreichbar; sein Einstieg folgt mit der Verkaufszeit-Prüfung in `U-30`. |
| 2026-09-22 | Phase 1 umgesetzt (U-10…U-16): Datenlayer mit Drift, DTOs und Repository-Vertrag, `schema_version`-Protokoll, deterministische Seeds, InMemory- und SQLite-Repository sowie Composition Root; Vertrags-, Migrations- und Widget-Tests grün (52 Tests). Meilenstein M1 erreicht. |
| 2026-09-22 | U-03 abgeschlossen: Übersichtsseite `doc/plan/README.md` angelegt (E-37); die Root-README verweist darauf. Phase 0 (Meilenstein M0) ist damit vollständig. |
| 2026-09-22 | U-04 umgesetzt: README beschreibt Projektzweck, Zielplattformen, Getting Started, Downloads, CI-Status und DSGVO-Hinweise; die Phase-0-DoD ist bis auf die Übersichtsseite in `U-03` erfüllt. |
| 2026-09-22 | Phase 0 fortgesetzt: U-01 (Umbenennung und Verweise) und U-02 (`.gitattributes`, Zeilenenden) abgeschlossen; *Dokumentationsabgleich* bereinigt (`0_`, `1_`, `3_`, `4_`); U-03 teilweise erledigt (Übersichtsseite offen). |
| 2026-09-22 | Problem-Tabelle um die Spalte *Lösungsansatz* ergänzt; alle „Lösungsvorschläge?“-Markierungen durch konkrete Ansätze ersetzt. |
| 2026-09-21 | Dokument aus dem Stub `# Umsetzungsplan` aufgebaut: Ziel/Nicht-Ziele, Meilensteine M0–M4, Arbeitspakete U-01…U-73 nach Phasen, Zuordnung von Restfragen und Risiken, Abdeckung E-01…E-55. |