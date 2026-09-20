# Build, Release & Hosting

Bezugnehmend auf das Basisdokument (`0_Einfuehrung.md`) beschreibt dieses Dokument, wie das Projekt versioniert, gebaut, ausgeliefert und gehostet wird: GitHub dient als Versionsverwaltung und CI/CD-Pipeline (GitHub Actions), GitHub Releases stellen die ausführbaren Dateien bereit, und der Webclient wird als statische Seite auf GitHub Pages gehostet.

## Zielplattformen

Die App ist mit Flutter für folgende Plattformen vorgesehen:

| Plattform | Artefakt | Anmerkung |
|---|---|---|
| Android | APK (direkte Installation) und AAB (Store) | Signierung offen |
| Windows | Installer (MSIX/EXE) | Signierung offen |
| Linux | Paket (AppImage/DEB) | Signierung offen |
| Web | Statische Build-Ausgabe (`build/web`) | Hosting über GitHub Pages |

**Nicht-Zielplattformen:** macOS und iOS. Grund: Für eine sinnvolle Entwicklung und Signierung ist ein Macintosh bzw. ein Apple Developer Account nötig, der nicht vorhanden ist. Die Release-Artefakte bleiben damit auf Plattformen beschränkt, die sich mit kostenlosen GitHub-Runnern bauen lassen.

## README.md

Das README soll so ausgebaut werden, dass ein Leser auf einen Blick versteht, worum es in diesem Projekt geht. Vorgesehene Abschnitte:

- **Worum geht es?** – Projektzweck (Frontend für einen Parkautomaten, Prototyp) mit Verweis auf `doc/plan/`.
- **Zielplattformen** – Liste aus diesem Dokument.
- **Getting Started** – Flutter-Voraussetzungen, `flutter run`, lokale SQLite-Datenbank.
- **Downloads** – Verweise auf die Release-Artefakte (siehe Workflows).
- **Status** – CI-Badge (Build-Status) und Link auf die letzte Release-Version.
- **Hinweise** – DSGVO: keine personenbezogenen Daten, alle Zahlungen simuliert.

## Workflows (CI/CD)

Bei jedem Push auf `main` und bei neuen Release-Tags baut eine GitHub-Actions-Pipeline die ausführbaren Dateien. Grundsatz: **Artefakte gehören in GitHub Releases, nicht in den Repository-Verzeichnisbaum.** Die README verlinkt auf die Releases, sodass die Pipeline die README nicht per automatisiertem Push umschreiben muss.

### Pipelinedesign (`build.yml`)

1. **Trigger**
   - `push` auf `main` – Vorschau-/Testlauf für alle Plattformen
   - `push` auf Tags `v*` – finales Release (semantische Versionierung)
2. **Gate:** Job `test` mit `flutter analyze` und `flutter test`, bevor gebaut wird.
3. **Build-Jobs** (Matrix):
   - `android`: `flutter build apk --release` (+ optional AAB)
   - `windows`: `flutter build windows --release`
   - `linux`: `flutter build linux --release`
   - `web`: `flutter build web --release`
4. **Veröffentlichung**
   - Bei Tag: Artefakte über `softprops/action-gh-release` an das GitHub Release anhängen (`GITHUB_TOKEN`, kein PAT nötig).
   - Bei `push` auf `main`: Artefakte als Workflow-Artifacts ablegen (Vorschau, 90 Tage verfügbar).
5. **README-Links**
   - Abschnitt „Downloads“ verlinkt auf die neueste Release-Version (`https://github.com/<owner>/<repo>/releases/latest`) – der Link bricht bei neuen Releases nicht.
   - CI-Badge macht fehlgeschlagene Builds sofort sichtbar.

### Umsetzungshinweise

- **Flutter-Setup** über `subosito/flutter-action` mit Caching des Flutter-SDKs und `pub cache` (Buildzeit).
- **Semantische Versionierung:** Version aus `pubspec.yaml` (`1.0.0+1`), Tags nach `vX.Y.Z`.
- **Code-Signing:** Für Android/Windows/Linux noch offen; für die Prototyp-Phase reicht un-signierte Auslieferung (Installationswarnung in Kauf nehmen).
- **Keine Artefakte im Repo:** `build/` sowie erzeugte Installer gehören in `.gitignore`.

## Hosting

Der Webclient wird als **statische** Seite auf GitHub Pages gehostet. Eine Datenbank kann GitHub Pages nicht bereitstellen – Pages ist ein statischer Host ohne Serverprozesse. Für den Prototypen lädt die App ihre Daten daher aus der lokal abgelegten SQLite-Datei (vgl. `2_Datenbank.md`).

| Komponente | Prototyp | Produktion (Perspektive) |
|---|---|---|
| Webclient | GitHub Pages (Deploy-Job aus der CI) | GitHub Pages oder CDN |
| Daten | SQLite-Datei im Projekt (lokal) | REST-API + gehostete Datenbank (offen) |

**GitHub-Pages-Deployment:** Eigener Job `deploy` im Workflow (z. B. `actions/upload-pages-artifact` + `actions/deploy-pages`), ausgelöst bei Pushes auf `main` und bei Release-Tags.

## Offene Punkte (Backlog)

- **Signierung:** Wer signiert Android/Windows/Linux-Artefakte (Zertifikate, Kosten)?
- **Store-Distribution:** Zusätzlich Play Store / MS Store / winget / Flatpak?
- **DB-Hosting in Produktion:** Welcher Anbieter, wo läuft die REST-API?
- **Aktualisierung:** Wie kommt die App auf den Automaten (manueller Download, Self-Update)?
- **Web-Entscheidung:** Flutter Web kann nicht direkt auf SQLite zugreifen – Speicher-/REST-Simulation vor dem Web-Build festlegen (vgl. `2_Datenbank.md`).

## Mögliche Probleme

- **Runner-Beschränkungen:** Android-Builds brauchen Java/Android-SDK – Konfiguration über `subosito/flutter-action`, Build-Umgebung im Workflow fixieren.
- **Link-Pflege:** Feste „latest“-Links brechen nicht; automatisch generierte Download-Tabellen in der README würden bei jedem Release einen zusätzlichen Commit erzeugen (bewusst vermieden).
- **Artefaktgrößen:** Flutter-Releases sind mehrere 10 MB groß – Artefakte nur bei Tags als Release veröffentlichen, nicht bei jedem Push.
- **Widerspruch zu `0_Einfuehrung.md`:** Dort heißt es unter „Bauziele“ „alle Betriebssysteme, inklusive Web“ – mit den Nicht-Zielplattformen macOS/iOS abgleichen und das Basisdokument ggf. präzisieren.
