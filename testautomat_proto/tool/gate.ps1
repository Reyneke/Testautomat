# Lokales CI-Gate (U-52): erzeugte Texte, Formatierung, Analyse und Tests.
#
# Verwendung:  powershell -ExecutionPolicy Bypass -File tool/gate.ps1
#
# Der GitHub-Actions-Workflow (U-60) ruft dieselben Schritte auf; die
# Lokalisierungsklassen werden aus den ARB-Dateien erzeugt und muessen zum
# eingecheckten Stand passen (U-70).

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
  Write-Output '==> flutter gen-l10n (Texte aus lib/l10n/arb erzeugen)'
  flutter gen-l10n
  if ($LASTEXITCODE -ne 0) { throw 'flutter gen-l10n ist fehlgeschlagen.' }

  Write-Output '==> git diff --exit-code -- lib/l10n/generated'
  git diff --exit-code -- lib/l10n/generated
  if ($LASTEXITCODE -ne 0) {
    throw 'Der erzeugte Lokalisierungscode passt nicht zur ARB-Datei - bitte mit einchecken.'
  }

  Write-Output '==> dart format --set-exit-if-changed lib test'
  dart format --set-exit-if-changed lib test
  if ($LASTEXITCODE -ne 0) { throw 'dart format hat Aenderungen gefunden.' }

  Write-Output '==> flutter analyze'
  flutter analyze
  if ($LASTEXITCODE -ne 0) { throw 'flutter analyze hat Befunde gemeldet.' }

  Write-Output '==> flutter test'
  flutter test
  if ($LASTEXITCODE -ne 0) { throw 'flutter test ist fehlgeschlagen.' }

  Write-Output 'Gate erfolgreich: Formatierung, Analyse und Tests sind gruen.'
}
finally {
  Pop-Location
}