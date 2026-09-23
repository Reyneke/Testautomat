# Neue Zahlungsmöglichkeiten und Parkfunktionen

Stand: 2026-09-23. Dieses Dokument sammelt die nach dem ersten Praxistest ergänzten Anforderungen.
Es ist **keine** eigene Fachspezifikation: Die verbindlichen Festlegungen stehen im Entscheidungslog
(`4_Offene_Fragen.md`, `E-56`…`E-60`) und in den Arbeitspaketen (`5_Umsetzungsplan.md`,
`U-74`…`U-78`); Schema und Vertrag werden in `2_Datenbank.md` nachgeführt.

## Neue Zahlungsarten

Nach einem kurzen Praxistest wurden drei weitere Zahlungsarten angeregt:

1. PayPal
2. Google Wallet
3. Google Pay

Sie sind so weit wie möglich einzurichten, **ohne dass eine echte Zahlung stattfindet**: Der Ablauf
endet im letzten Schritt, es wird kein echtes Konto belastet. Der Ablauf folgt derselben Mechanik wie
die bestehende Simulation (E-51): Zahlungsart wählen, Verarbeitung mit Fortschritt und Timeout,
Abbruch durch den Nutzer, Beleg mit Belegnummer. Wie daraus echte Zahlungen werden könnten, steht im
Abschnitt *Umstieg auf echte Zahlungen*.

### Akzeptanzkriterien

- Die Zahlungsauswahl zeigt neben „Bar" und „Karte" die drei neuen Arten; die Beschriftungen stammen
  aus den ARB-Dateien (Deutsch/Englisch, `U-70`).
- Jede Zahlungsart durchläuft den simulierten Ablauf; es findet keine echte Zahlung statt.
- Die Spalte `verkaeufe.zahlungsart` nimmt alle fünf Werte an (`bar`, `karte`, `paypal`,
  `google_wallet`, `google_pay`); die `CHECK`-Restriktion ist entsprechend erweitert.
- Migration `0002` hebt bestehende Datenbanken auf den neuen Stand.

## Umstieg auf echte Zahlungen

> Die Frage kam nach dem Praxistest auf: *Wie leicht lassen sich die simulierten Zahlungsarten in
> „richtige" umwandeln — welche Schritte sind nötig, und welche Module müssten nachgeladen werden?*
> Die Antwort ist eine Analyse (F-60, E-60); umgesetzt wird sie erst mit der Produktionsentscheidung
> (E-43). Der Prototyp bleibt simuliert (E-51, E-56).

**Kurzfassung:** In der App selbst sind es wenige, klar abgegrenzte Stellen — echte Zahlungen brauchen
aber eine **serverseitige Komponente**, die es heute noch nicht gibt. Eine Flutter-App kann keine
Module zur Laufzeit nachladen: Alles Client-seitige wird mit dem Build ausgeliefert, der eigentliche
Zahlungsverkehr läuft über einen Zahlungsdienstleister (PSP) bzw. die Provider-API und gehört auf
einen Server.

### Begriff: PSP (Zahlungsdienstleister)

**PSP** steht für *Payment Service Provider*, deutsch *Zahlungsdienstleister*. Gemeint ist die
Vermittlungsschicht zwischen dem Automaten als Händler und den Kartennetzen bzw. Zahlungsanbietern: Sie
nimmt die Zahlungsdaten entgegen, führt Autorisierung, Erfassung und (auf Anforderung) Erstattung durch
und meldet das Ergebnis per Webhook an den Händler zurück.

Im Dokument ist PSP **keine Bibliothek und kein Produkt, sondern eine Rolle**; deshalb steht der Begriff
nur in der Analyse (F-60, E-60), während der Code die Rolle hinter dem Repository-Vertrag verbirgt
(Contract first, E-04). Drei Punkte folgen daraus:

- **Ort:** Der PSP wird ausschließlich serverseitig angebunden (Schritt 1). API-Schlüssel und
  Webhook-Secrets bleiben im Backend; der Client spricht nur die eigene REST-Schicht (E-43).
- **Reichweite je Zahlungsart:** PayPal ist eine Provider-API und braucht keinen PSP. Bei Google Pay
  und Google Wallet erhält der Client nur einen tokenisierten Zahlungsnachweis, der Geldfluss läuft
  über einen PSP — daher dort „PSP-Vertrag" als Voraussetzung. Karte nutzt entweder einen PSP mit
  3-D-Secure oder ein Terminal am Automaten; Bar kommt ganz ohne PSP aus (Hardware, Schritt 7).
- **Verwandte Abkürzungen:** *3-D-Secure* bzw. *SCA* ist die starke Kundenauthentifizierung im
  Kartengeschäft; *PCI* meint den PCI-DSS-Umfang der Kartendaten, den Redirect- und
  Tokenisierungsverfahren klein halten (Schritt 6).

Bei Markdown besagt die Schreibweise `**PSP**` nichts weiter als **Fettdruck** — hier nur eine
Hervorhebung des Begriffs, kein Programmcode.

**Umsetzungsbezug (Stand 2026-09-23).** Im Code existiert noch nichts davon: `enum Zahlungsart`
(`lib/data/dto.dart`) trägt die fünf Werte nur als Datenwerte, der Ablauf in
`lib/screens/zahlungs_auswahl_screen.dart` ist rein simuliert und endet unmittelbar in `createSale`.
Der PSP tritt erst mit der Produktionsentscheidung (E-43) an die Stelle der Simulation.

### Was bereits vorbereitet ist

- **Zahlungsarten als Datenwerte:** `enum Zahlungsart` und `verkaeufe.zahlungsart` tragen bereits alle
  fünf Werte (E-56, Migration `0002`) — hier ist nichts zu ändern.
- **Contract first (E-04):** Oberfläche und Fachlogik kennen nur `ParkautomatRepository`. Eine echte
  Anbindung ist eine zusätzliche Implementierung (`RestRepository`, E-43) — kein Umbau der Screens.
- **Ablauf-Fassade:** Auswahl, Fortschritt, Timeout und Abbruch im Zahlungsbildschirm bleiben als
  Bedienmuster erhalten; sie werden nur an einen echten, asynchronen Zahlungsstatus gekoppelt.

### Was hinzukommt (Schritte)

1. **Serverseitige Zahlungsschicht** (neu, Teil der REST-Schicht aus E-43): spricht die Provider-APIs
   und hält API-Schlüssel sowie Webhook-Secrets. **Keine Secrets im Client.**
2. **Vertrag erweitern:** `ParkautomatRepository` erhält Methoden für Bestellung und Zahlungsstatus
   (z. B. `initZahlung`, `holeZahlungsstatus`) anstelle der Kopplung „Fortschritt → `createSale`".
3. **Datenbank:** neue Tabelle `zahlungen` (Verkaufsbezug, Provider, Status, Referenz, Betrag,
   Idempotenz-Schlüssel) als Migration `0003`. `createSale` bleibt die Quittung und wird erst nach
   bestätigter Zahlung geschrieben.
4. **Statusmaschine statt Durchstich:** neu → autorisiert → erfasst → (fehlgeschlagen/storniert/
   erstattet). Die Doppelkauf-Prüfung (`getVerkaeufeZuKennzeichen`, E-58) wandert an den Zeitpunkt der
   Bestellung.
5. **Client-Ablauf:** aus dem kurzen Ladebalken wird ein Interstitial mit QR-Code bzw. Weiterleitung
   (PayPal, Google Pay/Wallet) und Rückkehr in die App; Timeout und Abbruch bleiben bestehen.
6. **Sicherheit:** TLS, signierte Webhooks, Idempotenz-Schlüssel, 3-D-Secure/SCA für Karte; keine
   Kartendaten im Client (Redirect- bzw. Token-Verfahren halten den PCI-Umfang klein).
7. **Bar und Karte am Gerät:** echte Bargeld- und Kartenzahlung brauchen **Hardware**
   (Münz-/Notenvalidator, Kartenleser/Terminal mit eigenem Protokoll) — ein eigenes Arbeitspaket,
   unabhängig von den Online-Verfahren.
8. **DSGVO und Protokollierung:** Zahlungsreferenzen sind für Reklamationen nötig, dürfen aber nur
   gekürzt bzw. gehasht protokolliert werden; E-48 und die Aufbewahrung (E-54) sind zu präzisieren.
9. **Tests und Dokumentation:** Vertrags-Tests gegen eine Sandbox je Zahlungsart, Fehlerpfade
   (abgelehnt, abgelaufen, Netzausfall) und Schutz gegen Webhook-Wiederholungen; Texte und Dokumente
   (`0_`, `2_`, `6_`) nachziehen.

### Aufwand je Zahlungsart (grobe Einordnung)

| Zahlungsart | Echte Anbindung | Aufwand | Voraussetzung |
|---|---|---|---|
| PayPal | Orders-REST-API mit Sandbox, Webhooks, Erstattungen | mittel | PayPal-Händler-/Sandbox-Konto |
| Google Pay | tokenisiert über einen PSP (nicht direkt), Zertifizierung | mittel bis hoch | PSP-Vertrag |
| Google Wallet | Einbindung über denselben PSP-/Tokenisierungsweg | mittel bis hoch | PSP-Vertrag |
| Karte | PSP mit 3-D-Secure **oder** Terminal am Automaten | hoch | PSP-Vertrag bzw. Hardware |
| Bar | Münz-/Notenvalidator mit Kassenprotokoll | hoch | Hardware, kein Online-Anteil |

### Erläuterung der Aufwandtabelle

Die Tabelle ist eine Analyse (F-60, E-60) und **kein Arbeitspaket**: Sie nennt keine Stundenzahlen und
keine Termine, sondern ordnet die fünf Zahlungsarten (E-56) nach zwei unabhängigen Größen.

**Spalten.**

- *Echte Anbindung* — welche technische Schnittstelle bzw. welches Verfahren an die Stelle der
  Simulation tritt; das ist die Spalte „wie".
- *Aufwand* — eine rein qualitative Stufe (`mittel`, `mittel bis hoch`, `hoch`) ohne Bezugsgröße zu
  den `U-`-Paketen. Sie ist als Reihenfolge zu lesen, nicht als Größe.
- *Voraussetzung* — der Blockierer **außerhalb** des Codes (Konto, PSP-Vertrag oder Hardware). Diese
  Spalte bestimmt den frühesten Start: ohne sie hilft fertiger Code nicht.

**Zeilen.**

- **PayPal (mittel):** Orders-REST-API mit Sandbox, Webhooks und Erstattungen. Die Sandbox erlaubt
  einen vollständigen Testbetrieb ohne Vertragsverhandlung, und es ist keine Hardware im Spiel —
  deshalb ist PayPal die naheliegende erste Zahlungsart (s. *Empfehlung*).
- **Google Pay (mittel bis hoch):** keine Direktanbindung an Google; der Client erhält einen
  tokenisierten Zahlungsnachweis, der Geldfluss läuft über einen **PSP**. Gegenüber PayPal kommt also
  eine weitere Partei samt *Zertifizierung* hinzu — ein zusätzlicher Beteiligter, nicht nur eine
  weitere API.
- **Google Wallet (mittel bis hoch):** derselbe PSP- und Tokenisierungsweg wie Google Pay, also
  **nicht additiv** zu diesem. Die beiden Zeilen existieren, weil die Anforderung drei Zahlungsarten
  nennt (E-56), die Analyse aber zwei gemeinsame Wege zeigt.
- **Karte (hoch):** zwei sich ausschließende Wege — PSP mit **3-D-Secure** (SCA-Pflicht; Redirect
  bzw. Tokenisierung halten dafür den PCI-Umfang klein) **oder** ein Terminal am Automaten mit eigenem
  Geräteprotokoll. Beide Wege sind teuer, aber aus verschiedenen Gründen.
- **Bar (hoch):** der Sonderfall ohne jeden Online-Anteil — Münz-/Notenvalidator und Kassenprotokoll
  sind eine Geräteintegration mit eigenen gesetzlichen Anforderungen. Deshalb liegt Bar trotz fehlender
  Vernetzung in einer eigenen Größenordnung und ist laut Schritt 7 ein **eigenes Arbeitspaket**.

**Lesart.** Die Aufwandsstufen ergeben genau die Reihenfolge der *Empfehlung*: zuerst die einmalige
Server-Schicht mit dem erweiterten Vertrag (Schritte 1 bis 4: REST-Schicht, `initZahlung`/
`holeZahlungsstatus`, Tabelle `zahlungen` als Migration `0003`, Statusmaschine), danach **eine**
Zahlungsart im Sandbox-Modus; die übrigen Online-Arten nutzen dieselben Methoden (Nutzen von
*Contract first*, E-04). Der Aufwand der Online-Zeilen liegt bei Verträgen und PSP, der von Bar und
Karte am Gerät bei Hardware und Geräteprotokollen.

**Grenzen der Einordnung.** Die Stufen sind nicht definiert, die beiden Google-Zeilen nahezu
deckungsgleich, und „Erstattungen" steht nur bei PayPal, obwohl Rückerstattungen auch bei Karte und
PSP anfallen. Die Spalte *Voraussetzung* nennt nur das Vorhandensein eines PSP-Vertrags, nicht dessen
kommerzielle Bewertung (Gebühren, Abrechnung), obwohl E-60 genau dort den Aufwand verortet. Eine
Migration `0003` gibt es noch nicht — passend dazu bleibt der Prototyp bis zur Produktionsentscheidung
simuliert (E-51, E-56, E-60).

**Abgleich mit dem Code (Stand 2026-09-23).** Die Voraussetzungen der Tabelle sind im Bestand
vorhanden: `enum Zahlungsart` trägt die fünf Werte mit explizitem Datenbankwert (`lib/data/dto.dart`),
und die `CHECK`-Restriktion in Migration `0002` sowie in `2_Datenbank.md` nennt dieselben fünf Werte.
Die in Schritt 2 zu ersetzende Kopplung „Fortschritt → `createSale`" ist real:
`lib/screens/zahlungs_auswahl_screen.dart` ruft nach dem Ladebalken unmittelbar `createSale` auf, ohne
Zwischenzustand für Bestellung und Zahlungsstatus. Eine Migration `0003` fehlt; aus diesem Abschnitt
ist also noch nichts umgesetzt.

### Empfehlung

Zuerst die Server-Schicht und den erweiterten Vertrag schaffen und **eine** Zahlungsart im
Sandbox-Modus anbinden; die übrigen folgen über dieselben Methoden. Die in der App betroffenen Stellen
bleiben überschaubar: `lib/screens/zahlungs_auswahl_screen.dart`,
`lib/data/parkautomat_repository.dart`, das Datenlayer (Migration `0003`) sowie die Texte.

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
