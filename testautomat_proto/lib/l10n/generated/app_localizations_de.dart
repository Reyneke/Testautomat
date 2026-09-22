// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Parkautomat Weiden';

  @override
  String get greetingMorning => 'Guten Morgen';

  @override
  String get greetingAfternoon => 'Guten Tag';

  @override
  String get greetingEvening => 'Guten Abend';

  @override
  String get greetingNight => 'Gute Nacht';

  @override
  String get startSale => 'Verkauf starten';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'System';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get debugMachine => 'Automatennummer';

  @override
  String get debugLocation => 'Standort';

  @override
  String get ladeMaschine => 'Automat wird gestartet …';

  @override
  String get automatAusserBetrieb => 'Automat außer Betrieb';

  @override
  String get automatAusserBetriebHinweis =>
      'Die Daten des Automaten sind derzeit nicht erreichbar. Bitte wenden Sie sich an das Personal.';

  @override
  String get erneutVersuchen => 'Erneut versuchen';

  @override
  String get ausserhalbVerkaufszeit => 'Der Verkauf ist derzeit nicht möglich.';

  @override
  String get ausserhalbVerkaufszeitHinweis =>
      'Bitte nutzen Sie den Automaten innerhalb der Verkaufszeiten.';

  @override
  String get neuLaden => 'Neu laden';

  @override
  String get parkzeitAuswahlTitle => 'Parkzeit wählen';

  @override
  String get parkzeitAuswahlHinweis =>
      'Bitte wählen Sie die gewünschte Parkdauer.';

  @override
  String get laufendeParkdauer => 'Gewählte Parkdauer';

  @override
  String get zahlungTitle => 'Zahlungsart wählen';

  @override
  String get zahlungHinweis => 'Die Zahlung wird simuliert.';

  @override
  String get zahlungsartBar => 'Bar';

  @override
  String get zahlungsartKarte => 'Karte';

  @override
  String get parkinfoTitle => 'Parkinformation';

  @override
  String get parkinfoBelegHinweis =>
      'Der Parkschein wird nach der Zahlung angezeigt.';

  @override
  String get weiter => 'Weiter';

  @override
  String get zurueck => 'Zurück';

  @override
  String get verabschiedungTitle => 'Auf Wiedersehen';

  @override
  String get verabschiedungText => 'Vielen Dank und eine gute Fahrt!';

  @override
  String get neuerVerkauf => 'Neuer Verkauf';

  @override
  String get betrag => 'Betrag';

  @override
  String get belegTitle => 'Parkschein';

  @override
  String get belegnummer => 'Belegnummer';

  @override
  String get gueltigBis => 'Gültig bis';

  @override
  String get zahlungsart => 'Zahlungsart';

  @override
  String get zahlungLaeuft => 'Zahlung wird verarbeitet …';

  @override
  String get zahlungAbbrechen => 'Abbrechen';

  @override
  String get zahlungAbgebrochen => 'Zahlung abgebrochen';

  @override
  String get zahlungFehlgeschlagen =>
      'Die Zahlung konnte nicht abgeschlossen werden.';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugPinTitel => 'Debug-Zugang';

  @override
  String get debugPinFeld => 'PIN';

  @override
  String get debugPinFalsch => 'PIN ist falsch.';

  @override
  String get debugAnmelden => 'Anmelden';

  @override
  String get debugAbmelden => 'Abmelden';

  @override
  String get debugAbbrechen => 'Abbrechen';

  @override
  String get debugSchreibgeschuetzt =>
      'Im Produktivbuild sind Änderungen gesperrt.';

  @override
  String get debugVerkaeufe => 'Verkäufe je Tag (UTC-Tage, lokal angezeigt)';

  @override
  String get debugKeineVerkaeufe => 'Keine Verkäufe im Zeitraum.';

  @override
  String get debugTelemetrie => 'Telemetrie (letzte 24 Stunden)';

  @override
  String get debugZeitpunkt => 'Zeitpunkt';

  @override
  String get debugStromverbrauch => 'Stromverbrauch';

  @override
  String get debugBatterie => 'Batterie';

  @override
  String get debugSignal => 'Signal';

  @override
  String get debugPacketloss => 'Packetloss';

  @override
  String get debugPreissettings => 'Preissettings';

  @override
  String get debugVerkaufszeiten => 'Verkaufszeiten';

  @override
  String get debugAendern => 'Ändern';

  @override
  String get debugSpeichern => 'Speichern';

  @override
  String get debugTaktMinuten => 'Takt (Minuten)';

  @override
  String get debugPreisProTaktCent => 'Preis je Takt (Cent)';

  @override
  String get debugWaehrung => 'Währung';

  @override
  String get debugWochentag => 'Wochentag';

  @override
  String get debugBeginn => 'Beginn (HH:MM)';

  @override
  String get debugEnde => 'Ende (HH:MM)';

  @override
  String get debugUngueltigeEingabe => 'Ungültige Eingabe.';

  @override
  String get debugGueltigVon => 'Gültig von';

  @override
  String get debugGueltigBis => 'Gültig bis';

  @override
  String get debugKeineDaten => 'Keine Daten vorhanden.';

  @override
  String get debugLadefehler => 'Daten konnten nicht geladen werden.';

  @override
  String get debugSpeicherfehler => 'Speichern fehlgeschlagen.';

  @override
  String get zahlungTimeout => 'Zeitüberschreitung bei der Zahlung';
}
