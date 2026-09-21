# Umsetzungsplan

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) übersetzt dieses Dokument die Entscheidungen aus `4_Offene Fragen.md` (Fragenkatalog F-01…F-55, Entscheidungslog E-01…E-55) in eine ausführbare Reihenfolge von Arbeitspaketen. Es ist **keine** neue Fachspezifikation: Die Details stehen in `1_Frontendstruktur.md`, `2_Datenbank.md` und `3_Git_Shenanigans.md`; dieses Dokument legt fest, *was in welcher Reihenfolge gebaut wird* und *wann ein Arbeitspaket fertig ist*.

> Ein Eintrag ohne Arbeitspaket ist kein Plan. Jedes Arbeitspaket erhält eine ID (`U-xx`), einen Status und eine *Definition of Done*; umgesetzte Entscheidungen aus `4_Offene Fragen.md` werden über ihre E-ID referenziert. Der Fortschritt wird in den Statusspalten sichtbar gehalten, Abweichungen kommen in die *Änderungshistorie*.

## Aufbau und Pflege

| Feld | Bedeutung |
|---|---|
| `ID` | Eindeutige Arbeitspaketnummer (`U-01`, `U-02`, …); einmal vergeben, nie wiederverwendet |
| `Phase` | Abschnitt aus *Der Plan (tm)*; Phasen laufen grundsätzlich in der angegebenen Reihenfolge |
| `Status` | `Offen`, `In Arbeit`, `Fertig` |
| `Bezug` | Fundstelle in Dokument oder Code |
| `E-IDs` | Umgesetzte Entscheidungen aus `4_Offene Fragen.md` |

Regeln für die Pflege:

- Ein Arbeitspaket gilt erst als „fertig", wenn alle Punkte der *Definition of Done* der zugehörigen Phase abgehakt sind.
- Jedes Arbeitspaket schließt mindestens eine `F-`-Frage oder einen `E-`-Eintrag ab; ein neuer Eintrag in `4_Offene Fragen.md` erzeugt hier ein neues Arbeitspaket.
- Wird ein `E-`-Eintrag überholt, kehrt das Arbeitspaket auf `In Arbeit` zurück; Begründung und Datum kommen in die *Änderungshistorie*.
- Ein „Durchstich" ist ein durchklickbarer End-to-End-Verkauf (Start → … → Verabschiedung); er ist zugleich das maßgebliche Abnahmekriterium des Prototyps.

Stand der letzten Durchsicht: **2026-09-21**.

## Offene Fragen

Alle Fragen aus `4_Offene Fragen.md` sind entschieden (E-01…E-55); es gibt **keine P0-Frage mehr**. Verbleibend sind nur Festlegungstermine und Dokumentationsaufgaben, die hier einem Arbeitspaket zugeordnet werden:

| ID | Restfrage | Behandlung | Festlegung in |
|---|---|---|---|
| F-08 / E-17 (vgl. E-05) | Umstellung auf ARB-Dateien (`l10n.yaml`): zu welchem Zeitpunkt? | Migrationszeitpunkt wird zu Beginn von Phase 7 bestimmt | `U-70` |
| E-33 | Changelog-Struktur (basiert auf GitHub Releases) | wird mit dem ersten Tag `v*` erstellt | `U-61` |
| E-43 | Anbieterwahl für gehostete Datenbank + REST-Schicht | Entscheidung **vor** dem ersten Release | `U-62` |
| E-42 | Signierung Android/Windows/Linux | bewusst aufgeschoben (Nicht-Ziel, s. u.) | – |
| E-54 | Aufbewahrungs-/Purge-Konzept | wird dokumentiert, nicht implementiert | `U-73` |

## Mögliche, noch zu lösende Probleme

Zusammengeführt aus den *Risiken* in `4_Offene Fragen.md` und den Abschnitten *Mögliche Probleme* der Detaildokumente. Jedes Problem ist dem Arbeitspaket zugeordnet, in dem es aufgelöst oder entschieden wird.

| Problem | Auswirkung | Auflösung in |
|---|---|---|
| Datenlayer ohne Tests driftet vom REST-Vertrag ab (Contract first, E-04) | Umstieg auf die Produktionsdatenbank wird teuer | `U-15` |
| Web-Build besitzt keine Persistenz (E-11) | Demo verliert Daten beim Reload — für den Prototyp akzeptiert | `U-14` |
| Globaler Zustand als `static ValueNotifier` (E-46) | parallele Tests unmöglich; Reset-Hilfe nötig | `U-51` |
| `Colors.blue`-Seed erfüllt WCAG AA nicht (E-40) | Barrierefreiheitsziel verfehlt | `U-71` |
| `google_fonts` lädt Schriften zur Laufzeit (E-38/F-13/F-44) | Offline-Ausfall und DSGVO-Risiko | `U-72` |
| Gemischte Zeilenenden CRLF/LF (E-36) | Rausch-Diffs in der Dokumentation | `U-02` |
| Gemischte Dateinamen, doppelte Backlogs in `1_`/`3_` (E-35) | Verweise brechen, Inhalte duplizieren | `U-01`, `U-03` |
| `1_Frontendstruktur.md` behauptet, `flutter_localizations` fehle — ist vorhanden | veraltete Doku führt zu Fehlentscheidungen | `U-03` (Dokumentationsabgleich) |
| CI-Runner ohne Android-SDK/Java (F-32) | Android-Build bricht | `U-60` |
| Flutter-Artefakte sind mehrere 10 MB groß | Repository bläht auf | `U-60` (Artefakte nur bei Tags) |
| Fehlendes `--base-href` (E-44/F-38) | Web-Build lädt Ressourcen von falscher Wurzel | `U-62` |
| Preis-/Verkaufszeitlogik ohne Tests (F-40) | Rechenfehler wandern unbemerkt in die Simulation | `U-34` |
| Laufender Uhr-Timer in Tests | hängende Tests | `U-51` |

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
| `U-01` | `4_Offene Fragen.md` → `4_Offene_Fragen.md` umbenennen; alle eingehenden Verweise mitziehen und prüfen | E-35 | Offen |
| `U-02` | `.gitattributes` für einheitliche Zeilenenden anlegen; Doku-Dateien einmalig normalisieren | E-36 | Offen |
| `U-03` | `doc/plan/`-Übersichtsseite (Index, Kurzbeschreibung, Lesereihenfolge) anlegen; *Dokumentationsabgleich* aus `4_Offene Fragen.md` abarbeiten | E-37 | Offen |
| `U-04` | README auf Projektzweck, Zielplattformen, Getting Started, Downloads, Status (CI-Badge) und DSGVO-Hinweis umstellen | E-34 | Offen |

**Definition of Done:** keine Verweise auf alte Dateinamen mehr (Suche leer); `git diff` nach der Normalisierung rauschfrei; README ohne Boilerplate-Texte.

### Phase 1 — Datenlayer (Contract first)

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-10` | `drift` (und nötige Plattform-Abhängigkeiten) in `pubspec.yaml` aufnehmen; `lib/data/` anlegen | E-49 | Offen |
| `U-11` | Unveränderliche DTOs (`Maschine`, `Preissetting`, `Verkaufszeit`, `Telemetrie`, `Verkauf`, `VerkaufDraft`, `Tagesumsatz`) mit `fromJson`/`toJson` und `snake_case`-Mapping; Interface `ParkautomatRepository` | E-04 | Offen |
| `U-12` | Migrationsmechanik: `lib/data/migrations/` + `schema_version` (`onCreate`/`onUpgrade`, Checksumme) | E-50 | Offen |
| `U-13` | Deterministische, idempotente Seed-Daten, identisch für Demo, Tests und CI | E-52 | Offen |
| `U-14` | `InMemoryRepository` (Web-Build und Tests) | E-11 | Offen |
| `U-15` | `SqliteRepository` (Desktop) auf Drift-Basis inklusive atomarem `createSale` (Transaktion/`WAL`, Validierung, Belegnummern-Vergabe) | E-49, E-04, E-16 | Offen |
| `U-16` | Composition Root in `main.dart`: Implementierung an genau einer Stelle wählen | E-11, E-04 | Offen |

**Definition of Done:** alle Vertragsmethoden in beiden Implementierungen; Repository-Unit-Tests gegen das Interface; Migration von Version 0 auf aktuell reproduzierbar; `flutter test` grün.

### Phase 2 — Navigation und gemeinsames Layout

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-20` | Kopf-, Mittel- und Fußzeile als wiederverwendbare Widgets extrahieren | E-21 | Offen |
| `U-21` | `Navigator` mit benannten Routen für die sechs Bildschirme inklusive Zustandsübergängen | E-13 | Offen |
| `U-22` | Die sechs Screens als Gerüste mit dem gemeinsamen Layout aus `0_Einfuehrung.md` anlegen | E-06, E-07 | Offen |
| `U-23` | Maschine beim App-Start über `getMachine()` laden und über `AppMachine.maschineNotifier` bereitstellen (aktive Maschine, E-53); Platzhalter `'4711'`/`'Weiden i. d. OPf.'` entfernen; Lade-/Fehlerbildschirm „Automat außer Betrieb" | E-55, F-16, E-23, E-53 | Offen |

**Definition of Done:** alle Übergänge erreichbar; kein hartkodierter Maschinenzustand; der Fehlerpfad zeigt den Fehlerbildschirm.

### Phase 3 — Fachliche Regeln und Kaufablauf

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-30` | Verkaufszeit-Prüfung: UTC-/GMT-Zeitbasis, optionale Zeitzone, „Aus"-Bildschirm | E-14, E-03 | Offen |
| `U-31` | Preisbildung: auf volle Takte aufrunden, Beträge als Cent-`INTEGER` | E-15, E-02 | Offen |
| `U-32` | Belegnummer: Hash aus Geräte-ID, Zähler und Einschaltzeit; Eindeutigkeit absichern | E-16 | Offen |
| `U-33` | Simulierter Zahlungsablauf: Zahlungsart wählen, Fortschritt, Timeout, Abbruch, Beleg als Anzeige; Anbindung an den atomaren `createSale` | E-51, E-16 | Offen |
| `U-34` | Unit-Tests für Preis-, Verkaufszeit- und Belegnummernlogik | E-45, F-40 | Offen |

**Definition of Done:** Meilenstein M2 erreicht — von Start bis Verabschiedung durchklickbar, ohne Datenbankzugriff aus den Widgets; alle Rechenregeln getestet.

### Phase 4 — Debug-Bildschirm

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-40` | Zugang im Produktivbuild nur per Login, schreibgeschützt und verborgen | E-22, F-15, F-30 | Offen |
| `U-41` | Verkäufe als Tabelle und Zeitreihe aus `getTagesumsaetze` (Gruppierung an den UTC-Tagesgrenzen, Anzeige lokal) | E-12, E-03 | Offen |
| `U-42` | Telemetrie nur lesend anzeigen | E-10 | Offen |
| `U-43` | Preissettings und Verkaufszeiten ausschließlich über das Repository bearbeiten | E-04 | Offen |

**Definition of Done:** Akzeptanzkriterien aus `2_Datenbank.md` (Abschnitt *Debug-Bildschirm*) erfüllt; keine Widgets mit direktem Datenbankzugriff.

### Phase 5 — Qualität, Tests und CI-Grundlage

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-50` | Widget-Tests je Bildschirm; i18n-Paritätstest `de`/`en`; Semantik- und Fokus-Tests | E-45, E-39, E-25 | Offen |
| `U-51` | Globalen Zustand über `InheritedNotifier`/Injektion testbar machen; bis dahin zentrale Reset-Hilfe; Hintergrund-Timer sauber beenden | E-46, F-41 | Offen |
| `U-52` | CI-Gate `flutter analyze`, `flutter test`, `dart format --set-exit-if-changed` | E-45, E-47 | Offen |

**Definition of Done:** Gate lokal reproduzierbar; Coverage-Schwelle folgt erst nach stabiler Basis (E-45).

### Phase 6 — CI/CD, Release und Hosting

| ID | Arbeitspaket | E-IDs | Status |
|---|---|---|---|
| `U-60` | `.github/workflows/build.yml`: Gate-Job `test`, Build-Matrix (android, windows, linux, web), Artifacts bei `main`, Release bei Tags `v*`, un-signierte Artefakte | E-29, E-33, E-42 | Offen |
| `U-61` | Version aus `pubspec.yaml`, Tag-Prozess `vX.Y.Z`, Changelog auf Basis der GitHub-Releases | E-33 | Offen |
| `U-62` | Pages-Deploy nur für Web mit `--base-href=/<repo>/`; README-Abschnitt „Downloads" verweist auf `/releases/latest`; Anbieterentscheidung Datenbank/REST vor dem ersten Release | E-44, F-38, E-43 | Offen |

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
| 2026-09-21 | Dokument aus dem Stub `# Umsetzungsplan` aufgebaut: Ziel/Nicht-Ziele, Meilensteine M0–M4, Arbeitspakete U-01…U-73 nach Phasen, Zuordnung von Restfragen und Risiken, Abdeckung E-01…E-55. |