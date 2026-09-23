// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Parking Meter Weiden';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get greetingNight => 'Good night';

  @override
  String get startSale => 'Start sale';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get languageGerman => 'German';

  @override
  String get languageEnglish => 'English';

  @override
  String get debugMachine => 'Machine number';

  @override
  String get debugLocation => 'Location';

  @override
  String get ladeMaschine => 'Starting up …';

  @override
  String get automatAusserBetrieb => 'Machine out of service';

  @override
  String get automatAusserBetriebHinweis =>
      'The machine data cannot be reached right now. Please contact the staff.';

  @override
  String get erneutVersuchen => 'Try again';

  @override
  String get ausserhalbVerkaufszeit => 'Sales are currently not possible.';

  @override
  String get ausserhalbVerkaufszeitHinweis =>
      'Please use the machine during its business hours.';

  @override
  String get neuLaden => 'Reload';

  @override
  String get parkzeitAuswahlTitle => 'Choose parking time';

  @override
  String get parkzeitAuswahlHinweis =>
      'Please choose the desired parking duration.';

  @override
  String get laufendeParkdauer => 'Selected parking duration';

  @override
  String get zahlungTitle => 'Choose payment method';

  @override
  String get zahlungHinweis => 'The payment is simulated.';

  @override
  String get zahlungsartBar => 'Cash';

  @override
  String get zahlungsartKarte => 'Card';

  @override
  String get parkinfoTitle => 'Parking information';

  @override
  String get parkinfoBelegHinweis => 'The ticket is shown after the payment.';

  @override
  String get weiter => 'Continue';

  @override
  String get zurueck => 'Back';

  @override
  String get verabschiedungTitle => 'Goodbye';

  @override
  String get verabschiedungText => 'Thank you and have a good trip!';

  @override
  String get neuerVerkauf => 'New sale';

  @override
  String get betrag => 'Amount';

  @override
  String get belegTitle => 'Parking ticket';

  @override
  String get belegnummer => 'Ticket number';

  @override
  String get gueltigBis => 'Valid until';

  @override
  String get zahlungsart => 'Payment method';

  @override
  String get zahlungLaeuft => 'Processing payment …';

  @override
  String get zahlungAbbrechen => 'Cancel';

  @override
  String get zahlungAbgebrochen => 'Payment cancelled';

  @override
  String get zahlungFehlgeschlagen => 'The payment could not be completed.';

  @override
  String get debugTitle => 'Debug';

  @override
  String get debugPinTitel => 'Debug access';

  @override
  String get debugPinFeld => 'PIN';

  @override
  String get debugPinFalsch => 'PIN is wrong.';

  @override
  String get debugAnmelden => 'Sign in';

  @override
  String get debugAbmelden => 'Sign out';

  @override
  String get debugAbbrechen => 'Cancel';

  @override
  String get debugSchreibgeschuetzt =>
      'Changes are locked in the production build.';

  @override
  String get debugVerkaeufe => 'Sales per day (UTC days, shown locally)';

  @override
  String get debugKeineVerkaeufe => 'No sales in the period.';

  @override
  String get debugTelemetrie => 'Telemetry (last 24 hours)';

  @override
  String get debugZeitpunkt => 'Timestamp';

  @override
  String get debugStromverbrauch => 'Power';

  @override
  String get debugBatterie => 'Battery';

  @override
  String get debugSignal => 'Signal';

  @override
  String get debugPacketloss => 'Packet loss';

  @override
  String get debugPreissettings => 'Price settings';

  @override
  String get debugVerkaufszeiten => 'Selling hours';

  @override
  String get debugAendern => 'Edit';

  @override
  String get debugSpeichern => 'Save';

  @override
  String get debugTaktMinuten => 'Interval (minutes)';

  @override
  String get debugPreisProTaktCent => 'Price per interval (cent)';

  @override
  String get debugWaehrung => 'Currency';

  @override
  String get debugWochentag => 'Weekday';

  @override
  String get debugBeginn => 'Start (HH:MM)';

  @override
  String get debugEnde => 'End (HH:MM)';

  @override
  String get debugUngueltigeEingabe => 'Invalid input.';

  @override
  String get debugGueltigVon => 'Valid from';

  @override
  String get debugGueltigBis => 'Valid until';

  @override
  String get debugKeineDaten => 'No data available.';

  @override
  String get debugLadefehler => 'Data could not be loaded.';

  @override
  String get debugSpeicherfehler => 'Saving failed.';

  @override
  String get zahlungTimeout => 'Payment timed out';

  @override
  String get zahlungsartPaypal => 'PayPal';

  @override
  String get zahlungsartGoogleWallet => 'Google Wallet';

  @override
  String get zahlungsartGooglePay => 'Google Pay';

  @override
  String get parkzoneWaehlen => 'Choose parking zone';

  @override
  String get parkzeitZonenHinweis => 'Please choose a parking zone first.';

  @override
  String get kennzeichen => 'Licence plate';

  @override
  String get kennzeichenHinweis => 'Licence plate (optional)';

  @override
  String get kennzeichenUngueltig => 'Please enter a valid licence plate.';

  @override
  String get kennzeichenDoppelkauf =>
      'A parking ticket is already running for this licence plate. Please wait until the parking time has expired.';

  @override
  String get parkscheinHerunterladen => 'Download as PDF';

  @override
  String get parkscheinGespeichert => 'Parking ticket saved';

  @override
  String get parkscheinFehler => 'The parking ticket could not be saved.';
}
