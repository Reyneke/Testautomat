import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Parkautomat Weiden'**
  String get appTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In de, this message translates to:
  /// **'Guten Morgen'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In de, this message translates to:
  /// **'Guten Tag'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In de, this message translates to:
  /// **'Guten Abend'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In de, this message translates to:
  /// **'Gute Nacht'**
  String get greetingNight;

  /// No description provided for @startSale.
  ///
  /// In de, this message translates to:
  /// **'Verkauf starten'**
  String get startSale;

  /// No description provided for @themeLight.
  ///
  /// In de, this message translates to:
  /// **'Hell'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In de, this message translates to:
  /// **'Dunkel'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In de, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @languageGerman.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageEnglish.
  ///
  /// In de, this message translates to:
  /// **'Englisch'**
  String get languageEnglish;

  /// No description provided for @debugMachine.
  ///
  /// In de, this message translates to:
  /// **'Automatennummer'**
  String get debugMachine;

  /// No description provided for @debugLocation.
  ///
  /// In de, this message translates to:
  /// **'Standort'**
  String get debugLocation;

  /// No description provided for @ladeMaschine.
  ///
  /// In de, this message translates to:
  /// **'Automat wird gestartet …'**
  String get ladeMaschine;

  /// No description provided for @automatAusserBetrieb.
  ///
  /// In de, this message translates to:
  /// **'Automat außer Betrieb'**
  String get automatAusserBetrieb;

  /// No description provided for @automatAusserBetriebHinweis.
  ///
  /// In de, this message translates to:
  /// **'Die Daten des Automaten sind derzeit nicht erreichbar. Bitte wenden Sie sich an das Personal.'**
  String get automatAusserBetriebHinweis;

  /// No description provided for @erneutVersuchen.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get erneutVersuchen;

  /// No description provided for @ausserhalbVerkaufszeit.
  ///
  /// In de, this message translates to:
  /// **'Der Verkauf ist derzeit nicht möglich.'**
  String get ausserhalbVerkaufszeit;

  /// No description provided for @ausserhalbVerkaufszeitHinweis.
  ///
  /// In de, this message translates to:
  /// **'Bitte nutzen Sie den Automaten innerhalb der Verkaufszeiten.'**
  String get ausserhalbVerkaufszeitHinweis;

  /// No description provided for @neuLaden.
  ///
  /// In de, this message translates to:
  /// **'Neu laden'**
  String get neuLaden;

  /// No description provided for @parkzeitAuswahlTitle.
  ///
  /// In de, this message translates to:
  /// **'Parkzeit wählen'**
  String get parkzeitAuswahlTitle;

  /// No description provided for @parkzeitAuswahlHinweis.
  ///
  /// In de, this message translates to:
  /// **'Bitte wählen Sie die gewünschte Parkdauer.'**
  String get parkzeitAuswahlHinweis;

  /// No description provided for @laufendeParkdauer.
  ///
  /// In de, this message translates to:
  /// **'Gewählte Parkdauer'**
  String get laufendeParkdauer;

  /// No description provided for @zahlungTitle.
  ///
  /// In de, this message translates to:
  /// **'Zahlungsart wählen'**
  String get zahlungTitle;

  /// No description provided for @zahlungHinweis.
  ///
  /// In de, this message translates to:
  /// **'Die Zahlung wird simuliert.'**
  String get zahlungHinweis;

  /// No description provided for @zahlungsartBar.
  ///
  /// In de, this message translates to:
  /// **'Bar'**
  String get zahlungsartBar;

  /// No description provided for @zahlungsartKarte.
  ///
  /// In de, this message translates to:
  /// **'Karte'**
  String get zahlungsartKarte;

  /// No description provided for @parkinfoTitle.
  ///
  /// In de, this message translates to:
  /// **'Parkinformation'**
  String get parkinfoTitle;

  /// No description provided for @parkinfoBelegHinweis.
  ///
  /// In de, this message translates to:
  /// **'Der Parkschein wird nach der Zahlung angezeigt.'**
  String get parkinfoBelegHinweis;

  /// No description provided for @weiter.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get weiter;

  /// No description provided for @zurueck.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get zurueck;

  /// No description provided for @verabschiedungTitle.
  ///
  /// In de, this message translates to:
  /// **'Auf Wiedersehen'**
  String get verabschiedungTitle;

  /// No description provided for @verabschiedungText.
  ///
  /// In de, this message translates to:
  /// **'Vielen Dank und eine gute Fahrt!'**
  String get verabschiedungText;

  /// No description provided for @neuerVerkauf.
  ///
  /// In de, this message translates to:
  /// **'Neuer Verkauf'**
  String get neuerVerkauf;

  /// No description provided for @betrag.
  ///
  /// In de, this message translates to:
  /// **'Betrag'**
  String get betrag;

  /// No description provided for @belegTitle.
  ///
  /// In de, this message translates to:
  /// **'Parkschein'**
  String get belegTitle;

  /// No description provided for @belegnummer.
  ///
  /// In de, this message translates to:
  /// **'Belegnummer'**
  String get belegnummer;

  /// No description provided for @gueltigBis.
  ///
  /// In de, this message translates to:
  /// **'Gültig bis'**
  String get gueltigBis;

  /// No description provided for @zahlungsart.
  ///
  /// In de, this message translates to:
  /// **'Zahlungsart'**
  String get zahlungsart;

  /// No description provided for @zahlungLaeuft.
  ///
  /// In de, this message translates to:
  /// **'Zahlung wird verarbeitet …'**
  String get zahlungLaeuft;

  /// No description provided for @zahlungAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get zahlungAbbrechen;

  /// No description provided for @zahlungAbgebrochen.
  ///
  /// In de, this message translates to:
  /// **'Zahlung abgebrochen'**
  String get zahlungAbgebrochen;

  /// No description provided for @zahlungFehlgeschlagen.
  ///
  /// In de, this message translates to:
  /// **'Die Zahlung konnte nicht abgeschlossen werden.'**
  String get zahlungFehlgeschlagen;

  /// No description provided for @debugTitle.
  ///
  /// In de, this message translates to:
  /// **'Debug'**
  String get debugTitle;

  /// No description provided for @debugPinTitel.
  ///
  /// In de, this message translates to:
  /// **'Debug-Zugang'**
  String get debugPinTitel;

  /// No description provided for @debugPinFeld.
  ///
  /// In de, this message translates to:
  /// **'PIN'**
  String get debugPinFeld;

  /// No description provided for @debugPinFalsch.
  ///
  /// In de, this message translates to:
  /// **'PIN ist falsch.'**
  String get debugPinFalsch;

  /// No description provided for @debugAnmelden.
  ///
  /// In de, this message translates to:
  /// **'Anmelden'**
  String get debugAnmelden;

  /// No description provided for @debugAbmelden.
  ///
  /// In de, this message translates to:
  /// **'Abmelden'**
  String get debugAbmelden;

  /// No description provided for @debugAbbrechen.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get debugAbbrechen;

  /// No description provided for @debugSchreibgeschuetzt.
  ///
  /// In de, this message translates to:
  /// **'Im Produktivbuild sind Änderungen gesperrt.'**
  String get debugSchreibgeschuetzt;

  /// No description provided for @debugVerkaeufe.
  ///
  /// In de, this message translates to:
  /// **'Verkäufe je Tag (UTC-Tage, lokal angezeigt)'**
  String get debugVerkaeufe;

  /// No description provided for @debugKeineVerkaeufe.
  ///
  /// In de, this message translates to:
  /// **'Keine Verkäufe im Zeitraum.'**
  String get debugKeineVerkaeufe;

  /// No description provided for @debugTelemetrie.
  ///
  /// In de, this message translates to:
  /// **'Telemetrie (letzte 24 Stunden)'**
  String get debugTelemetrie;

  /// No description provided for @debugZeitpunkt.
  ///
  /// In de, this message translates to:
  /// **'Zeitpunkt'**
  String get debugZeitpunkt;

  /// No description provided for @debugStromverbrauch.
  ///
  /// In de, this message translates to:
  /// **'Stromverbrauch'**
  String get debugStromverbrauch;

  /// No description provided for @debugBatterie.
  ///
  /// In de, this message translates to:
  /// **'Batterie'**
  String get debugBatterie;

  /// No description provided for @debugSignal.
  ///
  /// In de, this message translates to:
  /// **'Signal'**
  String get debugSignal;

  /// No description provided for @debugPacketloss.
  ///
  /// In de, this message translates to:
  /// **'Packetloss'**
  String get debugPacketloss;

  /// No description provided for @debugPreissettings.
  ///
  /// In de, this message translates to:
  /// **'Preissettings'**
  String get debugPreissettings;

  /// No description provided for @debugVerkaufszeiten.
  ///
  /// In de, this message translates to:
  /// **'Verkaufszeiten'**
  String get debugVerkaufszeiten;

  /// No description provided for @debugAendern.
  ///
  /// In de, this message translates to:
  /// **'Ändern'**
  String get debugAendern;

  /// No description provided for @debugSpeichern.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get debugSpeichern;

  /// No description provided for @debugTaktMinuten.
  ///
  /// In de, this message translates to:
  /// **'Takt (Minuten)'**
  String get debugTaktMinuten;

  /// No description provided for @debugPreisProTaktCent.
  ///
  /// In de, this message translates to:
  /// **'Preis je Takt (Cent)'**
  String get debugPreisProTaktCent;

  /// No description provided for @debugWaehrung.
  ///
  /// In de, this message translates to:
  /// **'Währung'**
  String get debugWaehrung;

  /// No description provided for @debugWochentag.
  ///
  /// In de, this message translates to:
  /// **'Wochentag'**
  String get debugWochentag;

  /// No description provided for @debugBeginn.
  ///
  /// In de, this message translates to:
  /// **'Beginn (HH:MM)'**
  String get debugBeginn;

  /// No description provided for @debugEnde.
  ///
  /// In de, this message translates to:
  /// **'Ende (HH:MM)'**
  String get debugEnde;

  /// No description provided for @debugUngueltigeEingabe.
  ///
  /// In de, this message translates to:
  /// **'Ungültige Eingabe.'**
  String get debugUngueltigeEingabe;

  /// No description provided for @debugGueltigVon.
  ///
  /// In de, this message translates to:
  /// **'Gültig von'**
  String get debugGueltigVon;

  /// No description provided for @debugGueltigBis.
  ///
  /// In de, this message translates to:
  /// **'Gültig bis'**
  String get debugGueltigBis;

  /// No description provided for @debugKeineDaten.
  ///
  /// In de, this message translates to:
  /// **'Keine Daten vorhanden.'**
  String get debugKeineDaten;

  /// No description provided for @debugLadefehler.
  ///
  /// In de, this message translates to:
  /// **'Daten konnten nicht geladen werden.'**
  String get debugLadefehler;

  /// No description provided for @debugSpeicherfehler.
  ///
  /// In de, this message translates to:
  /// **'Speichern fehlgeschlagen.'**
  String get debugSpeicherfehler;

  /// No description provided for @zahlungTimeout.
  ///
  /// In de, this message translates to:
  /// **'Zeitüberschreitung bei der Zahlung'**
  String get zahlungTimeout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
