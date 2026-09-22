# Offene Fragen

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) sammelt dieses Dokument die noch ungeklärten Punkte aus allen Grundlagendokumenten. Es ist bewusst **keine** eigene Fachspezifikation: Die Details stehen in `1_Frontendstruktur.md`, `2_Datenbank.md` und `3_Git_Shenanigans.md`; hier werden deren Backlogs zusammengeführt, priorisiert und mit einem Entscheidungsstand versehen.

> Eine offene Frage ohne Antwort ist kein Plan. Jede hier gelistete Frage bekommt eine ID, eine Priorität und – sobald geklärt – ein Datum und eine Begründung. Entschiedene Fragen wandern in den *Entscheidungslog* und werden in das jeweilige Detaildokument zurückgeschrieben.

## Aufbau und Pflege

| Feld | Bedeutung |
|---|---|
| `ID` | Eindeutige Nummer (`F-01`, `F-02`, …); einmal vergeben, nie wiederverwendet |
| `Priorität` | `P0` blockiert den Prototyp, `P1` für den Prototyp wichtig, `P2` später bzw. Produktion |
| `Status` | `Offen`, `In Klärung`, `Entschieden`, `Verworfen` |
| `Bezug` | Fundstelle im Code oder im Detaildokument |

Regeln für die Pflege:

- Eine Frage gilt erst als „entschieden", wenn **Datum**, **Entscheidung** und **Begründung** im Entscheidungslog stehen.
- Wird eine Entscheidung revidiert, bleibt der alte Eintrag erhalten und erhält den Status *überholt* — so bleibt nachvollziehbar, warum etwas geändert wurde.
- Jede `P0`-Frage benötigt einen benannten Verantwortlichen, nicht nur einen Status.
- Widersprüche zwischen Doku und Code gehören in den Abschnitt *Dokumentationsabgleich*, nicht in die Detaildokumente.
- Ist eine Frage entschieden, wird das Ergebnis **zusätzlich** im jeweiligen Detaildokument eingetragen; dieses Dokument verweist dann nur noch darauf.

Stand der letzten Durchsicht: **2026-09-22**.

## Blockierende Fragen (P0)

Diese Punkte verhindern, dass aus dem Skelett ein durchklickbarer Prototyp wird.

| ID | Frage | Bezug | Optionen | Status |
|---|---|---|---|---|
| F-01 | Wie werden die sechs Bildschirme verbunden (Navigation, Zustandsübergänge)? | `start_screen.dart:107` (TODO), `1_Frontendstruktur.md` (Konzept-Platzhalter) | `Navigator` mit benannten Routen; `go_router`; eigener `ValueNotifier<ScreenId>` | Entschieden (E-13) |
| F-02 | Welches Paket liest/schreibt die lokale SQLite-Datei? | `2_Datenbank.md`; in `pubspec.yaml` ist keine Abhängigkeit vorhanden | `sqflite` (+ `sqflite_common_ffi` für Desktop/Tests); `drift` (Codegen, Migrationen, typsichere Queries) | Entschieden (E-49) |
| F-03 | Welchen Speicher nutzt der Web-Build? | `2_Datenbank.md`, `3_Git_Shenanigans.md` | REST-Simulation hinter demselben Repository-Interface; `sqflite_common_ffi_web` (IndexedDB); reiner In-Memory-Datensatz | Entschieden (E-11) |
| F-04 | Welche Zeitbasis entscheidet über die Verkaufszeit (und damit über den „Aus"-Bildschirm)? | `0_Einfuehrung.md`, `2_Datenbank.md` | Gerätezeit; Zeit aus der Datenquelle; NTP mit Plausibilitätsprüfung | Entschieden (E-14) |
| F-05 | Wie wird der Preis aus `takt_minuten` und `preis_pro_takt_cent` gebildet? | `2_Datenbank.md` (`preissetting`) | Preis je angefangenem Takt; Aufrundung auf volle Takte; Mindestpreis | Entschieden (E-15) |
| F-06 | Wie wird die `belegnummer` vergeben (sie ist `UNIQUE`)? | `2_Datenbank.md` (`verkaeufe`) | Fortlaufend je Automat; je Automat und Tag; Kombination aus Geräte-ID und Zähler | Entschieden (E-16) |
| F-07 | Wie läuft die simulierte Zahlung im Detail ab? | `0_Einfuehrung.md` (Bar/Karte, Parkschein) | Abbruch durch den Nutzer; Rückgeld-Anzeige; Timeout; Beleg als Anzeige/PDF/Druck | Entschieden (E-51) |

## Frontend und Mehrsprachigkeit

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-08 | Ab wann wird von der eigenen `Map` auf ARB-Dateien mit `l10n.yaml` migriert? | `lib/l10n/app_localizations.dart`, `1_Frontendstruktur.md` (dort noch als offen geführt) | Entschieden (E-17) |
| F-09 | Wie wird ein fehlender Übersetzungsschlüssel behandelt? Derzeit liefert `_get()` stillschweigend den Key selbst zurück; zudem können die `de`- und `en`-Maps auseinanderlaufen. | `app_localizations.dart:64-81` | Entschieden (E-39) |
| F-10 | Datum und Uhrzeit weiterhin mit eigenen Methoden formatieren oder auf `intl` (`DateFormat`) umstellen? Auffällig: `formatDate` liefert für Englisch `09/18/2026`, das 12-Stunden-Format (AM/PM) fehlt. | `app_localizations.dart:84-98`; `intl` ist keine Abhängigkeit | Entschieden (E-18) |
| F-11 | Folgt die Sprache beim ersten Start der Systemeinstellung des Geräts? Derzeit startet die App fest mit `de`. | `app_locale.dart:15-18` | Entschieden (E-19) |
| F-12 | Werden Theme und Sprache über einen Neustart hinweg gemerkt? Beide Zustände liegen nur im Arbeitsspeicher. | `app_theme.dart:11`, `app_locale.dart:18` | Entschieden (E-20) |
| F-13 | Werden die Schriften (Poppins/Lato) als Asset gebündelt statt zur Laufzeit geladen? `google_fonts` lädt fehlende Schriften bei Bedarf über das Netz — für einen Automaten im Offline-Betrieb ein Risiko. | `app_theme.dart:33-101` | Entschieden (E-38, vgl. F-44) |
| F-14 | Werden Kopf-, Mittel- und Fußzeile als wiederverwendbare Widgets extrahiert? Derzeit baut sie jeder Bildschirm selbst; `StartScreen` enthält sie inline. | `start_screen.dart:73-152`, `1_Frontendstruktur.md` (Basiskomponenten) | Entschieden (E-21) |
| F-15 | Über welche Geste ist der Debug-Bildschirm erreichbar, und ist er im Produktivbuild deaktiviert oder schreibgeschützt? | `0_Einfuehrung.md`, `2_Datenbank.md` (Debug-Bildschirm) | Entschieden (E-22) |
| F-16 | Wann werden Automatennummer und Standort aus dem Repository statt aus Konstanten bezogen? | `start_screen.dart:28-29` | Entschieden (E-55) |
| F-17 | Wie sieht die Oberfläche während des Ladens und im Fehlerfall aus (Datenquelle nicht erreichbar, leere Preissettings)? | bisher nicht vorhanden | Entschieden (E-23) |

### Barrierefreiheit und Darstellung

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-18 | Erfüllt der `Colors.blue`-Seed in Hell und Dunkel die Kontrastanforderungen (WCAG 2.1 AA, mindestens 4,5:1 für Fließtext)? | `app_theme.dart:15-29`, `1_Frontendstruktur.md` | Entschieden (E-40) |
| F-19 | Wie verhält sich das Layout bei stark vergrößerter Schrift? Die Bildschirme nutzen feste `Column`-Aufbauten ohne Scrollmöglichkeit; die Fußzeile fängt Überläufe bereits mit `Wrap` ab. | `start_screen.dart:57-70`, `119-135` | Entschieden (E-41) |
| F-20 | Wird die Systemeinstellung „Bewegung reduzieren" (`MediaQuery.disableAnimations`) respektiert? | `1_Frontendstruktur.md` | Entschieden (E-24) |
| F-21 | Gibt es automatisierte Tests für Semantik und Fokusreihenfolge (Screenreader-Labels existieren bereits für Logo und Selector-Tooltips)? | `start_screen.dart:85-89`, `test/widget_test.dart` | Entschieden (E-25) |
| F-22 | Muss die Uhr im Sekunden- statt im 30-Sekunden-Takt aktualisiert werden? Die Anzeige kann bis zu 30 Sekunden nachlaufen. | `start_screen.dart:38` | Entschieden (E-26) |
| F-23 | Pausiert der Uhr-Timer, wenn der Bildschirm verdeckt oder die App im Hintergrund ist? Relevant für Akkuverbrauch und Dauerbetrieb. | `start_screen.dart:34-50` | Entschieden (E-27) |

## Daten und Datenbank

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-24 | Wo liegen die Migrationsskripte und wie wird `schema_version` fortgeschrieben (`onCreate`/`onUpgrade`)? | `2_Datenbank.md` | Entschieden (E-50) |
| F-25 | Wo liegen die Seed-Daten und sind sie deterministisch (gleiche Startwerte für Tests und CI)? | `2_Datenbank.md` | Entschieden (E-52) |
| F-26 | Was bedeutet die `kundennummer` genau, und ist sie personenbeziehbar? Falls ja, muss sie pseudonymisiert oder gestrichen werden. | `2_Datenbank.md` (`maschine.kundennummer`) | Entschieden (E-10) |
| F-27 | Wird die Telemetrie-Tabelle aufgenommen (Stromverbrauch, Batteriestand, Signalstärke, Packetloss)? | `2_Datenbank.md` (Backlog) | Entschieden (E-10) |
| F-28 | Enthält eine Datenbank genau einen Automaten oder viele? `getMachine` liefert bislang ein einzelnes Objekt. | `2_Datenbank.md` (REST-Mapping) | Entschieden (E-53) |
| F-29 | Wie lange werden Verkäufe aufbewahrt (steuerliche Aufbewahrungsfristen vs. Datensparsamkeit)? | `2_Datenbank.md`, `0_Einfuehrung.md` | Entschieden (E-54) |
| F-30 | Wie wird verhindert, dass Preissettings und Verkaufszeiten im Produktivbetrieb geändert werden? Der Debug-Bildschirm darf schreiben. | `2_Datenbank.md` (Debug-Bildschirm) | Entschieden (E-22, vgl. F-15) |

## Build, Release und Hosting

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-31 | Wie wird der Widerspruch zwischen „alle Betriebssysteme" und den Nicht-Zielplattformen macOS/iOS aufgelöst? Das Basisdokument ist entsprechend zu präzisieren. | `0_Einfuehrung.md` (Bauziele), `3_Git_Shenanigans.md` | Entschieden (E-28) |
| F-32 | Wann entstehen die Workflows? Ein `.github/workflows`-Verzeichnis existiert noch nicht, geplant ist `build.yml` mit Test-Gate und Build-Matrix. | `3_Git_Shenanigans.md` | Entschieden (E-29) |
| F-33 | Wer signiert die Android-, Windows- und Linux-Artefakte, und welche Zertifikate/kostenpflichtigen Dienste werden dafür benötigt? | `3_Git_Shenanigans.md` | Entschieden (E-42) |
| F-34 | Werden zusätzliche Distributionskanäle bedient (Play Store, MS Store, winget, Flatpak)? | `3_Git_Shenanigans.md` | Entschieden (E-30) |
| F-35 | Welcher Anbieter hostet in der Produktion die Datenbank, wo läuft die REST-API, und wie erfolgt die Authentifizierung? | `3_Git_Shenanigans.md` | Entschieden (E-43) |
| F-36 | Wie gelangt ein Update auf den Automaten (manueller Download, Self-Update, OTA)? | `3_Git_Shenanigans.md` | Entschieden (E-31) |
| F-37 | Wird ein Kiosk-Betrieb vorgesehen (Autostart, Vollbild, unterdrückter Ruhezustand)? | nicht spezifiziert | Entschieden (E-32) |
| F-38 | Wird `--base-href` für die GitHub-Pages-Projektseite korrekt gesetzt? Ohne diesen Parameter lädt der Web-Build seine Ressourcen von der falschen Wurzel. | `3_Git_Shenanigans.md` (Hosting) | Entschieden (E-44) |
| F-39 | Wie werden Versionen vergeben, wer taggt, und wird ein Changelog gepflegt? | `pubspec.yaml` (`1.0.0+1`), `3_Git_Shenanigans.md` | Entschieden (E-33) |

## Qualität, Tests und Werkzeuge

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-40 | Welche Teststrategie gilt (Unit-Tests für Preise/Verkaufszeiten/i18n-Parität, Widget-Tests je Bildschirm, Golden-Tests) und ab welcher Abdeckung greift das CI-Gate? | `test/widget_test.dart` | Entschieden (E-45) |
| F-41 | Bleibt der globale Zustand in `static ValueNotifier`-Feldern, oder wird er über `InheritedNotifier`/Provider injizierbar gemacht? Aktuell setzt jeder Test den Zustand zurück, parallele Tests sind damit nicht möglich. | `app_theme.dart`, `app_locale.dart`, `test/widget_test.dart:14-18` | Entschieden (E-46) |
| F-42 | Werden die Lint-Regeln über `flutter_lints` hinaus verschärft, und läuft `dart format` als Prüfschritt in der CI? | `analysis_options.yaml` (nur Standardregeln) | Entschieden (E-47) |
| F-43 | Welche Logs und Fehlerberichte entstehen im Betrieb, ohne personenbezogene Daten zu sammeln? | `0_Einfuehrung.md` (DSGVO-Grenzen) | Entschieden (E-48) |

## Recht, Dokumentation und Repository-Hygiene

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-44 | Ist der Abruf der Schriften über `google_fonts` datenschutzrechtlich vertretbar (IP-Übertragung an Dritte), oder werden die Schriften aus diesem Grund gebündelt? | `app_theme.dart`, `0_Einfuehrung.md` (DSGVO) | Entschieden (E-38) |
| F-45 | Wann wird die README vom Flutter-Boilerplate auf den Projektzweck, die Zielplattformen und einen Verweis auf `doc/plan/` umgestellt? | `README.md`, `3_Git_Shenanigans.md` | Entschieden (E-34) |
| F-46 | Soll der Dateiname (bisher mit Leerzeichen) an die übrigen Dateien (`0_Einfuehrung.md`, `1_Frontendstruktur.md`) angeglichen werden? Bei einer Umbenennung sind alle eingehenden Verweise mitzuziehen. | `doc/plan/grundlagen/` | Entschieden (E-35) |
| F-47 | Werden die gemischten Zeilenenden (CRLF in `0_`, `1_`, `3_`; LF in `2_`) per `.gitattributes` vereinheitlicht, damit Diffs sauber bleiben? | `doc/plan/grundlagen/` | Entschieden (E-36) |
| F-48 | Erhält `doc/plan/` eine Übersichtsseite (Index mit Kurzbeschreibung und empfohlener Lesereihenfolge), damit Einsteiger die Dokumente in der richtigen Reihenfolge finden? | `doc/plan/` | Entschieden (E-37) |

## Entscheidungslog

Bereits getroffene Entscheidungen, die dieses Dokument nur noch nachhält. Sie sind im Code bzw. in den Detaildokumenten belegt und gelten, bis sie hier ausdrücklich als *überholt* markiert werden.

| ID | Datum | Entscheidung | Begründung | Belegt in |
|---|---|---|---|---|
| E-01 | 2026-09-18 | Nicht-Zielplattformen sind macOS und iOS. | Keine Signierumgebung und kein Apple-Account vorhanden; Releases beschränken sich auf kostenlose GitHub-Runner. | `3_Git_Shenanigans.md` |
| E-02 | 2026-09-18 | Geldbeträge werden in Cent als `INTEGER` gespeichert. | Fließkommazahlen erzeugen Rundungsfehler. | `2_Datenbank.md` |
| E-03 | 2026-09-18 | Zeitstempel liegen in UTC als ISO-8601-Text, die Anzeige erfolgt lokal. | Vermeidet Fehler beim Wechsel von Sommer- und Winterzeit. | `2_Datenbank.md` |
| E-04 | 2026-09-18 | Alle Datenzugriffe laufen über ein Repository-Interface mit unveränderlichen DTOs („Contract first"), auch schreibend aus dem Debug-Bildschirm. | SQLite im Prototyp und REST in der Produktion bleiben austauschbar. | `2_Datenbank.md` |
| E-05 | 2026-09-18 | Mehrsprachigkeit wird ohne ARB-Codegen als schlanke `Map` je Sprache umgesetzt. | Hält den Prototyp abhängigkeitsarm; die Aufrufstellen (`AppLocalizations.of(context).xyz`) bleiben bei einer späteren Migration unverändert. Offen bleibt nur der Migrationszeitpunkt (F-08). | `lib/l10n/app_localizations.dart:5-11` |
| E-06 | 2026-09-18 | Theme und Sprache sind ein globaler Zustand (`ValueNotifier`) und werden zentral in `main.dart` an die `MaterialApp` gebunden — nicht je Bildschirm. | Wechsel zur Laufzeit ohne Neustart, keine doppelte Zustandshaltung. | `main.dart:22-48` |
| E-07 | 2026-09-18 | Standard-Theme ist Dunkel. | Vorgabe aus `1_Frontendstruktur.md`; der frühere Startwert `ThemeMode.light` ist damit überholt. | `app_theme.dart:10-13` |
| E-08 | 2026-09-18 | Die Sprachauswahl beschriftet sich selbst („Deutsch"/„English") statt in der aktiven Sprache. | Die Auswahl bleibt verständlich, auch wenn der Nutzer die aktuelle Sprache nicht liest. | `language_selector.dart:5-8` |
| E-09 | 2026-09-18 | Die Tooltips der Selektoren dienen zugleich als Semantik-Label. | Spart Platz in der Fußzeile und beschriftet trotzdem für Screenreader. | `theme_selector.dart:5-10` |
| E-10 | 2026-09-21 | Telemetriedaten werden aufgenommen: Tabelle `telemetrie` (`maschine_id` (FK), `timestamp` (UTC), `stromverbrauch_watt`, `batteriestand_prozent`, `signal_staerke_dbm`, `packetloss_prozent`) plus `kundennummer` auf `maschine`. | Betriebsdaten sind für Debug und Betrieb vorgesehen; die `kundennummer` gehört zu den Stammdaten des Betreibers und ist nicht personenbezogen. | `2_Datenbank.md` |
| E-11 | 2026-09-21 | Der Web-Build nutzt das `InMemoryRepository` mit denselben Seed-Daten wie die SQLite-Datei (ohne Persistenz). | GitHub Pages ist statisch; keine neue Abhängigkeit (die Paketwahl F-02 ist später mit E-49 entschieden worden); deterministische Seeds für Tests und CI; ein späterer Umstieg auf REST bleibt eine Ein-Punkt-Entscheidung. | `2_Datenbank.md` |
| E-12 | 2026-09-21 | Verkäufe erscheinen im Debug-Bildschirm als Zeitreihe des Umsatzes pro Tag — tabellarisch und graphisch. | Tabelle und Grafik nutzen dieselbe Datenbasis (`getTagesumsaetze`). | `2_Datenbank.md` |
| E-13 | 2026-09-21 | Die Navigation erfolgt klassisch per `Navigator` mit benannten Routen. | Hält den Prototyp abhängigkeitsarm und genügt für sechs lineare Bildschirme; `go_router` lohnt erst bei tieferen Links. | `start_screen.dart:107`, `1_Frontendstruktur.md` |
| E-14 | 2026-09-21 | Die Verkaufszeit wird in GMT ausgewertet; der Nutzer kann zusätzlich eine Zeitzone wählen. | Eindeutige Zeitbasis ohne Sommer-/Winterzeit-Fehler, die Anzeige bleibt lokal (E-03). | `0_Einfuehrung.md`, `2_Datenbank.md` |
| E-15 | 2026-09-21 | Der Preis wird auf volle Takte aufgerundet; ein angefangener Takt zählt voll. | Vermeidet Unterpreisung bei Restminuten und ist für den Nutzer nachvollziehbar. | `2_Datenbank.md` (`preissetting`) |
| E-16 | 2026-09-21 | Die Belegnummer ist ein Hash aus Geräte-ID, Zähler und Einschaltzeit. | Eindeutig auch ohne zentrale Vergabe. | `2_Datenbank.md` (`verkaeufe`) |
| E-17 | 2026-09-21 | Auf ARB-Dateien mit `l10n.yaml` wird für alle Texte migriert, die der Nutzer sieht. | Interne und technische Zeichenketten bleiben ausgenommen; die Migration erfolgt gebündelt (vgl. E-05). | `lib/l10n/app_localizations.dart`, `1_Frontendstruktur.md` |
| E-18 | 2026-09-21 | Datum und Uhrzeit werden auf `intl` (`DateFormat`) umgestellt. | Liefert das 12-Stunden-Format für Englisch und korrekte lokale Muster; die eigene Formatierung entfällt. | `app_localizations.dart:84-98` |
| E-19 | 2026-09-21 | Beim ersten Start folgt die Sprache der Systemeinstellung des Geräts. | Erwartetes Verhalten; die manuelle Auswahl bleibt jederzeit möglich. | `app_locale.dart:15-18` |
| E-20 | 2026-09-21 | Theme und Sprache werden über einen Neustart hinweg gemerkt. | Vermeidet wiederholtes Einstellen am Automaten; Ablage z. B. über `shared_preferences`. | `app_theme.dart:11`, `app_locale.dart:18` |
| E-21 | 2026-09-21 | Kopf-, Mittel- und Fußzeile werden als wiederverwendbare Widgets extrahiert. | Die sechs Bildschirme teilen denselben Aufbau; Änderungen erfolgen dann an einer Stelle. | `start_screen.dart:73-152`, `1_Frontendstruktur.md` |
| E-22 | 2026-09-21 | Der Debug-Bildschirm ist im Produktivbuild per Login erreichbar, schreibgeschützt und verborgen. | Verhindert ungewollte Änderungen an Preisen und Verkaufszeiten im Betrieb (schließt auch F-30). | `0_Einfuehrung.md`, `2_Datenbank.md` |
| E-23 | 2026-09-21 | Lade- und Fehlerzustand werden durch einen Fehlerbildschirm „Automat außer Betrieb" abgedeckt. | Ist die Datenquelle nicht erreichbar, darf der Automat keinen Verkauf anbieten. | `1_Frontendstruktur.md`, `2_Datenbank.md` |
| E-24 | 2026-09-21 | Die Systemeinstellung „Bewegung reduzieren" wird als Anforderung übernommen; die Umsetzung im Prototyp ist aufgeschoben. | Das Barrierefreiheitsziel bleibt erhalten und wird mit der Animationsgestaltung umgesetzt. | `1_Frontendstruktur.md` |
| E-25 | 2026-09-21 | Automatisierte Semantik- und Fokus-Tests werden als Testlücke geführt; die Umsetzung steht aus. | Screenreader-Labels sind vorhanden, ihre Prüfung erfolgt mit der Teststrategie (E-45). | `start_screen.dart:85-89`, `test/widget_test.dart` |
| E-26 | 2026-09-21 | Die Uhr aktualisiert im 30-Sekunden-Takt. | Stunden und Minuten genügen; ein Sekundentakt wäre unnötiger Batterieverbrauch. | `start_screen.dart:38` |
| E-27 | 2026-09-21 | Der Uhr-Timer pausiert, wenn die App im Hintergrund ist, und aktualisiert beim Wiederaufruf. | Spart Akku im Dauerbetrieb; die Anzeige ist beim Zurückkehren sofort korrekt. | `start_screen.dart:34-50` |
| E-28 | 2026-09-21 | macOS und iOS bleiben Perspektive, werden aber nicht aktiv ausgebaut. | E-01 gilt weiter; ein Ausbau setzt Macintosh und Apple-Account voraus. | `3_Git_Shenanigans.md` |
| E-29 | 2026-09-21 | Die CI/CD-Workflows werden nach dem Plan in `3_Git_Shenanigans.md` umgesetzt (`build.yml` mit Test-Gate, Build-Matrix und Deploy-Job). | Ein einheitlicher Workflow deckt alle Zielplattformen ab; die Umsetzung folgt mit Schritt 5 der Reihenfolge. | `3_Git_Shenanigans.md` |
| E-30 | 2026-09-21 | Zusätzliche Distributionskanäle (Play Store, MS Store, winget, Flatpak) kommen erst mit einer Weiterentwicklung des Prototyps. | Der Prototyp wird direkt über APK und Installer verteilt. | `3_Git_Shenanigans.md` |
| E-31 | 2026-09-21 | Updates auf dem Automaten laufen per Self-Update. | Der Automat steht im Feld; ein manueller Download je Gerät wäre zu aufwendig. | `3_Git_Shenanigans.md` |
| E-32 | 2026-09-21 | Ein Kiosk-Betrieb (Autostart, Vollbild, unterdrückter Ruhezustand) ist vorgesehen. | Passt zum Einsatz als Automaten-Frontend im Dauerbetrieb. | `3_Git_Shenanigans.md` |
| E-33 | 2026-09-21 | Versionen stammen aus `pubspec.yaml`, Tags setzen die Entwickler, das Changelog basiert auf den GitHub-Releases. | Eine Quelle der Wahrheit für die Version; das Changelog wird noch erstellt. | `pubspec.yaml`, `3_Git_Shenanigans.md` |
| E-34 | 2026-09-21 | Die README wird möglichst bald auf Projektzweck, Zielplattformen und `doc/plan/` umgestellt. | Erster Eindruck für Besucher; die Abschnittsliste steht in `3_Git_Shenanigans.md`. | `README.md`, `3_Git_Shenanigans.md` |
| E-35 | 2026-09-21 | Der Dateiname wird an die übrigen Grundlagendokumente angeglichen (`4_Offene_Fragen.md`); alle eingehenden Verweise werden mitgezogen. | Einheitliche Dateinamen; die Umbenennung erfolgte in einem eigenen Schritt inklusive Verweisprüfung. | `doc/plan/grundlagen/` |
| E-36 | 2026-09-21 | Die Zeilenenden der Grundlagendokumente werden per `.gitattributes` vereinheitlicht. | Gemischte Zeilenenden erzeugen Rausch-Diffs; die Vereinheitlichung erfolgt einmalig. | `doc/plan/grundlagen/` |
| E-37 | 2026-09-21 | `doc/plan/` erhält eine Übersichtsseite mit Kurzbeschreibung und empfohlener Lesereihenfolge. | Erleichtert den Einstieg in die Grundlagendokumente. | `doc/plan/` |
| E-38 | 2026-09-21 | Die Schriften (Poppins/Lato) werden als Assets gebündelt statt zur Laufzeit geladen. | Kein Netzabruf nötig (Offline-Betrieb, F-13) und keine IP-Übertragung an Dritte (DSGVO, F-44). | `app_theme.dart:33-101` |
| E-39 | 2026-09-21 | Fehlende Übersetzungsschlüssel werden über einen Paritätstest der `de`- und `en`-Schlüssel abgesichert; im Debug-Build wird ein fehlender Schlüssel sichtbar gemeldet. | Verhindert stilles Auseinanderlaufen der Sprachdateien; im Release dient der Key als Notanzeige. | `app_localizations.dart:64-81` |
| E-40 | 2026-09-21 | Die Seed-Farbe wird verdunkelt (statt `Colors.blue`); anschließend wird der Kontrast gegen WCAG AA geprüft. | Der helle Button-Kontrast erfüllt die 4,5:1-Anforderung nicht. | `app_theme.dart:15-29` |
| E-41 | 2026-09-21 | Der mittlere Bereich der Bildschirme wird scrollbar; Kopf- und Fußzeile bleiben fixiert. | Bei stark vergrößerter Schrift darf kein Inhalt abgeschnitten werden. | `start_screen.dart:57-70`, `119-135` |
| E-42 | 2026-09-21 | Die Artefakte bleiben in der Prototyp-Phase un-signiert. | Signaturzertifikate verursachen Kosten und Aufwand; die Installationswarnung wird in Kauf genommen. | `3_Git_Shenanigans.md` |
| E-43 | 2026-09-21 | Für die Produktion wird eine gehostete Postgres-Datenbank mit REST-Schicht und Token-Authentifizierung vorgesehen; die Anbieterwahl fällt vor dem ersten Release. | Passt zum REST-Vertrag; der Prototyp bleibt bei E-11. | `3_Git_Shenanigans.md`, `2_Datenbank.md` |
| E-44 | 2026-09-21 | Der Web-Build wird mit `flutter build web --base-href=/<repo>/` erstellt. | GitHub-Pages-Projektseiten liegen unter `/<repo>/`; ohne `--base-href` lädt der Build seine Ressourcen von der falschen Wurzel. | `3_Git_Shenanigans.md` (Hosting) |
| E-45 | 2026-09-21 | Teststrategie: Unit-Tests für Preis-, Verkaufszeit- und i18n-Paritätslogik, Widget-Tests je Bildschirm; das CI-Gate prüft `flutter analyze`, `flutter test` und `dart format --set-exit-if-changed`. | Deckt die fehleranfällige Fachlogik ab; eine Coverage-Schwelle folgt erst nach stabiler Basis. | `test/widget_test.dart`, `3_Git_Shenanigans.md` |
| E-46 | 2026-09-21 | Der globale Zustand bleibt zunächst in `static ValueNotifier`-Feldern und wird über eine zentrale Reset-Hilfe für Tests zurückgesetzt; mit der Navigation wird auf Injektion (`InheritedNotifier`) umgestellt. | Ermöglicht Tests ohne Umbau; echte Testparallelität braucht Dependency Injection. | `app_theme.dart`, `app_locale.dart`, `test/widget_test.dart:14-18` |
| E-47 | 2026-09-21 | `dart format` läuft als Prüfschritt in der CI; die Lint-Regeln werden erst bei Bedarf über `flutter_lints` hinaus verschärft. | Einheitliche Formatierung ohne Reibung; zusätzliche Regeln entstehen aus konkreten Funden. | `analysis_options.yaml` |
| E-48 | 2026-09-21 | Logs enthalten nur Betriebsdaten (Geräte-ID, UTC-Zeitstempel, Ereignistyp, Fehlercode, Betrag in Cent) und werden rotiert. | Erfüllt die DSGVO-Grenzen (keine personenbezogenen Daten) und genügt der Fehlersuche im Automatenbetrieb. | `0_Einfuehrung.md` |
| E-49 | 2026-09-21 | Das Datenlayer verwendet `drift` statt `sqflite`. | Schema-Versionierung und Migrationen passen zur `schema_version`-Planung, typsichere Queries und eine In-Memory-Datenbank für Tests; der Web-Build braucht dank E-11 kein SQLite. | `2_Datenbank.md`, `pubspec.yaml` |
| E-50 | 2026-09-21 | Migrationsskripte liegen im Datenlayer (`lib/data/migrations/`) und werden über die `schema_version`-Tabelle fortgeschrieben. | Nummerierte, transaktionale Schritte bleiben nachvollziehbar; umgesetzt über die Migrationsmechanik von Drift (E-49). | `2_Datenbank.md` |
| E-51 | 2026-09-21 | Die Zahlung wird simuliert: Zahlungsart wählen, Verarbeitung mit Fortschritt und Timeout, Abbruch durch den Nutzer möglich, Beleg als Anzeige mit Belegnummer; kein PDF und kein Druck im Prototyp. | Bildet den Verkaufsablauf ohne echte Zahlungsdienste ab; die Belegnummer folgt aus E-16. | `0_Einfuehrung.md` |
| E-52 | 2026-09-21 | Seed-Daten liegen im Datenlayer, sind idempotent und deterministisch und werden identisch für Tests und CI verwendet. | Gleiche Startwerte für Demo und Tests (vgl. E-11); Wiederholbarkeit bleibt nachvollziehbar. | `2_Datenbank.md` |
| E-53 | 2026-09-21 | Das Datenmodell trägt mehrere Maschinen; der Prototyp betreibt genau eine aktive Maschine. `getMachine()` liefert die aktive Maschine, der REST-Pfad bleibt mit `{id}` erweiterbar. | Die 1:n-Beziehungen sind bereits angelegt; für den Prototyp genügt eine Maschine, der Vertrag bleibt produktionsfähig. | `2_Datenbank.md` |
| E-54 | 2026-09-21 | Für Verkaufsdaten gilt kein Personenbezug; ein Aufbewahrungs- und Purge-Konzept wird dokumentiert, aber im Prototyp nicht implementiert. | Verkäufe sind anonym (vgl. die DSGVO-Grenzen in `0_Einfuehrung.md`); eine Löschfrist wird erst mit der Produktionsperspektive gebraucht. | `2_Datenbank.md`, `0_Einfuehrung.md` |
| E-55 | 2026-09-21 | Automatennummer und Standort werden zentral beim App-Start über das Repository geladen (`getMachine()` → `Maschine`) und stehen als `ValueNotifier<Maschine?>` (`AppMachine.maschineNotifier`) global bereit; der `StartScreen` bezieht seine Debug-Angaben ausschließlich daraus. Schlägt das Laden fehl, greift der Fehlerbildschirm „Automat außer Betrieb" (E-23). | Ein Ladepunkt und ein Fehlerpfad; konsistent zur Zustandshaltung von Theme und Sprache (E-06/E-46); die Umsetzung erfolgt mit dem Datenlayer (E-49 bis E-52), da der Prototyp genau eine aktive Maschine hat (E-53). | `start_screen.dart:28-29`, `2_Datenbank.md`, `1_Frontendstruktur.md` |

## Dokumentationsabgleich

Beim Schreiben dieses Dokuments aufgefallene Widersprüche zwischen Doku und Code. Jeder Punkt ist zu bereinigen und danach hier zu streichen.

- Die am 2026-09-22 bereinigten Punkte sind erledigt und hier gestrichen: `flutter_localizations` und `ThemeMode.light` in `1_Frontendstruktur.md`, die doppelten Backlog-Einträge in `1_`/`3_`, der Widerspruch zu den Bauzielen in `0_Einfuehrung.md` und der Dateiname mit Leerzeichen (F-46).
- `2_Datenbank.md` nennt die Platzhalter `'4711'` und `'Weiden i. d. OPf.'` im Startbildschirm — das trifft weiterhin zu (F-16).

## Risiken

- **Offline-Betrieb:** Ein Automat kann ohne Internet ausfallen. Betroffen sind die Schriften (F-13) und jede Datenquelle, die zur Laufzeit aus dem Netz kommt (F-02).
- **Web und Dateispeicher:** Ein Browser besitzt kein Dateisystem. Mit E-11 ist der Speicher geklärt (InMemory-Repository); braucht die Demo Persistenz über Reloads, muss sie nachgerüstet werden.
- **Doppelte Zustandshaltung:** Solange Bildschirme ihren Zustand selbst halten, laufen Theme, Sprache und Automatendaten auseinander (F-12, F-14, F-41).
- **Testlücken:** Ohne Unit-Tests für Preis- und Verkaufszeitlogik wandern Rechenfehler unbemerkt in die Simulation (F-40).
- **DSGVO-Details:** Font-Abruf (F-44) und Protokollierung (F-43) sind einzeln zu bewerten; die Kundennummer ist mit E-10 als nicht personenbezogen bewertet.
- **Dokumentationsdrift:** Die Detaildokumente beschreiben teils bereits überholte Zustände (siehe *Dokumentationsabgleich*). Ohne festen Pflegerhythmus wächst der Abstand zwischen Doku und Code weiter.

## Empfohlene Reihenfolge

1. **Datenlayer aufbauen** (E-49, E-50, E-52) — Drift, Migrationen und deterministische Seeds; danach die Platzhalter im `StartScreen` ersetzen (F-16).
2. **Navigation und Basiskomponenten umsetzen** (E-13, E-21) — die sechs Bildschirme mit gemeinsamer Kopf- und Fußzeile.
3. **Fachliche Regeln implementieren:** Verkaufszeit (E-14), Preisbildung (E-15), Belegnummern (E-16), Zahlungsablauf (E-51).
4. **Debug-Bildschirm aufsetzen** (E-22, E-10, E-12) — Preise, Verkaufszeiten, Telemetrie und die Umsatz-Zeitreihe sichtbar machen.
5. **Test- und CI-Grundlage schaffen** (E-29, E-45, E-47), damit die nachfolgenden Schritte abgesichert sind.
6. **Release-Themen umsetzen** (E-28 bis E-34, E-42 bis E-44) — spätestens vor dem ersten echten Release.

## Änderungshistorie

| Datum | Änderung |
|---|---|
| 2026-09-19 | Dokument aus dem Stub `# Offene Fragen` aufgebaut: Fragenkatalog (F-01 bis F-48 nach Themengebiet), Entscheidungslog (E-01 bis E-09), Dokumentationsabgleich, Risiken und empfohlene Reihenfolge ergänzt. |
| 2026-09-21 | F-03, F-26 und F-27 entschieden (E-10 bis E-12); Risiken und empfohlene Reihenfolge entsprechend aktualisiert. |
| 2026-09-21 | Alle verbleibenden Fragen entschieden (E-13 bis E-54): Backlog-Antworten formalisiert, Empfehlungen für die Vorschlagsfragen festgehalten und die Grundsatzfragen (Speicherpaket, Zahlungsablauf, Seeds, Maschinen, Aufbewahrung) festgelegt. Offen bleibt nur der Umsetzungspunkt F-16. |
| 2026-09-21 | F-16 entschieden (E-55): Automatennummer und Standort werden beim App-Start über das Repository geladen und im `StartScreen` über `AppMachine.maschineNotifier` dargestellt. |
| 2026-09-22 | Dokumentationsabgleich bereinigt (`1_Frontendstruktur.md`, `0_Einfuehrung.md`, `3_Git_Shenanigans.md`), Dateiname auf `4_Offene_Fragen.md` vereinheitlicht (E-35) und Zeilenenden per `.gitattributes` festgelegt (E-36). |

