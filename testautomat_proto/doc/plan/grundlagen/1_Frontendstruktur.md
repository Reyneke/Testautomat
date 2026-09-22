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

## Kontrastnachweis (WCAG 2.1 AA, E-40)

Der Seed der Farbpalette ist das dunkle Blau `Color(0xFF0D47A1)` (`AppTheme.seedColor`).
Die daraus abgeleiteten Material-3-Farben erfüllen in beiden Themes die Anforderung von
mindestens 4,5:1 für Fließtext. Die Werte sind gemessen: `test/theme/contrast_test.dart`
rechnet sie bei jedem Testlauf nach und schlägt bei Unterschreitung fehl.

| Farbpaar (Text auf Fläche) | Hell | Dunkel |
|---|---|---|
| `onPrimary` auf `primary` | 6,46:1 | 7,77:1 |
| `onPrimaryContainer` auf `primaryContainer` | 7,27:1 | 7,27:1 |
| `onSecondary` auf `secondary` | 6,47:1 | 7,74:1 |
| `onSurface` auf `surface` | 16,32:1 | 14,39:1 |
| `onError` auf `error` | 6,46:1 | 7,72:1 |

## Mögliche Probleme

- **Farbkontraste:** Gelöst — der Seed ist das dunkle Blau `Color(0xFF0D47A1)` (E-40); die gemessenen Kontrastverhältnisse stehen oben als Tabelle und werden von `test/theme/contrast_test.dart` geprüft (`U-71`).
- **Mehrsprachigkeit:** Die sichtbaren Texte liegen als ARB-Dateien in `lib/l10n/arb/` (Deutsch/Englisch); `flutter gen-l10n` erzeugt daraus `lib/l10n/generated/app_localizations.dart`, `AppLocalizations.of(context)!` bleibt die Aufrufstelle (E-05, E-17, `U-70`). Lokales Gate und CI erzeugen die Texte und prüfen sie gegen den eingecheckten Stand; der Paritätstest vergleicht die Schlüssel beider ARB-Dateien (E-39).
- **Datum und Uhrzeit:** Werden über `intl` formatiert (`AppFormat`, E-18): Englisch erhält das 12-Stunden-Format mit AM/PM, Deutsch die 24-Stunden-Anzeige; das deutsche Datum folgt CLDR ohne führende Nullen (`18.9.2026`).
- **Umschaltung zur Laufzeit:** Sprach- und Theme-Wechsel greifen ohne Neustart der App; der Zustand ist zentral statt je Bildschirm zu halten.
- **Reduzierte Bewegung:** Gelöst — `AppMotion` liest die Systemeinstellung; `FortschrittsAnzeige` zeichnet bei „Bewegung reduzieren“ einen stillstehenden Ring bzw. einen ruhigen Balken statt laufender Animationen (E-24, `U-71`).
- **Anzeigen und Hintergrundbetrieb:** Der mittlere Bereich ist scrollbar, Kopf- und Fußzeile bleiben fixiert (E-41); der Uhr-Takt pausiert, wenn die App im Hintergrund ist, und aktualisiert beim Zurückkommen sofort (E-27).
- **Platzhalter im Startbildschirm:** Automatennummer und Standort stehen in `start_screen.dart:28-29` noch als Konstanten. Entscheidung E-55: Sie werden beim App-Start über das Repository geladen (`getMachine()`) und über `AppMachine.maschineNotifier` dargestellt; die Umsetzung erfolgt mit dem Datenlayer.