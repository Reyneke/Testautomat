# Planungsunterlagen (`doc/plan`)

Kurzbeschreibung der Grundlagendokumente des Testautomat-Prototyps und die Reihenfolge, in der
sie gelesen werden sollten. Alle Dokumente sind auf Deutsch und bauen aufeinander auf: Das
Basisdokument beschreibt das *Was*, die drei Detaildokumente das *Wie*, die beiden
Steuerungsdokumente den Stand der Klärung und die Umsetzungsreihenfolge.

Stand: 2026-09-22.

## Die Dokumente

| Dokument | Rolle | Kurzbeschreibung |
|---|---|---|
| [`grundlagen/0_Einfuehrung.md`](grundlagen/0_Einfuehrung.md) | Basisdokument | Projektzweck, die sechs Bildschirme, Datenbanküberblick, DSGVO-Grenzen und Bauziele |
| [`grundlagen/1_Frontendstruktur.md`](grundlagen/1_Frontendstruktur.md) | Detail | Theme (Standard Dunkel), Mehrsprachigkeit (Deutsch/Englisch), gemeinsames Bildschirm-Layout, Barrierefreiheit |
| [`grundlagen/2_Datenbank.md`](grundlagen/2_Datenbank.md) | Detail | Schema (SQLite-DDL), Repository-Vertrag mit DTOs, Debug-Bildschirm, Migrationen und Seed-Daten |
| [`grundlagen/3_Git_Shenanigans.md`](grundlagen/3_Git_Shenanigans.md) | Detail | Zielplattformen, CI/CD-Workflows (`build.yml`), Release-Prozess und Hosting |
| [`grundlagen/4_Offene_Fragen.md`](grundlagen/4_Offene_Fragen.md) | Steuerung | Fragenkatalog (`F-01`…`F-55`), Entscheidungslog (`E-01`…`E-55`), Dokumentationsabgleich, Risiken |
| [`grundlagen/5_Umsetzungsplan.md`](grundlagen/5_Umsetzungsplan.md) | Steuerung | Meilensteine (`M0`–`M4`), Arbeitspakete (`U-01`…`U-73`) mit Status und Definition of Done |

## Empfohlene Lesereihenfolge

1. **[`0_Einfuehrung.md`](grundlagen/0_Einfuehrung.md)** — Kontext, Zielbild und Nicht-Ziele.
2. **[`1_Frontendstruktur.md`](grundlagen/1_Frontendstruktur.md)**, **[`2_Datenbank.md`](grundlagen/2_Datenbank.md)** und **[`3_Git_Shenanigans.md`](grundlagen/3_Git_Shenanigans.md)** — die drei Detailstränge (Oberfläche, Daten, Betrieb und Auslieferung); sie lassen sich unabhängig lesen.
3. **[`4_Offene_Fragen.md`](grundlagen/4_Offene_Fragen.md)** — welche Frage wie und warum entschieden wurde.
4. **[`5_Umsetzungsplan.md`](grundlagen/5_Umsetzungsplan.md)** — was in welcher Reihenfolge gebaut wird und wann ein Arbeitspaket fertig ist.

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