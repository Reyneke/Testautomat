# Lokales CI-Gate (U-52): Formatierung, Analyse und Tests.
#
# Verwendung:  powershell -ExecutionPolicy Bypass -File tool/gate.ps1
#
# Der spaetere GitHub-Actions-Workflow (U-60) ruft dieselben Schritte auf.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
Push-Location $root
try {
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