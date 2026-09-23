# Neue Zahlungsmöglichkeiten und Parkfunktionen

Stand: 2026-09-23. Dieses Dokument sammelt die nach dem ersten Praxistest ergänzten Anforderungen.
Es ist **keine** eigene Fachspezifikation: Die verbindlichen Festlegungen stehen im Entscheidungslog
(`4_Offene_Fragen.md`, `E-56`…`E-59`) und in den Arbeitspaketen (`5_Umsetzungsplan.md`,
`U-74`…`U-77`); Schema und Vertrag werden in `2_Datenbank.md` nachgeführt.

## Neue Zahlungsarten

Nach einem kurzen Praxistest wurden drei weitere Zahlungsarten angeregt:

1. PayPal
2. Google Wallet
3. Google Pay

Sie sind so weit wie möglich einzurichten, **ohne dass eine echte Zahlung stattfindet**: Der Ablauf
endet im letzten Schritt, es wird kein echtes Konto belastet. Der Ablauf folgt derselben Mechanik wie
die bestehende Simulation (E-51): Zahlungsart wählen, Verarbeitung mit Fortschritt und Timeout,
Abbruch durch den Nutzer, Beleg mit Belegnummer.

### Akzeptanzkriterien

- Die Zahlungsauswahl zeigt neben „Bar" und „Karte" die drei neuen Arten; die Beschriftungen stammen
  aus den ARB-Dateien (Deutsch/Englisch, `U-70`).
- Jede Zahlungsart durchläuft den simulierten Ablauf; es findet keine echte Zahlung statt.
- Die Spalte `verkaeufe.zahlungsart` nimmt alle fünf Werte an (`bar`, `karte`, `paypal`,
  `google_wallet`, `google_pay`); die `CHECK`-Restriktion ist entsprechend erweitert.
- Migration `0002` hebt bestehende Datenbanken auf den neuen Stand.

## Parkticket als PDF

Weiterhin soll das Parkticket in allen Varianten als PDF für den Kunden herunterladbar sein —
unabhängig von der gewählten Zahlungsart.

> Dieser Abschnitt **überholt den PDF-Teil von `E-51`** („kein PDF und kein Druck im Prototyp").
> Der alte Eintrag bleibt mit Status *überholt* erhalten (Regel in `4_Offene_Fragen.md`).

### Akzeptanzkriterien

- Der Beleg-Bildschirm bietet den Download des Parkscheins als PDF an.
- Das PDF enthält Belegnummer, Parkdauer, Betrag, Zahlungsart und Gültig-bis sowie — falls angegeben
  — das Kennzeichen.
- Der Download funktioniert im Web-Build (Browser-Download) und auf den Desktop-Builds (Ablage im
  Download-Verzeichnis); das Vorgehen ist in `3_Git_Shenanigans.md` nicht neu zu regeln.
- Die PDF-Erzeugung kommt ohne Netzwerkzugriff aus (vgl. E-38).

## Kennzeicheneingabe

Nach der Auswahl der Parkzeit soll der Nutzer sein Fahrzeugkennzeichen eintragen können. Doppelkäufe
auf dasselbe Kennzeichen sollen dabei vermieden werden.

### Akzeptanzkriterien

- Das Kennzeichen ist **optional**; gespeichert wird die Normalform (Großbuchstaben, ohne Trenner und
  Leerzeichen).
- Ungültige Eingaben werden mit einem Hinweis abgewiesen.
- Solange für dasselbe Kennzeichen eine Parkzeit läuft, legt **keine** Repository-Implementierung
  einen zweiten Verkauf an (Prüfung in `InMemoryRepository` und `SqliteRepository`).
- Nach Ablauf der Parkzeit ist ein neuer Verkauf auf dasselbe Kennzeichen wieder möglich.

### Datenschutz

Ein Kennzeichen ist **personenbeziehbar**. Es wird deshalb weiterhin **nicht protokolliert**
(`6_Logging_und_Datenschutz.md`) und nur zusammen mit dem Verkaufsdatensatz gespeichert; die
Aufbewahrung folgt damit dem Verkauf (E-54). Die Aussage „Verkäufe sind anonym" in der Root-`README.md`
gilt nur noch für Verkäufe ohne Kennzeichen und ist dort zu präzisieren.

## Parkzonen

Die DB wird später die verfügbaren Parkzonen übermitteln. Zu Simulationszwecken zeigt der Prototyp
vier Zonen auf demselben Bildschirm wie die Parkzeitauswahl an. Der Nutzer wählt zuerst die Zone; ein
Zonenwechsel löscht die aktuell ausgewählte Parkzeit und verlangt eine neue Angabe.

### Akzeptanzkriterien

- Der Repository-Vertrag liefert die Zonen über `getParkzonen()`; der Prototyp speist vier Seed-Zonen
  ein, sodass die spätere Datenquelle dahinter austauschbar bleibt.
- Die Parkzeit ist erst wählbar, nachdem eine Zone gewählt wurde.
- Ein Zonenwechsel verwirft die gewählte Parkzeit und sperrt „Weiter" bis zur neuen Angabe.
- Die gewählte Zone wird im Zahlungsbildschirm angezeigt.

### Offener Punkt

Ob die Zone am Verkauf gespeichert wird und ob Zonen eigene Preise tragen, ist mit der
Produktionsdatenquelle zu klären (`F-59`); der Prototyp wählt die Zone nur aus.

## Codecheck

Der Code soll überprüft und auf Fehler sowie Verbesserungen untersucht werden, um von Anfang an eine
stabile Basis zu haben. Das ist **kein eigenes Feature**, sondern Teil der Definition of Done: Jedes
Arbeitspaket schließt mit dem lokalen Gate `tool/gate.ps1` (U-52) ab — `flutter gen-l10n`,
`dart format --set-exit-if-changed`, `flutter analyze`, `flutter test`.
