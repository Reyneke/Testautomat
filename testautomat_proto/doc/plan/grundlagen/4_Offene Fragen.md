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

Stand der letzten Durchsicht: **2026-09-19**.

## Blockierende Fragen (P0)

Diese Punkte verhindern, dass aus dem Skelett ein durchklickbarer Prototyp wird.

| ID | Frage | Bezug | Optionen | Status |
|---|---|---|---|---|
| F-01 | Wie werden die sechs Bildschirme verbunden (Navigation, Zustandsübergänge)? | `start_screen.dart:107` (TODO), `1_Frontendstruktur.md` (Konzept-Platzhalter) | `Navigator` mit benannten Routen; `go_router`; eigener `ValueNotifier<ScreenId>` | Offen | => Klassisch per Navigator
| F-02 | Welches Paket liest/schreibt die lokale SQLite-Datei? | `2_Datenbank.md`; in `pubspec.yaml` ist keine Abhängigkeit vorhanden | `sqflite` (+ `sqflite_common_ffi` für Desktop/Tests); `drift` (Codegen, Migrationen, typsichere Queries) | Offen |
| F-03 | Welchen Speicher nutzt der Web-Build? | `2_Datenbank.md`, `3_Git_Shenanigans.md` | REST-Simulation hinter demselben Repository-Interface; `sqflite_common_ffi_web` (IndexedDB); reiner In-Memory-Datensatz | Offen |
| F-04 | Welche Zeitbasis entscheidet über die Verkaufszeit (und damit über den „Aus"-Bildschirm)? | `0_Einfuehrung.md`, `2_Datenbank.md` | Gerätezeit; Zeit aus der Datenquelle; NTP mit Plausibilitätsprüfung | Offen | => GMT, aber der Nutzer hat die Option eine Zeitzone zu wählen.
| F-05 | Wie wird der Preis aus `takt_minuten` und `preis_pro_takt_cent` gebildet? | `2_Datenbank.md` (`preissetting`) | Preis je angefangenem Takt; Aufrundung auf volle Takte; Mindestpreis | Offen | => Aufrundung auf vollen Takt.
| F-06 | Wie wird die `belegnummer` vergeben (sie ist `UNIQUE`)? | `2_Datenbank.md` (`verkaeufe`) | Fortlaufend je Automat; je Automat und Tag; Kombination aus Geräte-ID und Zähler | Offen | => Hash aus Geräte-ID, Zähler, Einschaltzeit etc.
| F-07 | Wie läuft die simulierte Zahlung im Detail ab? | `0_Einfuehrung.md` (Bar/Karte, Parkschein) | Abbruch durch den Nutzer; Rückgeld-Anzeige; Timeout; Beleg als Anzeige/PDF/Druck | Offen |

## Frontend und Mehrsprachigkeit

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-08 | Ab wann wird von der eigenen `Map` auf ARB-Dateien mit `l10n.yaml` migriert? | `lib/l10n/app_localizations.dart`, `1_Frontendstruktur.md` (dort noch als offen geführt) | Offen | => Alle texte, welche mit dem User zu tun haben.
| F-09 | Wie wird ein fehlender Übersetzungsschlüssel behandelt? Derzeit liefert `_get()` stillschweigend den Key selbst zurück; zudem können die `de`- und `en`-Maps auseinanderlaufen. | `app_localizations.dart:64-81` | Offen | => Empfehlung?
| F-10 | Datum und Uhrzeit weiterhin mit eigenen Methoden formatieren oder auf `intl` (`DateFormat`) umstellen? Auffällig: `formatDate` liefert für Englisch `09/18/2026`, das 12-Stunden-Format (AM/PM) fehlt. | `app_localizations.dart:84-98`; `intl` ist keine Abhängigkeit | Offen | => Umstellen
| F-11 | Folgt die Sprache beim ersten Start der Systemeinstellung des Geräts? Derzeit startet die App fest mit `de`. | `app_locale.dart:15-18` | Offen | => Ja
| F-12 | Werden Theme und Sprache über einen Neustart hinweg gemerkt? Beide Zustände liegen nur im Arbeitsspeicher. | `app_theme.dart:11`, `app_locale.dart:18` | Offen | => Ja
| F-13 | Werden die Schriften (Poppins/Lato) als Asset gebündelt statt zur Laufzeit geladen? `google_fonts` lädt fehlende Schriften bei Bedarf über das Netz — für einen Automaten im Offline-Betrieb ein Risiko. | `app_theme.dart:33-101` | Offen |
| F-14 | Werden Kopf-, Mittel- und Fußzeile als wiederverwendbare Widgets extrahiert? Derzeit baut sie jeder Bildschirm selbst; `StartScreen` enthält sie inline. | `start_screen.dart:73-152`, `1_Frontendstruktur.md` (Basiskomponenten) | Offen | => Ja
| F-15 | Über welche Geste ist der Debug-Bildschirm erreichbar, und ist er im Produktivbuild deaktiviert oder schreibgeschützt? | `0_Einfuehrung.md`, `2_Datenbank.md` (Debug-Bildschirm) | Offen | => Er ist im Produktivbuild per Login schreibgeschützt und verborgen.
| F-16 | Wann werden Automatennummer und Standort aus dem Repository statt aus Konstanten bezogen? | `start_screen.dart:28-29` | Offen (hängt an F-02) |
| F-17 | Wie sieht die Oberfläche während des Ladens und im Fehlerfall aus (Datenquelle nicht erreichbar, leere Preissettings)? | bisher nicht vorhanden | Offen (hängt an F-02/F-03) | => Fehlerbildschirm, der anzeigt, dass der AUtomat ausser Betrieb ist.

### Barrierefreiheit und Darstellung

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-18 | Erfüllt der `Colors.blue`-Seed in Hell und Dunkel die Kontrastanforderungen (WCAG 2.1 AA, mindestens 4,5:1 für Fließtext)? | `app_theme.dart:15-29`, `1_Frontendstruktur.md` | Offen | => Nein, das blau des Buttons ist zu hell. eventuell verdunkeln?
| F-19 | Wie verhält sich das Layout bei stark vergrößerter Schrift? Die Bildschirme nutzen feste `Column`-Aufbauten ohne Scrollmöglichkeit; die Fußzeile fängt Überläufe bereits mit `Wrap` ab. | `start_screen.dart:57-70`, `119-135` | Offen | => Vorschlag zur Lösung?
| F-20 | Wird die Systemeinstellung „Bewegung reduzieren" (`MediaQuery.disableAnimations`) respektiert? | `1_Frontendstruktur.md` | Offen | => Noch nicht.
| F-21 | Gibt es automatisierte Tests für Semantik und Fokusreihenfolge (Screenreader-Labels existieren bereits für Logo und Selector-Tooltips)? | `start_screen.dart:85-89`, `test/widget_test.dart` | Offen | => Noch nicht
| F-22 | Muss die Uhr im Sekunden- statt im 30-Sekunden-Takt aktualisiert werden? Die Anzeige kann bis zu 30 Sekunden nachlaufen. | `start_screen.dart:38` | Offen | => Da es genügt, als Uhrzeit, Stunden und Minuten anzuzeigen, brauchen wir nur all 30 Sekunden ein Update.
| F-23 | Pausiert der Uhr-Timer, wenn der Bildschirm verdeckt oder die App im Hintergrund ist? Relevant für Akkuverbrauch und Dauerbetrieb. | `start_screen.dart:34-50` | Offen | => Ja. Update bei Wiederaufruf.

## Daten und Datenbank

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-24 | Wo liegen die Migrationsskripte und wie wird `schema_version` fortgeschrieben (`onCreate`/`onUpgrade`)? | `2_Datenbank.md` | Offen (hängt an F-02) |
| F-25 | Wo liegen die Seed-Daten und sind sie deterministisch (gleiche Startwerte für Tests und CI)? | `2_Datenbank.md` | Offen |
| F-26 | Was bedeutet die `kundennummer` genau, und ist sie personenbeziehbar? Falls ja, muss sie pseudonymisiert oder gestrichen werden. | `2_Datenbank.md` (`maschine.kundennummer`) | Offen |
| F-27 | Wird die Telemetrie-Tabelle aufgenommen (Stromverbrauch, Batteriestand, Signalstärke, Packetloss)? | `2_Datenbank.md` (Backlog) | Offen |
| F-28 | Enthält eine Datenbank genau einen Automaten oder viele? `getMachine` liefert bislang ein einzelnes Objekt. | `2_Datenbank.md` (REST-Mapping) | Offen |
| F-29 | Wie lange werden Verkäufe aufbewahrt (steuerliche Aufbewahrungsfristen vs. Datensparsamkeit)? | `2_Datenbank.md`, `0_Einfuehrung.md` | Offen |
| F-30 | Wie wird verhindert, dass Preissettings und Verkaufszeiten im Produktivbetrieb geändert werden? Der Debug-Bildschirm darf schreiben. | `2_Datenbank.md` (Debug-Bildschirm) | Offen |

## Build, Release und Hosting

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-31 | Wie wird der Widerspruch zwischen „alle Betriebssysteme" und den Nicht-Zielplattformen macOS/iOS aufgelöst? Das Basisdokument ist entsprechend zu präzisieren. | `0_Einfuehrung.md` (Bauziele), `3_Git_Shenanigans.md` | Offen | => macOS/OS andenken, aber noch nicht ausführen.
| F-32 | Wann entstehen die Workflows? Ein `.github/workflows`-Verzeichnis existiert noch nicht, geplant ist `build.yml` mit Test-Gate und Build-Matrix. | `3_Git_Shenanigans.md` | Offen | => Umsetzungsplan erstellen
| F-33 | Wer signiert die Android-, Windows- und Linux-Artefakte, und welche Zertifikate/kostenpflichtigen Dienste werden dafür benötigt? | `3_Git_Shenanigans.md` | Offen | => Wir signieren oder? Vorschläge?
| F-34 | Werden zusätzliche Distributionskanäle bedient (Play Store, MS Store, winget, Flatpak)? | `3_Git_Shenanigans.md` | Offen | => Wenn der Prototyp weiterentwickelt wird.
| F-35 | Welcher Anbieter hostet in der Produktion die Datenbank, wo läuft die REST-API, und wie erfolgt die Authentifizierung? | `3_Git_Shenanigans.md` | Offen | => Vorschläge?
| F-36 | Wie gelangt ein Update auf den Automaten (manueller Download, Self-Update, OTA)? | `3_Git_Shenanigans.md` | Offen | => Self-Update
| F-37 | Wird ein Kiosk-Betrieb vorgesehen (Autostart, Vollbild, unterdrückter Ruhezustand)? | nicht spezifiziert | Offen | => Ja
| F-38 | Wird `--base-href` für die GitHub-Pages-Projektseite korrekt gesetzt? Ohne diesen Parameter lädt der Web-Build seine Ressourcen von der falschen Wurzel. | `3_Git_Shenanigans.md` (Hosting) | Offen | => Hm?
| F-39 | Wie werden Versionen vergeben, wer taggt, und wird ein Changelog gepflegt? | `pubspec.yaml` (`1.0.0+1`), `3_Git_Shenanigans.md` | Offen | => Versionen über die Pubspec, Tagging von Entwicklern und Changelog basiert auf Github, muss aber noch erstellt werden.

## Qualität, Tests und Werkzeuge

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-40 | Welche Teststrategie gilt (Unit-Tests für Preise/Verkaufszeiten/i18n-Parität, Widget-Tests je Bildschirm, Golden-Tests) und ab welcher Abdeckung greift das CI-Gate? | `test/widget_test.dart` | Offen | => Vprschlag?
| F-41 | Bleibt der globale Zustand in `static ValueNotifier`-Feldern, oder wird er über `InheritedNotifier`/Provider injizierbar gemacht? Aktuell setzt jeder Test den Zustand zurück, parallele Tests sind damit nicht möglich. | `app_theme.dart`, `app_locale.dart`, `test/widget_test.dart:14-18` | Offen | => Vorschlag?
| F-42 | Werden die Lint-Regeln über `flutter_lints` hinaus verschärft, und läuft `dart format` als Prüfschritt in der CI? | `analysis_options.yaml` (nur Standardregeln) | Offen | => Vorschlag?
| F-43 | Welche Logs und Fehlerberichte entstehen im Betrieb, ohne personenbezogene Daten zu sammeln? | `0_Einfuehrung.md` (DSGVO-Grenzen) | Offen | => Vorschlag?

## Recht, Dokumentation und Repository-Hygiene

| ID | Frage | Bezug | Status |
|---|---|---|---|
| F-44 | Ist der Abruf der Schriften über `google_fonts` datenschutzrechtlich vertretbar (IP-Übertragung an Dritte), oder werden die Schriften aus diesem Grund gebündelt? | `app_theme.dart`, `0_Einfuehrung.md` (DSGVO) | Offen | => Vorschlag?
| F-45 | Wann wird die README vom Flutter-Boilerplate auf den Projektzweck, die Zielplattformen und einen Verweis auf `doc/plan/` umgestellt? | `README.md`, `3_Git_Shenanigans.md` | Offen | => ASAP
| F-46 | Soll der Dateiname `4_Offene Fragen.md` an die übrigen Dateien (`0_Einfuehrung.md`, `1_Frontendstruktur.md`) angeglichen werden? Bei einer Umbenennung sind alle eingehenden Verweise mitzuziehen. | `doc/plan/grundlagen/` | Offen | => Ja
| F-47 | Werden die gemischten Zeilenenden (CRLF in `0_`, `1_`, `3_`; LF in `2_`) per `.gitattributes` vereinheitlicht, damit Diffs sauber bleiben? | `doc/plan/grundlagen/` | Offen | => Vereinheitlichen
| F-48 | Erhält `doc/plan/` eine Übersichtsseite (Index mit Kurzbeschreibung und empfohlener Lesereihenfolge), damit Einsteiger die Dokumente in der richtigen Reihenfolge finden? | `doc/plan/` | Offen | => Einbauen

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

## Dokumentationsabgleich

Beim Schreiben dieses Dokuments aufgefallene Widersprüche zwischen Doku und Code. Jeder Punkt ist zu bereinigen und danach hier zu streichen.

- `1_Frontendstruktur.md` führt unter *Mögliche Probleme* an, es gebe kein `flutter_localizations` und keine Textressourcendatei. Beides ist inzwischen vorhanden (`pubspec.yaml:39-40`, `lib/l10n/`); offen bleibt nur der Migrationszeitpunkt (F-08).
- `1_Frontendstruktur.md` nennt `ThemeMode.light` als Startwert von `AppTheme.themeModeNotifier`. Der Code startet mit `ThemeMode.dark` — der Punkt ist durch E-07 geschlossen.
- `1_Frontendstruktur.md` und `3_Git_Shenanigans.md` führen ihre Backlogs unter derselben Überschrift *Offene Punkte (Backlog)* mit teils doppelten Einträgen (der Web-Speicher steht in beiden). Künftig: Details im jeweiligen Dokument, dieses Dokument verweist über die ID.
- `3_Git_Shenanigans.md` verweist auf den Widerspruch zu den Bauzielen in `0_Einfuehrung.md` (F-31); das Basisdokument ist bislang unverändert.
- `2_Datenbank.md` nennt die Platzhalter `'4711'` und `'Weiden i. d. OPf.'` im Startbildschirm — das trifft weiterhin zu (F-16).
- Die übrigen Grundlagendokumente verwenden im Dateinamen einen Unterstrich, dieses Dokument enthält ein Leerzeichen (F-46).

## Risiken

- **Offline-Betrieb:** Ein Automat kann ohne Internet ausfallen. Betroffen sind die Schriften (F-13) und jede Datenquelle, die zur Laufzeit aus dem Netz kommt (F-02, F-03).
- **Web und Dateispeicher:** Ein Browser besitzt kein Dateisystem. Wird das zu spät entschieden (F-03), blockiert es Build und Hosting.
- **Doppelte Zustandshaltung:** Solange Bildschirme ihren Zustand selbst halten, laufen Theme, Sprache und Automatendaten auseinander (F-12, F-14, F-41).
- **Testlücken:** Ohne Unit-Tests für Preis- und Verkaufszeitlogik wandern Rechenfehler unbemerkt in die Simulation (F-40).
- **DSGVO-Details:** Font-Abruf (F-44), Kundennummer (F-26) und Protokollierung (F-43) sind einzeln zu bewerten, auch wenn der Prototyp keine personenbezogenen Daten speichert.
- **Dokumentationsdrift:** Die Detaildokumente beschreiben teils bereits überholte Zustände (siehe *Dokumentationsabgleich*). Ohne festen Pflegerhythmus wächst der Abstand zwischen Doku und Code weiter.

## Empfohlene Reihenfolge

1. **F-02 und F-03 entscheiden** (Speicherpaket und Web-Perspektive) — davon hängen F-16, F-17, F-24 und F-25 ab.
2. **F-01 entscheiden** und die Übergänge der sechs Bildschirme festlegen; im selben Zug die gemeinsamen Kopf- und Fußzeilen extrahieren (F-14).
3. **Fachliche Regeln festlegen:** Verkaufszeit (F-04), Preisbildung (F-05), Belegnummern (F-06), Zahlungsablauf (F-07).
4. **Debug-Bildschirm aufsetzen** (F-15, F-30) — er macht Preise und Verkaufszeiten sichtbar und beschleunigt alle weiteren Entscheidungen.
5. **Test- und CI-Grundlage schaffen** (F-32, F-40, F-42), damit die nachfolgenden Schritte abgesichert sind.
6. **Release-Themen klären** (F-33 bis F-39, F-45) — spätestens vor dem ersten echten Release.

## Änderungshistorie

| Datum | Änderung |
|---|---|
| 2026-09-19 | Dokument aus dem Stub `# Offene Fragen` aufgebaut: Fragenkatalog (F-01 bis F-48 nach Themengebiet), Entscheidungslog (E-01 bis E-09), Dokumentationsabgleich, Risiken und empfohlene Reihenfolge ergänzt. |

