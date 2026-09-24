# Umbau auf DB

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) und die Detaildokumente `2_Datenbank.md` und
`7_Neue_Zahlmoeglichkeiten.md` beschreibt dieser Text den Umbau des Prototypen auf eine echte
(gehostete) Datenbank: die dafür nötigen Vorbedingungen und die Schrittfolge — **und** die Schritte,
um als erste Zahlungsart **PayPal** real anzubinden.

Stand: 2026-09-24.

## Einordnung

Dieses Dokument ist eine Roadmap, **keine** eigene Fachspezifikation: Die verbindlichen Festlegungen
stehen im Entscheidungslog (`4_Offene_Fragen.md`, E-04, E-11, E-43, E-51, E-56, E-60) und in den
Arbeitspaketen (`5_Umsetzungsplan.md`, `U-62`, `U-78`). Schema und Repository-Vertrag werden in
`2_Datenbank.md` nachgeführt; Widersprüche und Abweichungen gehören in den *Dokumentationsabgleich*
(`4_Offene_Fragen.md`).

## Vorbedingungen

| Nr. | Vorbedingung | Grundlage |
|---|---|---|
| 1 | **Produktionsentscheidung (E-43):** Die App bezieht ihre Daten per REST als JSON aus einer gehosteten Datenbank; die Anbieterwahl fällt **vor** dem ersten Release. | `0_Einfuehrung.md` (*Bauziele*), `5_Umsetzungsplan.md` (`U-62`) |
| 2 | **Contract first (E-04):** Oberfläche und Fachlogik kennen nur `ParkautomatRepository` und dessen DTOs — kein Widget greift direkt auf die Datenquelle zu. Der Umbau ist deshalb eine zusätzliche Repository-Implementierung, kein Umbau der Screens. | `2_Datenbank.md` (*Vorbedingungen*) |
| 3 | **Serverseitige Komponente:** Der eigentliche Zahlungsverkehr läuft über einen Zahlungsdienstleister (PSP) bzw. die Provider-API und gehört auf einen Server, den es heute noch nicht gibt. | `7_Neue_Zahlmoeglichkeiten.md` (*Begriff: PSP*) |
| 4 | **Externe Blockierer je Zahlungsart:** PayPal braucht ein Händler-/Sandbox-Konto, Google Pay/Wallet einen PSP-Vertrag, Karte und Bar benötigen Hardware. Diese Punkte liegen **außerhalb des Codes** und bestimmen den frühesten Start. | `7_Neue_Zahlmoeglichkeiten.md` (*Aufwand je Zahlungsart*) |
| 5 | **Datenschutz und Aufbewahrung (E-48, E-54):** Die Protokollierungsgrenzen und das Aufbewahrungs-/Purge-Konzept bleiben gültig und sind für die Produktionsdatenquelle zu konkretisieren. | `6_Logging_und_Datenschutz.md` |

## Schrittfolge: Umbau auf eine echte Datenbank

Die Reihenfolge folgt der im Prototyp angelegten Architektur (Contract first, E-04): Die Datenquelle
wird ausgetauscht, die Screens bleiben unverändert.

1. **Anbieter und Umgebung festlegen (E-43):** gehostete Datenbank, REST-Schicht, Deployment und
   Secret-Handling im Backend bestimmen — Entscheidung vor dem ersten Release (`U-62`).
2. **Schema als Migration nachführen:** Das Schema aus `2_Datenbank.md` bzw. `lib/data/migrations/`
   ist die Quelle; das Remote-Schema wird als nächste Migration (nach `0002`) nachgeführt, damit
   Seed- und Bestandsdaten nachvollziehbar bleiben (`schema_version`).
3. **REST-Schicht hinter dem Vertrag aufbauen:** liefert dieselben JSON-DTOs (snake_case,
   UTC-Zeitstempel) wie in `2_Datenbank.md` festgelegt; API-Schlüssel bleiben im Backend —
   **keine Secrets im Client**.
4. **`RestRepository` implementieren:** eine zusätzliche `ParkautomatRepository`-Implementierung; die
   Umschaltung erfolgt in den Fabriken `lib/data/repository_factory_io.dart` und
   `lib/data/repository_factory_web.dart` (heute `SqliteRepository.desktop()` bzw.
   `InMemoryRepository`, E-49/E-11).
5. **Tests:** Repository-Unit-Tests gegen das Interface sowie die Fehlerpfade (Netzausfall, Timeout,
   Wiederholungen).
6. **Betrieb:** TLS und Zugriffskontrolle; Protokollierung und Aufbewahrung gemäß
   `6_Logging_und_Datenschutz.md` gelten unverändert für die neue Datenquelle.

## PayPal als erste Zahlungsart

PayPal ist die naheliegende erste Zahlungsart: Die Orders-REST-API erlaubt einen vollständigen
Testbetrieb über eine Sandbox **ohne Vertragsverhandlung**, und weder Hardware noch ein PSP-Vertrag
sind nötig (`7_Neue_Zahlmoeglichkeiten.md`, *Empfehlung*). Die nachfolgenden Schritte setzen die
Analyse F-60/E-60 (Arbeitspaket `U-78`) um; bis zur Produktionsentscheidung (E-43) bleibt der
Prototyp simuliert.

**Vorbedingung:** PayPal-Händler- bzw. Sandbox-Konto.

| Nr. | Schritt | Umsetzung |
|---|---|---|
| 1 | **Serverseitige Zahlungsschicht** (Teil der REST-Schicht aus E-43): spricht die PayPal-API, hält API-Schlüssel und Webhook-Secrets. | Backend, kein Client-Code |
| 2 | **Vertrag erweitern:** `ParkautomatRepository` erhält Methoden für Bestellung und Zahlungsstatus (z. B. `initZahlung`, `holeZahlungsstatus`) anstelle der Kopplung „Fortschritt → `createSale`“. | `lib/data/parkautomat_repository.dart` |
| 3 | **Datenbank:** neue Tabelle `zahlungen` (Verkaufsbezug, Provider, Status, Referenz, Betrag, Idempotenz-Schlüssel) als Migration `0003`; `createSale` bleibt die Quittung und wird erst nach bestätigter Zahlung geschrieben. | Datenlayer (`lib/data/migrations/`) |
| 4 | **Statusmaschine statt Durchstich:** neu → autorisiert → erfasst → (fehlgeschlagen/storniert/erstattet); die Doppelkauf-Prüfung (E-58) wandert an den Zeitpunkt der Bestellung. | Fachlogik (`lib/logic/`) |
| 5 | **Client-Ablauf:** aus dem Ladebalken wird ein Interstitial mit Weiterleitung zu PayPal und Rückkehr in die App; Timeout und Abbruch bleiben bestehen. | `lib/screens/zahlungs_auswahl_screen.dart`, ARB-Texte (U-70) |
| 6 | **Sicherheit:** TLS, signierte Webhooks, Idempotenz-Schlüssel; keine Kartendaten im Client. | REST-Schicht, Webhook-Handling |
| 7 | **DSGVO und Protokollierung:** Zahlungsreferenzen nur gekürzt bzw. gehasht; E-48 und E-54 sind zu präzisieren. | `6_Logging_und_Datenschutz.md` |
| 8 | **Tests und Dokumentation:** Vertrags-Tests gegen die PayPal-Sandbox, Fehlerpfade (abgelehnt, abgelaufen, Netzausfall), Schutz gegen Webhook-Wiederholungen; Texte und Dokumente (`0_`, `2_`, `6_`) nachziehen. | lokales Gate `tool/gate.ps1` (U-52) |

**Betroffene Stellen im Code** (Stand 2026-09-24): `lib/screens/zahlungs_auswahl_screen.dart`
(ersetzt die Kopplung „Fortschritt → `createSale`“), `lib/data/parkautomat_repository.dart`
(erweiterter Vertrag), das Datenlayer (Migration `0003`) und die ARB-Texte (`lib/l10n/arb/`).

## Bezug zu den Entscheidungen

| Entscheidung | Inhalt | Umsetzung hier |
|---|---|---|
| E-04 | Contract first — die App kennt nur das Repository | Vorbedingung 2, Schritte 3–4 |
| E-11 | Web-Build nutzt InMemory bis zur REST-Schicht | Schritt 4 |
| E-43 | Produktion: gehostete Datenbank + REST; Anbieterwahl vor dem Release | Vorbedingung 1, Schritte 1, 3 |
| E-51, E-56 | Zahlungen simuliert; fünf Zahlungsarten | PayPal (Status quo) |
| E-48, E-54 | Logs nur mit Betriebsdaten; Aufbewahrung/Purge | Vorbedingung 5, PayPal-Schritt 7 |
| F-60 / E-60 (`U-78`) | Umstieg auf echte Zahlungen: analysiert, nicht umgesetzt | Abschnitt *PayPal* |

## Änderungshistorie

| Datum | Änderung |
|---|---|
| 2026-09-24 | Stub überarbeitet: Tippfehler bereinigt, Vorbedingungen und Schrittfolgen (DB-Umbau, PayPal) ergänzt, Querverweise auf die Detaildokumente hergestellt. |