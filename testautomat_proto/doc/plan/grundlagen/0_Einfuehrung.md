# Einführung

Im Zuge sich stetig weiterentwickelnder Parkraumbewirtschaftung entstand die Idee, eine App zu entwickeln, die auf allen Geräten gleichzeitig läuft und als Frontend für einen Parkautomaten dient. Aktuell ist die App ein Prototyp, sie ist jedoch so angelegt, dass sie erweitert werden kann.

## Grundlegendes

Da die App ein Frontend ist, werden in der Produktion große Teile der Daten per REST als JSON aus einer Datenbank bezogen. Für den Prototyp werden diese Werte aus einer lokalen SQL-Datenbank geladen, die im Projekt abgelegt ist.

## Bildschirme

Für den Prototypen gibt es zunächst sechs Bildschirme. Bis auf wenige Details teilen sie sich denselben Aufbau:

- **Logo der Stadt Weiden** oben rechts (in `assets/img/`)
- **Uhrzeitangemessene Begrüßung** mittig
- **Uhrzeit inklusive Datum** oben links
- **Sprachauswahl** (Deutsch/Englisch) unten links
- **Debuginformationen** (Automatennummer, Standort etc.) unten rechts

Die Bildschirme im Einzelnen:

1. **"Aus"-Bildschirm** – wird angezeigt, wenn der Automat außerhalb der Verkaufszeit ist.
2. **Startbildschirm** – enthält einen Button zum Starten des Verkaufs.
3. **Parkzeitauswahl** – Auswahl der Parkzeit in Vier-Stunden-Schritten.
4. **Zahlungsauswahl** – bietet mehrere, ebenfalls simulierte Zahlungsoptionen (Bar, Karte, PayPal, Google Wallet, Google Pay; E-51, E-56).
5. **Parkinformation** – informiert den Nutzer darüber, wie lange er parken darf.
6. **Verabschiedung** – verabschiedet den Nutzer freundlich.

## Datenbank

Die Datenbank enthält alle für den Verkauf wichtigen Informationen:

- Verkäufe mit Timestamp und eindeutiger ID
- Preissettings
- Verkaufszeiten, in denen der Automat aktiv sein soll
- Maschineninformationen (Status, Geräte-ID etc.)

Zu Demozwecken sollen diese Setupwerte jederzeit über einen Debug-Button vom Start- und vom "Aus"-Bildschirm aus erreichbar sein.

## Grenzen

Alles soll möglichst DSGVO-konform ablaufen. Alle Zahlungen, inklusive der Ausgabe des Parkscheins, werden nur simuliert (Futures und Ladebalken).

## Bauziele

Die App soll für Android, Windows, Linux und Web entwickelt werden. macOS und iOS bleiben Perspektive und werden im Prototyp nicht aktiv ausgebaut (E-01, E-28; vgl. `3_Git_Shenanigans.md`). Die Webanwendung wird auf GitHub gehostet; im Prototyp bezieht sie ihre Daten aus dem `InMemoryRepository` mit denselben Seed-Daten (E-11), in der Produktion per REST aus einer gehosteten Datenbank (E-43; vgl. `2_Datenbank.md`).