import '../dto.dart';
import 'app_database.dart';

/// Abbildung der Drift-Zeilen auf die DTOs des Vertrags (`2_Datenbank.md`).
extension MaschineRowMapper on MaschineRow {
  Maschine toDto() => Maschine(
    id: id,
    geraeteId: geraeteId,
    standort: standort,
    status: MaschinenStatus.fromDb(status),
    kundennummer: kundennummer,
  );
}

extension PreissettingRowMapper on PreissettingRow {
  Preissetting toDto() => Preissetting(
    id: id,
    taktMinuten: taktMinuten,
    preisProTaktCent: preisProTaktCent,
    waehrung: waehrung,
    gueltigVon: _utc(gueltigVon),
    gueltigBis: gueltigBis == null ? null : _utc(gueltigBis!),
  );
}

extension VerkaufszeitRowMapper on VerkaufszeitRow {
  Verkaufszeit toDto() => Verkaufszeit(
    id: id,
    wochentag: wochentag,
    beginn: beginn,
    ende: ende,
    gueltigVon: gueltigVon == null ? null : _utc(gueltigVon!),
    gueltigBis: gueltigBis == null ? null : _utc(gueltigBis!),
  );
}

extension TelemetrieRowMapper on TelemetrieRow {
  Telemetrie toDto() => Telemetrie(
    id: id,
    maschineId: maschineId,
    timestamp: _utc(timestamp),
    stromverbrauchWatt: stromverbrauchWatt,
    batteriestandProzent: batteriestandProzent,
    signalStaerkeDbm: signalStaerkeDbm,
    packetlossProzent: packetlossProzent,
  );
}

extension VerkaufRowMapper on VerkaufRow {
  Verkauf toDto() => Verkauf(
    id: id,
    maschineId: maschineId,
    timestamp: _utc(timestamp),
    parkdauerMinuten: parkdauerMinuten,
    betragCent: betragCent,
    zahlungsart: Zahlungsart.fromDb(zahlungsart),
    belegnummer: belegnummer,
    kennzeichen: kennzeichen,
  );
}

extension ParkzoneRowMapper on ParkzoneRow {
  Parkzone toDto() => Parkzone(id: id, name: name);
}

DateTime _utc(String value) => DateTime.parse(value).toUtc();
