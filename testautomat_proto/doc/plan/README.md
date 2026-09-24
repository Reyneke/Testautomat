# Planungsunterlagen (`doc/plan`)

Kurzbeschreibung der Grundlagendokumente des Testautomat-Prototyps und die Reihenfolge, in der
sie gelesen werden sollten. Alle Dokumente sind auf Deutsch und bauen aufeinander auf: Das
Basisdokument beschreibt das *Was*, die Detaildokumente das *Wie*, die beiden
Steuerungsdokumente den Stand der Klärung und die Umsetzungsreihenfolge.

Stand: 2026-09-24.

## Die Dokumente

| Dokument | Rolle | Kurzbeschreibung |
|---|---|---|
| [`grundlagen/0_Einfuehrung.md`](grundlagen/0_Einfuehrung.md) | Basisdokument | Projektzweck, die sechs Bildschirme, Datenbanküberblick, DSGVO-Grenzen und Bauziele |
| [`grundlagen/1_Frontendstruktur.md`](grundlagen/1_Frontendstruktur.md) | Detail | Theme (Standard Dunkel), Mehrsprachigkeit (Deutsch/Englisch), gemeinsames Bildschirm-Layout, Barrierefreiheit |
| [`grundlagen/2_Datenbank.md`](grundlagen/2_Datenbank.md) | Detail | Schema (SQLite-DDL), Repository-Vertrag mit DTOs, Debug-Bildschirm, Migrationen und Seed-Daten |
| [`grundlagen/3_Git_Shenanigans.md`](grundlagen/3_Git_Shenanigans.md) | Detail | Zielplattformen, CI/CD-Workflows (`build.yml`), Release-Prozess und Hosting |
| [`grundlagen/4_Offene_Fragen.md`](grundlagen/4_Offene_Fragen.md) | Steuerung | Fragenkatalog (`F-01`…`F-60`), Entscheidungslog (`E-01`…`E-60`), Dokumentationsabgleich, Risiken |
| [`grundlagen/5_Umsetzungsplan.md`](grundlagen/5_Umsetzungsplan.md) | Steuerung | Meilensteine (`M0`–`M5`), Arbeitspakete (`U-01`…`U-78`) mit Status und Definition of Done |
| [`grundlagen/6_Logging_und_Datenschutz.md`](grundlagen/6_Logging_und_Datenschutz.md) | Detail | Protokollierung nur mit Betriebsdaten, Rotation, Aufbewahrungs- und Purge-Konzept (E-48, E-54) |
| [`grundlagen/7_Neue_Zahlmoeglichkeiten.md`](grundlagen/7_Neue_Zahlmoeglichkeiten.md) | Detail | Neue Zahlungsarten (PayPal, Google Wallet, Google Pay), Parkticket als PDF, Kennzeicheneingabe, Parkzonen und der Umstiegspfad auf echte Zahlungen (E-56…E-60, U-74…U-78) |
| [`grundlagen/8_Umbau_auf_DB.md`](grundlagen/8_Umbau_auf_DB.md) | Detail | Roadmap für den Umbau auf eine echte Datenbank: Vorbedingungen, Schrittfolge und die Schritte zur ersten echten Zahlungsart (E-43, U-62, U-78) |

## Empfohlene Lesereihenfolge

1. **[`0_Einfuehrung.md`](grundlagen/0_Einfuehrung.md)** — Kontext, Zielbild und Nicht-Ziele.
2. **[`1_Frontendstruktur.md`](grundlagen/1_Frontendstruktur.md)**, **[`2_Datenbank.md`](grundlagen/2_Datenbank.md)** und **[`3_Git_Shenanigans.md`](grundlagen/3_Git_Shenanigans.md)** — die drei Detailstränge (Oberfläche, Daten, Betrieb und Auslieferung); sie lassen sich unabhängig lesen.
3. **[`4_Offene_Fragen.md`](grundlagen/4_Offene_Fragen.md)** — welche Frage wie und warum entschieden wurde.
4. **[`5_Umsetzungsplan.md`](grundlagen/5_Umsetzungsplan.md)** — was in welcher Reihenfolge gebaut wird und wann ein Arbeitspaket fertig ist.
5. **[`6_Logging_und_Datenschutz.md`](grundlagen/6_Logging_und_Datenschutz.md)** — was der Automat protokolliert und welche Aufbewahrungsregeln gelten.
6. **[`7_Neue_Zahlmoeglichkeiten.md`](grundlagen/7_Neue_Zahlmoeglichkeiten.md)** — die nach dem Praxistest ergänzten Anforderungen (Zahlungsarten, PDF-Beleg, Kennzeichen, Parkzonen).
7. **[`8_Umbau_auf_DB.md`](grundlagen/8_Umbau_auf_DB.md)** — die Schritte vom Prototyp zur gehosteten Datenbank und zur ersten echten Zahlungsart.

## Wo steht was?

| Frage | Nachschlagen in |
|---|---|
| Was ist der Prototyp, und was gehört nicht dazu? | `0_Einfuehrung.md` (Bildschirme, Grenzen, Bauziele) |
| Wie baue ich das Projekt und starte die App? | [`../README.md`](../README.md) (Getting Started) |
| Fortschritt und nächste Schritte | `5_Umsetzungsplan.md` (Statusspalten, Meilensteine `M0`–`M4`) |
| Offene oder entschiedene Punkte samt Begründung | `4_Offene_Fragen.md` (`F-`/`E-`IDs) |
| Datenmodell, Vertrag, Migrationen, Seeds | `2_Datenbank.md` |
| Build, Release, Hosting, CI/CD | `3_Git_Shenanigans.md` |
| Theme, Sprache, Layout, Barrierefreiheit | `1_Frontendstruktur.md` |
| Zahlungsarten, PDF-Beleg, Kennzeichen, Parkzonen | `7_Neue_Zahlmoeglichkeiten.md` |
| Bedeutung von „PSP" und Weg zu echten Zahlungen | `7_Neue_Zahlmoeglichkeiten.md` (*Begriff: PSP*, *Umstieg auf echte Zahlungen*) |
| Umbau auf eine echte Datenbank und erste echte Zahlungsart | `8_Umbau_auf_DB.md` |

## Kennungen

| Kennung | Bedeutung |
|---|---|
| `F-xx` | Frage aus dem Fragenkatalog in `4_Offene_Fragen.md` |
| `E-xx` | Entscheidung aus dem Entscheidungslog in `4_Offene_Fragen.md` |
| `U-xx` | Arbeitspaket im Umsetzungsplan (`5_Umsetzungsplan.md`) |
| `Mx` | Meilenstein im Umsetzungsplan |

## Pflege

- Neue Punkte erhalten eine `F-`ID in `4_Offene_Fragen.md`; jede Klärung wird dort mit Datum, Entscheidung und Begründung als `E-`ID nachgehalten.
- Jede Entscheidung erzeugt oder aktualisiert ein Arbeitspaket in `5_Umsetzungsplan.md` (`U-`ID mit Status und Definition of Done); Abweichungen kommen in die Änderungshistorie.
- Widersprüche zwischen Dokument und Code gehören in den *Dokumentationsabgleich* in `4_Offene_Fragen.md`.