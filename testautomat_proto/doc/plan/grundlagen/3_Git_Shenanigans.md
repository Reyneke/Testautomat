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

Die Pipeline ist umgesetzt und liegt in `.github/workflows/build.yml`:

1. **Trigger:** `push` auf `main` (Vorschau), `push` auf Tags `v*` (Release) sowie manueller Start.
2. **Gate `test`:** `dart format --set-exit-if-changed lib test`, `flutter analyze`, `flutter test` - dieselben Schritte wie das lokale Gate (`tool/gate.ps1`, U-52).
3. **Build-Matrix `build`** (erst nach dem Gate):
   - `android`: `flutter build apk --release` (Java 17 ueber `actions/setup-java`, Android-Lizenzen ueber `flutter doctor --android-licenses`)
   - `windows`: `flutter build windows --release` (ZIP des Release-Ordners)
   - `linux`: `flutter build linux --release` (tar.gz des Bundles; GTK-Abhaengigkeiten werden vorher installiert)
   - `web`: `flutter build web --release --base-href="$BASE_HREF"` mit `BASE_HREF=/<repo>/` (E-44)
4. **Artefakte:** jeder Matrix-Job legt sein Paket als Workflow-Artefakt ab (Vorschau, 90 Tage); der Web-Inhalt wird zusaetzlich unverpackt fuer Pages abgelegt. `build/` bleibt in `.gitignore`.
5. **`release`:** Bei Tags `v*` laedt ein eigener Job alle Pakete und haengt sie mit generierten Release-Notes an das GitHub-Release (`softprops/action-gh-release`, `GITHUB_TOKEN`). Das Release ist zugleich das Changelog (E-33).
6. **`deploy`:** Bei `push` auf `main` veroeffentlicht ein Job den Web-Build ueber `actions/deploy-pages`; der Web-Build bringt die Basis-URL der Projektseite bereits mit.
7. **README-Links:** Abschnitt „Downloads“ verlinkt auf `/releases/latest`; das CI-Badge zeigt den Stand des Workflows.

> **Einmalige Einrichtung:** In den Repository-Einstellungen unter *Pages* muss als Quelle **„GitHub Actions“** gewaehlt sein, sonst ueberspringt der Workflow den Deploy mit einer Warnung (der uebrige Lauf bleibt gruen). Pages ist inzwischen aktiviert; der Job prueft den Status bei jedem Lauf selbst.

### Versionierung, Tags und Changelog

- **Version:** Eine Quelle der Wahrheit ist `pubspec.yaml` (`1.0.0+1`); die Artefakte uebernehmen sie automatisch.
- **Tag:** Nach einem gruenen `main`-Lauf wird ein annotierter Tag `vX.Y.Z` gesetzt (`git tag -a v0.1.0 -m "Erstes Release"`).
- **Release und Changelog:** Der Tag-Lauf baut alle Plattformen und legt das Release mit generierten Notes an (GitHub Releases); ein eigener `CHANGELOG.md` entfaellt (E-33).
- **Un-signierte Artefakte:** Der Prototyp bleibt un-signiert (E-42); die Installationswarnung ist in der README benannt.
### Umsetzungshinweise

- **Flutter-Setup** über `subosito/flutter-action` mit Caching des Flutter-SDKs und `pub cache` (Buildzeit).
- **Semantische Versionierung:** Version aus `pubspec.yaml` (`1.0.0+1`), Tags nach `vX.Y.Z`.
- **Code-Signing:** Für Android/Windows/Linux noch offen; für die Prototyp-Phase reicht un-signierte Auslieferung (Installationswarnung in Kauf nehmen).
- **Lokales Gate:** `tool/gate.ps1` fuehrt `dart format --set-exit-if-changed lib test`, `flutter analyze` und `flutter test` aus; der Workflow (U-60) nutzt dieselben Schritte (U-52).
- **Keine Artefakte im Repo:** `build/` sowie erzeugte Installer gehören in `.gitignore`.

## Hosting

Der Webclient wird als **statische** Seite auf GitHub Pages gehostet. Eine Datenbank kann GitHub Pages nicht bereitstellen – Pages ist ein statischer Host ohne Serverprozesse. Der Desktop-Prototyp lädt seine Daten daher aus der lokal abgelegten SQLite-Datei, der Web-Build aus dem `InMemoryRepository` mit denselben Seed-Daten (vgl. `2_Datenbank.md`, E-11).

| Komponente | Prototyp | Produktion (Perspektive) |
|---|---|---|
| Webclient | GitHub Pages (Deploy-Job aus der CI) | GitHub Pages oder CDN |
| Daten (Desktop) | SQLite-Datei im Projekt (lokal) | Postgres + REST-API, Token-Authentifizierung (Anbieter offen, E-43) |
| Daten (Web) | `InMemoryRepository` (ohne Persistenz) | Postgres + REST-API, Token-Authentifizierung (Anbieter offen, E-43) |

**GitHub-Pages-Deployment:** Eigener Job `deploy` im Workflow (z. B. `actions/upload-pages-artifact` + `actions/deploy-pages`), ausgelöst bei Pushes auf `main` und bei Release-Tags.

## Offene Punkte (Backlog)

- **Signierung:** abgeschlossen — der Prototyp bleibt un-signiert (E-42).
- **Store-Distribution:** abgeschlossen — zusätzliche Kanäle erst mit einer Weiterentwicklung (E-30).
- **DB-Hosting in Produktion:** abgeschlossen — gehostete Postgres-Datenbank mit REST-Schicht und Token-Authentifizierung; Anbieterwahl vor dem ersten Release (E-43).
- **Aktualisierung:** abgeschlossen — Self-Update (E-31).

## Mögliche Probleme

- **Runner-Beschränkungen:** Die GitHub-Runner bringen das Android-SDK mit; für den Android-Build fehlen in der Standardkonfiguration nur das passende JDK und die Lizenzabnahme. Im Workflow daher `actions/setup-java@v4` (Temurin 17) vor `subosito/flutter-action@v2` ausführen, die Flutter-Version pinnen und die SDK-Lizenzen einmalig mit `flutter doctor --android-licenses` akzeptieren.
- **Link-Pflege:** Feste „latest“-Links brechen nicht; automatisch generierte Download-Tabellen in der README würden bei jedem Release einen zusätzlichen Commit erzeugen (bewusst vermieden).
- **Artefaktgrößen:** Flutter-Releases sind mehrere 10 MB groß – Artefakte nur bei Tags als Release veröffentlichen, nicht bei jedem Push.
