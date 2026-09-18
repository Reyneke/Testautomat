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
