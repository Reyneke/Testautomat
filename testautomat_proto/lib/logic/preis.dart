import 'package:testautomat_proto/data/dto.dart';

/// Preisbildung nach E-15: Der Preis wird auf volle Takte aufgerundet - ein
/// angefangener Takt zaehlt voll. Alle Betraege sind ganze Cent (E-02).
int preisFuerParkdauer({
  required int parkdauerMinuten,
  required int taktMinuten,
  required int preisProTaktCent,
}) {
  if (parkdauerMinuten <= 0) {
    throw ArgumentError.value(
      parkdauerMinuten,
      'parkdauerMinuten',
      'muss groesser als 0 sein',
    );
  }
  if (taktMinuten <= 0) {
    throw ArgumentError.value(
      taktMinuten,
      'taktMinuten',
      'muss groesser als 0 sein',
    );
  }
  if (preisProTaktCent < 0) {
    throw ArgumentError.value(
      preisProTaktCent,
      'preisProTaktCent',
      'darf nicht negativ sein',
    );
  }
  final takte = (parkdauerMinuten + taktMinuten - 1) ~/ taktMinuten;
  return takte * preisProTaktCent;
}

/// Liefert die zum Zeitpunkt [jetztUtc] gueltige Preisregel.
///
/// Die erste passende Regel gewinnt; ohne passende Regel bleibt `null`.
Preissetting? aktivesPreissetting(
  List<Preissetting> settings,
  DateTime jetztUtc,
) {
  final zeitpunkt = jetztUtc.toUtc();
  for (final setting in settings) {
    if (zeitpunkt.isBefore(setting.gueltigVon.toUtc())) {
      continue;
    }
    final bis = setting.gueltigBis?.toUtc();
    if (bis != null && !zeitpunkt.isBefore(bis)) {
      continue;
    }
    return setting;
  }
  return null;
}
