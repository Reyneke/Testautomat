# Frontendstruktur

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) beschreibt dieses Dokument den Aufbau der Bildschirme, also all das, was der Nutzer sieht und bedient. Die Datenbank wird im nächsten Dokument abgehandelt.

## Vorbedingungen
- **ThemeSelector:** Es ist ein ThemeSelector einzurichten, mit dem zwischen *Hell*, *Dunkel* und *System* gewechselt werden kann. Standard ist **Dunkel**.
- **Themevorlage:** Es ist die Themevorlage aus `lib/theme/` zu verwenden (`AppTheme.lightTheme` und `AppTheme.darkTheme`).
- **Mehrsprachigkeit:** Alle Bildschirmtexte müssen auf *Deutsch* und *Englisch* vorliegen. Der Wechsel der Sprache muss jederzeit über Buttons möglich sein.
- **Einfachheit und Barrierefreiheit:** Die Bildschirme sollen nach dem KISS-Prinzip aufgebaut sein und zugleich von Menschen mit Sehbehinderung, Farbsehschwäche, Personen im Autismus-Spektrum, Menschen mit ADHS und ähnlichen Anforderungen genutzt werden können.

> „Vorbedingung" meint hier eine Anforderung an das Frontend, nicht eine bereits erfüllte Voraussetzung. Der aktuelle Umsetzungsstand ist unter *Mögliche Probleme* festgehalten.

### Konsequenzen für die Umsetzung

Aus den Vorbedingungen ergeben sich folgende konkrete Bausteine:

- Ein **zentraler Theme-Zustand** (z. B. `ValueNotifier<ThemeMode>`), der über den `ThemeSelector` bedient und an `MaterialApp(themeMode: ...)` gebunden wird — nicht pro Bildschirm.
- Ein **i18n-Layer** (z. B. `flutter_localizations` mit ARB-Dateien oder eine schlanke eigene `Map<String, String>` je Sprache), damit keine Texte fest in den Widgets verdrahtet werden.
- **Wiederverwendbare Basiskomponenten** für Kopf-, Mittel- und Fußzeile (siehe `0_Einfuehrung.md`), damit die sechs Bildschirme denselben Aufbau teilen.

## Konzept

*Platzhalter — hier folgen Bildschirmaufbau, Klassendiagramme etc.*

Dokumentiert werden soll:

- das **gemeinsame Bildschirm-Layout** (Kopf-, Mittel- und Fußzeile) und
- die **sechs Bildschirme** aus `0_Einfuehrung.md` inklusive ihrer Zustandsübergänge (z. B. Start → Parkzeitauswahl → Zahlungsauswahl).

## Mögliche Probleme

- **Farbkontraste:** Der Seed-Wert `Colors.blue` erzeugt in Hell und Dunkel unterschiedliche Kontraste. Die Kontrastverhältnisse sind zu prüfen (WCAG 2.1 AA, mindestens 4,5:1 für Fließtext); die Verdunkelung des Seeds ist mit E-40 beschlossen und wird in `U-71` umgesetzt.
- **Mehrsprachigkeit:** `flutter_localizations` ist in `pubspec.yaml` eingebunden, die sichtbaren Texte liegen als schlanke `Map` je Sprache in `lib/l10n/` (E-05). Offen ist nur der Migrationszeitpunkt auf ARB-Dateien mit `l10n.yaml` (F-08/E-17, `U-70`).
- **Umschaltung zur Laufzeit:** Sprach- und Theme-Wechsel müssen ohne Neustart der App greifen; der Zustand ist zentral statt je Bildschirm zu halten.
- **Reduzierte Bewegung:** Für Menschen mit ADHS oder im Autismus-Spektrum sind Animationen möglichst zu reduzieren und Systemeinstellungen (z. B. „Bewegung reduzieren") zu respektieren.
- **Platzhalter im Startbildschirm:** Automatennummer und Standort stehen in `start_screen.dart:28-29` noch als Konstanten. Entscheidung E-55: Sie werden beim App-Start über das Repository geladen (`getMachine()`) und über `AppMachine.maschineNotifier` dargestellt; die Umsetzung erfolgt mit dem Datenlayer.