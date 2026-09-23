# Protokollierung und Datenschutz

Bezugnehmend auf die Grenzen in `0_Einfuehrung.md` („Alles soll möglichst DSGVO-konform ablaufen")
beschreibt dieses Dokument, was der Automat im Betrieb protokolliert, wie diese Protokolle rotieren
und welche Aufbewahrungsregeln gelten. Es setzt die Entscheidungen **E-48** (Logs enthalten nur
Betriebsdaten und werden rotiert) und **E-54** (Aufbewahrungs- und Purge-Konzept dokumentiert, im
Prototyp aber nicht implementiert) um — Arbeitspaket `U-73`.

## Grenzen der Protokollierung

Protokolliert werden ausschließlich **Betriebsdaten**. Sie dienen der Fehlersuche am Automaten und
lassen keine Rückschlüsse auf Personen zu.

| Feld | Beispiel | Zweck |
|---|---|---|
| Geräte-ID | `4711` | Zuordnung zum Automaten |
| Zeitstempel (UTC) | `2026-09-22T17:41:37Z` | Zeitliche Einordnung (Anzeige erfolgt lokal) |
| Ereignistyp | `sale_created`, `payment_error`, `config_change` | Ablauf nachvollziehen |
| Fehlercode | `timeout`, `abgebrochen` | Störungen eingrenzen |
| Betrag in Cent | `200` | Summen prüfen (ohne Zahlungsreferenz) |
| Belegnummer | `a1b2c3…` | Beleg zuordnen (Hash aus Geräte-ID, Zähler, Einschaltzeit, E-16) |

**Nicht protokolliert** werden personenbezogene oder personenbeziehbare Daten:

- keine Namen, Kennzeichen, Kunden- oder Kartendaten, keine Zahlungsreferenzen,
- keine IP-Adressen, keine Cookies, kein Tracking und keine Nutzungsprofile,
- keine Inhalte von Eingabefeldern (z. B. die Debug-PIN),
- keine Standortdaten von Personen (der Standort des Automaten steht in den Stammdaten).

> Das **optionale Kennzeichen** aus E-58 wird mit dem Verkaufsdatensatz gespeichert
> (`verkaeufe.kennzeichen`), aber weiterhin **nicht protokolliert**: kein Log-Ereignis trägt es, und
> der Beleg als PDF entsteht ausschließlich auf dem Gerät des Kunden.

## Format und Rotation (E-48)

- **Format:** JSON-Zeilen (`*.jsonl`), UTF-8, eine Zeile je Ereignis.
- **Ablage:** lokales Verzeichnis des Automaten; keine Übertragung an Dritte.
- **Rotation:** tägliche Datei `betrieb-JJJJ-MM-TT.jsonl`; zusätzlich eine Größenobergrenze von
  **5 MB** je Datei. Ältere Dateien werden gelöscht, sobald **14 Dateien** (bzw. die Größenobergrenze)
  überschritten sind — es gibt keine Archivierung außerhalb des Geräts.
- **Zugriff:** nur lesend für die Fehlersuche; das Löschen erfolgt durch dieselbe Rotation.
- **Datensparsamkeit:** Ereignisse werden ohne Freitext geschrieben; unbekannte Felder sind verboten.

## Aufbewahrung und Purge (E-54)

Das Konzept ist festgelegt, im Prototyp aber **nicht implementiert** — es gibt bewusst keine
automatischen Löschroutinen. Die Löschfristen gelten für die Produktionsperspektive:

| Datenart | Aufbewahrung | Begründung |
|---|---|---|
| Betriebsprotokolle (`*.jsonl`) | 14 Tage (Rotation) | Fehlersuche; danach kein Nutzen |
| Verkaufsdaten (`verkaeufe`) | 10 Jahre | Belegnachweis; ohne Kennzeichen kein Personenbezug (E-54) |
| Kennzeichen (`verkaeufe.kennzeichen`) | wie der Verkaufsdatensatz | personenbeziehbar (E-58); mit dem Verkauf zu löschen, sobald die Aufbewahrungsfrist endet |
| Telemetrie (`telemetrie`) | 90 Tage | Betriebsbeobachtung des Automaten |

**Purge-Vorgehen (Perspektive):** ein nächtlicher Auftrag löscht abgelaufene Zeilen und schreibt
einen Löschvermerk ohne Personenbezug (Zeitpunkt, Datenart, Anzahl). Betroffenenrechte auf Auskunft
oder Löschung laufen ins Leere, weil kein Personenbezug besteht; wird in einer späteren Ausbaustufe
doch ein Bezug erhoben, ist dieses Dokument zu erweitern und die Fristen sind neu zu bewerten.

## Was im Prototyp tatsächlich passiert

- **Kein Protokolldatei-Betrieb:** der Prototyp schreibt keine Logdateien und betreibt keine Rotation.
- Die einzige Ausgabe ist ein `debugPrint` im Fehlerpfad der Zahlung
  (`lib/screens/zahlungs_auswahl_screen.dart`); `debugPrint` erscheint nur in Debug-Builds und wird
  nicht gespeichert.
- **Keine Netzzugriffe für Schriften:** Poppins und Lato liegen als Assets bei (E-38, `U-72`), damit
  beim Start keine Verbindung zu Dritten aufgebaut wird (vgl. `F-44`).
- Der Web-Client bezieht seine Daten aus dem `InMemoryRepository` (E-11) und legt nichts serverseitig ab.
- Der Parkschein wird ausschließlich auf dem Gerät des Kunden als PDF erzeugt und dort abgelegt
  (E-57); es gibt keine Übertragung an Dritte und keine serverseitige Ablage.

## Bezug zu den Entscheidungen

| Entscheidung | Inhalt | Umsetzung hier |
|---|---|---|
| E-48 | Logs nur mit Betriebsdaten, rotiert | Abschnitte *Grenzen* und *Format und Rotation* |
| E-54 | Aufbewahrungs-/Purge-Konzept dokumentiert, nicht implementiert | Abschnitt *Aufbewahrung und Purge* |
| E-57 | Parkschein als PDF auf dem Gerät | Abschnitt *Was im Prototyp tatsächlich passiert* |
| E-58 | Kennzeichen optional, gespeichert, nie protokolliert | Abschnitt *Grenzen der Protokollierung* und *Aufbewahrung und Purge* |
| E-38, F-44 | Schriften gebündelt statt Laufzeitabruf | Abschnitt *Was im Prototyp tatsächlich passiert* |
| E-11, E-43 | Web nutzt InMemory; Produktion später REST/Postgres | `2_Datenbank.md`, `3_Git_Shenanigans.md` |
