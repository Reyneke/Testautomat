/// Texte der App (E-05, E-17, U-70).
///
/// Die Texte liegen als ARB-Dateien unter `lib/l10n/arb/` (Deutsch und
/// Englisch) und werden von `flutter gen-l10n` nach `lib/l10n/generated/`
/// erzeugt; die Konfiguration steht in `l10n.yaml`, `generate: true` in der
/// `pubspec.yaml` laesst den Lauf bei `flutter pub get` mitlaufen.
///
/// Diese Datei bleibt der Einstiegspunkt fuer die Aufrufstellen
/// (`AppLocalizations.of(context)!.xyz`) und reicht die erzeugten Klassen
/// sowie die App-Helfer weiter. Ein fehlender Schluessel faellt beim
/// Erzeugen auf: `flutter gen-l10n` meldet nicht uebersetzte Nachrichten.
library;

export 'app_localizations_extra.dart';
export 'generated/app_localizations.dart';
