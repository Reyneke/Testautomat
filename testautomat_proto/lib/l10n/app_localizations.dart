import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testautomat_proto/l10n/app_locale.dart';

/// Leichtgewichtige Mehrsprachigkeit (Deutsch/Englisch).
///
/// Bewusst ohne externe Pakete und ohne ARB-Generierung, damit der Prototyp
/// schlank bleibt. Für den späteren Ausbau kann auf `flutter_gen` migriert
/// werden, ohne die Aufrufstellen (`AppLocalizations.of(context).xyz`) zu
/// ändern.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    assert(
      localizations != null,
      'AppLocalizations.delegate fehlt in der MaterialApp.',
    );
    return localizations!;
  }

  static const Map<String, Map<String, String>> _values = {
    'de': {
      'appTitle': 'Parkautomat Weiden',
      'greetingMorning': 'Guten Morgen',
      'greetingAfternoon': 'Guten Tag',
      'greetingEvening': 'Guten Abend',
      'greetingNight': 'Gute Nacht',
      'startSale': 'Verkauf starten',
      'themeLight': 'Hell',
      'themeDark': 'Dunkel',
      'themeSystem': 'System',
      'languageGerman': 'Deutsch',
      'languageEnglish': 'Englisch',
      'debugMachine': 'Automatennummer',
      'debugLocation': 'Standort',
      'ladeMaschine': 'Automat wird gestartet …',
      'automatAusserBetrieb': 'Automat außer Betrieb',
      'automatAusserBetriebHinweis':
          'Die Daten des Automaten sind derzeit nicht erreichbar. Bitte wenden Sie sich an das Personal.',
      'erneutVersuchen': 'Erneut versuchen',
      'ausserhalbVerkaufszeit': 'Der Verkauf ist derzeit nicht möglich.',
      'ausserhalbVerkaufszeitHinweis':
          'Bitte nutzen Sie den Automaten innerhalb der Verkaufszeiten.',
      'neuLaden': 'Neu laden',
      'parkzeitAuswahlTitle': 'Parkzeit wählen',
      'parkzeitAuswahlHinweis': 'Bitte wählen Sie die gewünschte Parkdauer.',
      'laufendeParkdauer': 'Gewählte Parkdauer',
      'zahlungTitle': 'Zahlungsart wählen',
      'zahlungHinweis': 'Die Zahlung wird simuliert.',
      'zahlungsartBar': 'Bar',
      'zahlungsartKarte': 'Karte',
      'parkinfoTitle': 'Parkinformation',
      'parkinfoBelegHinweis': 'Der Parkschein wird nach der Zahlung angezeigt.',
      'weiter': 'Weiter',
      'zurueck': 'Zurück',
      'verabschiedungTitle': 'Auf Wiedersehen',
      'verabschiedungText': 'Vielen Dank und eine gute Fahrt!',
      'neuerVerkauf': 'Neuer Verkauf',
      'betrag': 'Betrag',
      'belegTitle': 'Parkschein',
      'belegnummer': 'Belegnummer',
      'gueltigBis': 'Gültig bis',
      'zahlungsart': 'Zahlungsart',
      'zahlungLaeuft': 'Zahlung wird verarbeitet …',
      'zahlungAbbrechen': 'Abbrechen',
      'zahlungAbgebrochen': 'Zahlung abgebrochen',
      'zahlungFehlgeschlagen': 'Die Zahlung konnte nicht abgeschlossen werden.',
      'debugTitle': 'Debug',
      'debugPinTitel': 'Debug-Zugang',
      'debugPinFeld': 'PIN',
      'debugPinFalsch': 'PIN ist falsch.',
      'debugAnmelden': 'Anmelden',
      'debugAbmelden': 'Abmelden',
      'debugAbbrechen': 'Abbrechen',
      'debugSchreibgeschuetzt': 'Im Produktivbuild sind Änderungen gesperrt.',
      'debugVerkaeufe': 'Verkäufe je Tag (UTC-Tage, lokal angezeigt)',
      'debugKeineVerkaeufe': 'Keine Verkäufe im Zeitraum.',
      'debugTelemetrie': 'Telemetrie (letzte 24 Stunden)',
      'debugZeitpunkt': 'Zeitpunkt',
      'debugStromverbrauch': 'Stromverbrauch',
      'debugBatterie': 'Batterie',
      'debugSignal': 'Signal',
      'debugPacketloss': 'Packetloss',
      'debugPreissettings': 'Preissettings',
      'debugVerkaufszeiten': 'Verkaufszeiten',
      'debugAendern': 'Ändern',
      'debugSpeichern': 'Speichern',
      'debugTaktMinuten': 'Takt (Minuten)',
      'debugPreisProTaktCent': 'Preis je Takt (Cent)',
      'debugWaehrung': 'Währung',
      'debugWochentag': 'Wochentag',
      'debugBeginn': 'Beginn (HH:MM)',
      'debugEnde': 'Ende (HH:MM)',
      'debugUngueltigeEingabe': 'Ungültige Eingabe.',
      'debugGueltigVon': 'Gültig von',
      'debugGueltigBis': 'Gültig bis',
      'debugKeineDaten': 'Keine Daten vorhanden.',
      'debugLadefehler': 'Daten konnten nicht geladen werden.',
      'debugSpeicherfehler': 'Speichern fehlgeschlagen.',
      'zahlungTimeout': 'Zeitüberschreitung bei der Zahlung',
    },
    'en': {
      'appTitle': 'Parking Meter Weiden',
      'greetingMorning': 'Good morning',
      'greetingAfternoon': 'Good afternoon',
      'greetingEvening': 'Good evening',
      'greetingNight': 'Good night',
      'startSale': 'Start sale',
      'themeLight': 'Light',
      'themeDark': 'Dark',
      'themeSystem': 'System',
      'languageGerman': 'German',
      'languageEnglish': 'English',
      'debugMachine': 'Machine number',
      'debugLocation': 'Location',
      'ladeMaschine': 'Starting up …',
      'automatAusserBetrieb': 'Machine out of service',
      'automatAusserBetriebHinweis':
          'The machine data cannot be reached right now. Please contact the staff.',
      'erneutVersuchen': 'Try again',
      'ausserhalbVerkaufszeit': 'Sales are currently not possible.',
      'ausserhalbVerkaufszeitHinweis':
          'Please use the machine during its business hours.',
      'neuLaden': 'Reload',
      'parkzeitAuswahlTitle': 'Choose parking time',
      'parkzeitAuswahlHinweis': 'Please choose the desired parking duration.',
      'laufendeParkdauer': 'Selected parking duration',
      'zahlungTitle': 'Choose payment method',
      'zahlungHinweis': 'The payment is simulated.',
      'zahlungsartBar': 'Cash',
      'zahlungsartKarte': 'Card',
      'parkinfoTitle': 'Parking information',
      'parkinfoBelegHinweis': 'The ticket is shown after the payment.',
      'weiter': 'Continue',
      'zurueck': 'Back',
      'verabschiedungTitle': 'Goodbye',
      'verabschiedungText': 'Thank you and have a good trip!',
      'neuerVerkauf': 'New sale',
      'betrag': 'Amount',
      'belegTitle': 'Parking ticket',
      'belegnummer': 'Ticket number',
      'gueltigBis': 'Valid until',
      'zahlungsart': 'Payment method',
      'zahlungLaeuft': 'Processing payment …',
      'zahlungAbbrechen': 'Cancel',
      'zahlungAbgebrochen': 'Payment cancelled',
      'zahlungFehlgeschlagen': 'The payment could not be completed.',
      'debugTitle': 'Debug',
      'debugPinTitel': 'Debug access',
      'debugPinFeld': 'PIN',
      'debugPinFalsch': 'PIN is wrong.',
      'debugAnmelden': 'Sign in',
      'debugAbmelden': 'Sign out',
      'debugAbbrechen': 'Cancel',
      'debugSchreibgeschuetzt': 'Changes are locked in the production build.',
      'debugVerkaeufe': 'Sales per day (UTC days, shown locally)',
      'debugKeineVerkaeufe': 'No sales in the period.',
      'debugTelemetrie': 'Telemetry (last 24 hours)',
      'debugZeitpunkt': 'Timestamp',
      'debugStromverbrauch': 'Power',
      'debugBatterie': 'Battery',
      'debugSignal': 'Signal',
      'debugPacketloss': 'Packet loss',
      'debugPreissettings': 'Price settings',
      'debugVerkaufszeiten': 'Selling hours',
      'debugAendern': 'Edit',
      'debugSpeichern': 'Save',
      'debugTaktMinuten': 'Interval (minutes)',
      'debugPreisProTaktCent': 'Price per interval (cent)',
      'debugWaehrung': 'Currency',
      'debugWochentag': 'Weekday',
      'debugBeginn': 'Start (HH:MM)',
      'debugEnde': 'End (HH:MM)',
      'debugUngueltigeEingabe': 'Invalid input.',
      'debugGueltigVon': 'Valid from',
      'debugGueltigBis': 'Valid until',
      'debugKeineDaten': 'No data available.',
      'debugLadefehler': 'Data could not be loaded.',
      'debugSpeicherfehler': 'Saving failed.',
      'zahlungTimeout': 'Payment timed out',
    },
  };

  String _get(String key) {
    final values = _values[locale.languageCode] ?? _values['de']!;
    return values[key] ?? key;
  }

  String get appTitle => _get('appTitle');
  String get greetingMorning => _get('greetingMorning');
  String get greetingAfternoon => _get('greetingAfternoon');
  String get greetingEvening => _get('greetingEvening');
  String get greetingNight => _get('greetingNight');
  String get startSale => _get('startSale');
  String get themeLight => _get('themeLight');
  String get themeDark => _get('themeDark');
  String get themeSystem => _get('themeSystem');
  String get languageGerman => _get('languageGerman');
  String get languageEnglish => _get('languageEnglish');
  String get debugMachine => _get('debugMachine');
  String get debugLocation => _get('debugLocation');
  String get ladeMaschine => _get('ladeMaschine');
  String get automatAusserBetrieb => _get('automatAusserBetrieb');
  String get automatAusserBetriebHinweis => _get('automatAusserBetriebHinweis');
  String get erneutVersuchen => _get('erneutVersuchen');
  String get ausserhalbVerkaufszeit => _get('ausserhalbVerkaufszeit');
  String get ausserhalbVerkaufszeitHinweis =>
      _get('ausserhalbVerkaufszeitHinweis');
  String get neuLaden => _get('neuLaden');
  String get parkzeitAuswahlTitle => _get('parkzeitAuswahlTitle');
  String get parkzeitAuswahlHinweis => _get('parkzeitAuswahlHinweis');
  String get laufendeParkdauer => _get('laufendeParkdauer');
  String get zahlungTitle => _get('zahlungTitle');
  String get zahlungHinweis => _get('zahlungHinweis');
  String get zahlungsartBar => _get('zahlungsartBar');
  String get zahlungsartKarte => _get('zahlungsartKarte');
  String get parkinfoTitle => _get('parkinfoTitle');
  String get parkinfoBelegHinweis => _get('parkinfoBelegHinweis');
  String get weiter => _get('weiter');
  String get zurueck => _get('zurueck');
  String get verabschiedungTitle => _get('verabschiedungTitle');
  String get verabschiedungText => _get('verabschiedungText');
  String get neuerVerkauf => _get('neuerVerkauf');
  String get betrag => _get('betrag');
  String get belegTitle => _get('belegTitle');
  String get belegnummer => _get('belegnummer');
  String get gueltigBis => _get('gueltigBis');
  String get zahlungsart => _get('zahlungsart');
  String get zahlungLaeuft => _get('zahlungLaeuft');
  String get zahlungAbbrechen => _get('zahlungAbbrechen');
  String get zahlungAbgebrochen => _get('zahlungAbgebrochen');
  String get zahlungFehlgeschlagen => _get('zahlungFehlgeschlagen');
  String get debugTitle => _get('debugTitle');
  String get debugPinTitel => _get('debugPinTitel');
  String get debugPinFeld => _get('debugPinFeld');
  String get debugPinFalsch => _get('debugPinFalsch');
  String get debugAnmelden => _get('debugAnmelden');
  String get debugAbmelden => _get('debugAbmelden');
  String get debugAbbrechen => _get('debugAbbrechen');
  String get debugSchreibgeschuetzt => _get('debugSchreibgeschuetzt');
  String get debugVerkaeufe => _get('debugVerkaeufe');
  String get debugKeineVerkaeufe => _get('debugKeineVerkaeufe');
  String get debugTelemetrie => _get('debugTelemetrie');
  String get debugZeitpunkt => _get('debugZeitpunkt');
  String get debugStromverbrauch => _get('debugStromverbrauch');
  String get debugBatterie => _get('debugBatterie');
  String get debugSignal => _get('debugSignal');
  String get debugPacketloss => _get('debugPacketloss');
  String get debugPreissettings => _get('debugPreissettings');
  String get debugVerkaufszeiten => _get('debugVerkaufszeiten');
  String get debugAendern => _get('debugAendern');
  String get debugSpeichern => _get('debugSpeichern');
  String get debugTaktMinuten => _get('debugTaktMinuten');
  String get debugPreisProTaktCent => _get('debugPreisProTaktCent');
  String get debugWaehrung => _get('debugWaehrung');
  String get debugWochentag => _get('debugWochentag');
  String get debugBeginn => _get('debugBeginn');
  String get debugEnde => _get('debugEnde');
  String get debugUngueltigeEingabe => _get('debugUngueltigeEingabe');
  String get debugGueltigVon => _get('debugGueltigVon');
  String get debugGueltigBis => _get('debugGueltigBis');
  String get debugKeineDaten => _get('debugKeineDaten');
  String get debugLadefehler => _get('debugLadefehler');
  String get debugSpeicherfehler => _get('debugSpeicherfehler');
  String get zahlungTimeout => _get('zahlungTimeout');

  /// Geldbetrag als Text, z. B. `2,00 €` bzw. `€2.00`.
  String formatBetrag(int cent) {
    final betrag = cent.abs();
    final euro = betrag ~/ 100;
    final rest = (betrag % 100).toString().padLeft(2, '0');
    final vorzeichen = cent < 0 ? '-' : '';
    return locale.languageCode == 'en'
        ? '$vorzeichen\u20ac$euro.$rest'
        : '$vorzeichen$euro,$rest \u20ac';
  }

  /// Parkdauer als Text, z. B. `4 Stunden` bzw. `4 hours`.
  String formatParkdauer(int minuten) {
    final stunden = minuten ~/ 60;
    final restMinuten = minuten % 60;
    final String stundenText;
    if (locale.languageCode == 'en') {
      stundenText = stunden == 1 ? '1 hour' : '$stunden hours';
    } else {
      stundenText = stunden == 1 ? '1 Stunde' : '$stunden Stunden';
    }
    return restMinuten == 0 ? stundenText : '$stundenText $restMinuten min';
  }

  /// Uhrzeit im 24-Stunden-Format, z. B. `08:05`.
  String formatTime(DateTime dateTime) {
    final hours = dateTime.hour.toString().padLeft(2, '0');
    final minutes = dateTime.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  /// Datum, z. B. `18.09.2026` (deutsche Schreibweise) bzw. `09/18/2026`.
  String formatDate(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    if (locale.languageCode == 'en') {
      return '$month/$day/${dateTime.year}';
    }
    return '$day.$month.${dateTime.year}';
  }

  /// Uhrzeitangemessene Begrüßung für den übergebenen Zeitpunkt.
  String greetingFor(DateTime dateTime) {
    final hour = dateTime.hour;
    if (hour >= 5 && hour < 11) {
      return greetingMorning;
    }
    if (hour >= 11 && hour < 18) {
      return greetingAfternoon;
    }
    if (hour >= 18 && hour < 22) {
      return greetingEvening;
    }
    return greetingNight;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocale.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) =>
      SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
