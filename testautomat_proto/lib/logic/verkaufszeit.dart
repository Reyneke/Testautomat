import 'package:timezone/data/latest_all.dart' as tz_daten;
import 'package:timezone/timezone.dart' as tz;

import 'package:testautomat_proto/data/dto.dart';

/// Standardzeitzone der Verkaufszeit-Auswertung: `null` bedeutet GMT (E-14).
///
/// Eine abweichende Zeitzone kann uebergeben werden; die Auswahl im Betrieb
/// folgt mit dem Debug-Bildschirm (Phase 4), die Logik ist darauf vorbereitet.
const String? standardZeitzone = null;

/// Prueft, ob der Automat zum Zeitpunkt [jetztUtc] verkaufen darf (E-14/E-03).
///
/// Die Fenster gelten je Wochentag in der Ortszeit von [zeitzoneIana] (`null`
/// steht fuer GMT). `beginn` zaehlt einschliesslich, `ende` ausschliessend;
/// `00:00`-`24:00` deckt den ganzen Tag ab. Fenster mit gesetztem
/// `gueltigVon`/`gueltigBis` gelten nur innerhalb dieses Zeitraums (UTC).
bool istInVerkaufszeit({
  required List<Verkaufszeit> fenster,
  required DateTime jetztUtc,
  String? zeitzoneIana = standardZeitzone,
}) {
  final ortszeit = ortszeitIn(jetztUtc, zeitzoneIana);
  final uhrzeit = alsStundenMinuten(ortszeit);
  for (final zeit in fenster) {
    if (zeit.wochentag != ortszeit.weekday) {
      continue;
    }
    if (!_istGueltig(zeit, jetztUtc)) {
      continue;
    }
    if (_liegtImFenster(uhrzeit, zeit.beginn, zeit.ende)) {
      return true;
    }
  }
  return false;
}

/// Rechnet [zeitpunkt] in die Ortszeit von [zeitzoneIana]; `null` bleibt GMT.
///
/// Die Zeitzonendatenbank wird beim ersten Aufruf mit einer Zeitzone geladen -
/// GMT braucht sie nicht.
DateTime ortszeitIn(DateTime zeitpunkt, String? zeitzoneIana) {
  final utc = zeitpunkt.toUtc();
  if (zeitzoneIana == null) {
    return utc;
  }
  _initialisiereZeitzonen();
  return tz.TZDateTime.from(utc, tz.getLocation(zeitzoneIana));
}

/// Formatiert einen Zeitpunkt als `HH:MM` (lexikografisch vergleichbar).
String alsStundenMinuten(DateTime zeitpunkt) =>
    '${zeitpunkt.hour.toString().padLeft(2, '0')}:'
    '${zeitpunkt.minute.toString().padLeft(2, '0')}';

bool _liegtImFenster(String uhrzeit, String beginn, String ende) =>
    uhrzeit.compareTo(beginn) >= 0 && uhrzeit.compareTo(ende) < 0;

bool _istGueltig(Verkaufszeit zeit, DateTime jetztUtc) {
  final zeitpunkt = jetztUtc.toUtc();
  final von = zeit.gueltigVon?.toUtc();
  if (von != null && zeitpunkt.isBefore(von)) {
    return false;
  }
  final bis = zeit.gueltigBis?.toUtc();
  if (bis != null && !zeitpunkt.isBefore(bis)) {
    return false;
  }
  return true;
}

bool _zeitzonenGeladen = false;

void _initialisiereZeitzonen() {
  if (_zeitzonenGeladen) {
    return;
  }
  tz_daten.initializeTimeZones();
  _zeitzonenGeladen = true;
}
