import 'json_utils.dart';
import 'repository_exception.dart';

/// Unveraenderliche Datenuebertragungsobjekte des Datenlayers.
///
/// Sie bilden den JSON-Vertrag aus `doc/plan/grundlagen/2_Datenbank.md` ab:
/// Feldnamen im JSON sind `snake_case`, Dart-Felder `camelCase`. Zeitstempel
/// sind ISO-8601-Texte in UTC (Sekundengenauigkeit), Geldbetraege ganze Cent.

T _enumFromName<T extends Enum>(List<T> values, String value, String label) {
  for (final entry in values) {
    if (entry.name == value) {
      return entry;
    }
  }
  throw RepositoryException('Unbekannter $label: $value');
}

/// Betriebszustand einer Maschine (Werte der Spalte `maschine.status`).
enum MaschinenStatus {
  aktiv,
  inaktiv,
  stoerung;

  /// Wandelt den Wert aus Datenbank oder JSON in den Enum-Wert.
  static MaschinenStatus fromDb(String value) =>
      _enumFromName(values, value, 'Maschinenstatus');

  /// Wert, wie er in Datenbank und JSON steht.
  String get dbValue => name;
}

/// Zahlungsart der simulierten Zahlung (Werte der Spalte `verkaeufe.zahlungsart`).
///
/// Neben den urspruenglichen Arten `bar` und `karte` (E-51) enthaelt die
/// Aufzaehlung die in `doc/plan/grundlagen/7_Neue_Zahlmoeglichkeiten.md`
/// geforderten, ebenfalls nur simulierten Verfahren PayPal, Google Wallet und
/// Google Pay. Der Datenbankwert ist explizit hinterlegt, weil die
/// `CHECK`-Restriktion `snake_case` verlangt (`google_wallet`).
enum Zahlungsart {
  bar('bar'),
  karte('karte'),
  paypal('paypal'),
  googleWallet('google_wallet'),
  googlePay('google_pay');

  const Zahlungsart(this.dbValue);

  /// Wert, wie er in Datenbank und JSON steht.
  final String dbValue;

  /// Wandelt den Wert aus Datenbank oder JSON in den Enum-Wert.
  static Zahlungsart fromDb(String value) {
    for (final art in values) {
      if (art.dbValue == value) {
        return art;
      }
    }
    throw RepositoryException('Unbekannte Zahlungsart: $value');
  }
}

/// Automaten-Stammdaten (Tabelle `maschine`).
class Maschine {
  const Maschine({
    required this.id,
    required this.geraeteId,
    required this.standort,
    required this.status,
    required this.kundennummer,
  });

  factory Maschine.fromJson(Map<String, dynamic> json) => Maschine(
    id: jsonInt(json, 'id'),
    geraeteId: jsonString(json, 'geraete_id'),
    standort: jsonString(json, 'standort'),
    status: MaschinenStatus.fromDb(jsonString(json, 'status')),
    kundennummer: jsonString(json, 'kundennummer'),
  );

  /// Datenbank-ID.
  final int id;

  /// Lesbare Geraete-ID, z. B. `4711`.
  final String geraeteId;

  /// Aufstellort des Automaten.
  final String standort;

  /// Betriebszustand.
  final MaschinenStatus status;

  /// Betreiber/Kunde des Automaten (nicht personenbezogen, E-10).
  final String kundennummer;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'geraete_id': geraeteId,
    'standort': standort,
    'status': status.dbValue,
    'kundennummer': kundennummer,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Maschine &&
          other.id == id &&
          other.geraeteId == geraeteId &&
          other.standort == standort &&
          other.status == status &&
          other.kundennummer == kundennummer;

  @override
  int get hashCode =>
      Object.hash(id, geraeteId, standort, status, kundennummer);

  @override
  String toString() =>
      'Maschine(id: $id, geraeteId: $geraeteId, '
      'standort: $standort, status: ${status.name})';
}

/// Preisregel (Tabelle `preissetting`).
class Preissetting {
  const Preissetting({
    required this.id,
    required this.taktMinuten,
    required this.preisProTaktCent,
    required this.waehrung,
    required this.gueltigVon,
    this.gueltigBis,
  });

  factory Preissetting.fromJson(Map<String, dynamic> json) => Preissetting(
    id: jsonInt(json, 'id'),
    taktMinuten: jsonInt(json, 'takt_minuten'),
    preisProTaktCent: jsonInt(json, 'preis_pro_takt_cent'),
    waehrung: jsonString(json, 'waehrung'),
    gueltigVon: jsonUtcDateTime(json, 'gueltig_von'),
    gueltigBis: jsonUtcDateTimeOrNull(json, 'gueltig_bis'),
  );

  final int id;

  /// Laenge eines Parktakts in Minuten.
  final int taktMinuten;

  /// Preis je angefangenem Takt in Cent (E-02, E-15).
  final int preisProTaktCent;

  /// Waehrung, im Prototyp `EUR`.
  final String waehrung;

  /// Beginn der Gueltigkeit (UTC).
  final DateTime gueltigVon;

  /// Ende der Gueltigkeit (UTC); `null` bedeutet unbefristet.
  final DateTime? gueltigBis;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'takt_minuten': taktMinuten,
    'preis_pro_takt_cent': preisProTaktCent,
    'waehrung': waehrung,
    'gueltig_von': formatUtc(gueltigVon),
    'gueltig_bis': formatUtcOrNull(gueltigBis),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Preissetting &&
          other.id == id &&
          other.taktMinuten == taktMinuten &&
          other.preisProTaktCent == preisProTaktCent &&
          other.waehrung == waehrung &&
          other.gueltigVon == gueltigVon &&
          other.gueltigBis == gueltigBis;

  @override
  int get hashCode => Object.hash(
    id,
    taktMinuten,
    preisProTaktCent,
    waehrung,
    gueltigVon,
    gueltigBis,
  );

  @override
  String toString() =>
      'Preissetting(id: $id, taktMinuten: $taktMinuten, '
      'preisProTaktCent: $preisProTaktCent, waehrung: $waehrung)';
}

/// Verkaufszeit-Fenster (Tabelle `verkaufszeit`).
class Verkaufszeit {
  const Verkaufszeit({
    required this.id,
    required this.wochentag,
    required this.beginn,
    required this.ende,
    this.gueltigVon,
    this.gueltigBis,
  });

  factory Verkaufszeit.fromJson(Map<String, dynamic> json) => Verkaufszeit(
    id: jsonInt(json, 'id'),
    wochentag: jsonInt(json, 'wochentag'),
    beginn: jsonString(json, 'beginn'),
    ende: jsonString(json, 'ende'),
    gueltigVon: jsonUtcDateTimeOrNull(json, 'gueltig_von'),
    gueltigBis: jsonUtcDateTimeOrNull(json, 'gueltig_bis'),
  );

  final int id;

  /// Wochentag nach ISO 8601 (1 = Montag ... 7 = Sonntag).
  final int wochentag;

  /// Beginn als `HH:MM` (`00:00` bis `24:00`), lexikografisch vergleichbar.
  final String beginn;

  /// Ende als `HH:MM` (`00:00` bis `24:00`).
  final String ende;

  /// Ausnahmezeitraum (UTC); `null` bedeutet unbefristet.
  final DateTime? gueltigVon;
  final DateTime? gueltigBis;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'wochentag': wochentag,
    'beginn': beginn,
    'ende': ende,
    'gueltig_von': formatUtcOrNull(gueltigVon),
    'gueltig_bis': formatUtcOrNull(gueltigBis),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Verkaufszeit &&
          other.id == id &&
          other.wochentag == wochentag &&
          other.beginn == beginn &&
          other.ende == ende &&
          other.gueltigVon == gueltigVon &&
          other.gueltigBis == gueltigBis;

  @override
  int get hashCode =>
      Object.hash(id, wochentag, beginn, ende, gueltigVon, gueltigBis);

  @override
  String toString() =>
      'Verkaufszeit(id: $id, wochentag: $wochentag, '
      'beginn: $beginn, ende: $ende)';
}

/// Betriebsdaten des Automaten (Tabelle `telemetrie`, nur lesend, E-10).
class Telemetrie {
  const Telemetrie({
    required this.id,
    required this.maschineId,
    required this.timestamp,
    required this.stromverbrauchWatt,
    required this.batteriestandProzent,
    required this.signalStaerkeDbm,
    required this.packetlossProzent,
  });

  factory Telemetrie.fromJson(Map<String, dynamic> json) => Telemetrie(
    id: jsonInt(json, 'id'),
    maschineId: jsonInt(json, 'maschine_id'),
    timestamp: jsonUtcDateTime(json, 'timestamp'),
    stromverbrauchWatt: jsonInt(json, 'stromverbrauch_watt'),
    batteriestandProzent: jsonInt(json, 'batteriestand_prozent'),
    signalStaerkeDbm: jsonInt(json, 'signal_staerke_dbm'),
    packetlossProzent: jsonInt(json, 'packetloss_prozent'),
  );

  final int id;

  /// Maschine, zu der der Messwert gehoert.
  final int maschineId;

  /// Messzeitpunkt (UTC).
  final DateTime timestamp;

  final int stromverbrauchWatt;
  final int batteriestandProzent;
  final int signalStaerkeDbm;
  final int packetlossProzent;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'maschine_id': maschineId,
    'timestamp': formatUtc(timestamp),
    'stromverbrauch_watt': stromverbrauchWatt,
    'batteriestand_prozent': batteriestandProzent,
    'signal_staerke_dbm': signalStaerkeDbm,
    'packetloss_prozent': packetlossProzent,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Telemetrie &&
          other.id == id &&
          other.maschineId == maschineId &&
          other.timestamp == timestamp &&
          other.stromverbrauchWatt == stromverbrauchWatt &&
          other.batteriestandProzent == batteriestandProzent &&
          other.signalStaerkeDbm == signalStaerkeDbm &&
          other.packetlossProzent == packetlossProzent;

  @override
  int get hashCode => Object.hash(
    id,
    maschineId,
    timestamp,
    stromverbrauchWatt,
    batteriestandProzent,
    signalStaerkeDbm,
    packetlossProzent,
  );

  @override
  String toString() =>
      'Telemetrie(id: $id, maschineId: $maschineId, '
      'timestamp: ${formatUtc(timestamp)}, stromverbrauchWatt: $stromverbrauchWatt)';
}

/// Gespeicherter, simulierter Parkverkauf (Tabelle `verkaeufe`).
class Verkauf {
  const Verkauf({
    required this.id,
    required this.maschineId,
    required this.timestamp,
    required this.parkdauerMinuten,
    required this.betragCent,
    required this.zahlungsart,
    required this.belegnummer,
    this.kennzeichen,
  });

  factory Verkauf.fromJson(Map<String, dynamic> json) => Verkauf(
    id: jsonInt(json, 'id'),
    maschineId: jsonInt(json, 'maschine_id'),
    timestamp: jsonUtcDateTime(json, 'timestamp'),
    parkdauerMinuten: jsonInt(json, 'parkdauer_minuten'),
    betragCent: jsonInt(json, 'betrag_cent'),
    zahlungsart: Zahlungsart.fromDb(jsonString(json, 'zahlungsart')),
    belegnummer: jsonInt(json, 'belegnummer'),
    kennzeichen: jsonStringOrNull(json, 'kennzeichen'),
  );

  final int id;
  final int maschineId;

  /// Verkaufszeitpunkt (UTC).
  final DateTime timestamp;

  final int parkdauerMinuten;
  final int betragCent;
  final Zahlungsart zahlungsart;

  /// Belegnummer des Parkscheins (E-16).
  final int belegnummer;

  /// Optionales Kfz-Kennzeichen in Normalform (Grossbuchstaben, ohne Trenner);
  /// `null`, wenn der Kunde keine Angabe gemacht hat.
  final String? kennzeichen;

  /// Ende der Parkzeit (UTC).
  DateTime get gueltigBis => timestamp.add(Duration(minutes: parkdauerMinuten));

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'maschine_id': maschineId,
    'timestamp': formatUtc(timestamp),
    'parkdauer_minuten': parkdauerMinuten,
    'betrag_cent': betragCent,
    'zahlungsart': zahlungsart.dbValue,
    'belegnummer': belegnummer,
    if (kennzeichen != null) 'kennzeichen': kennzeichen,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Verkauf &&
          other.id == id &&
          other.maschineId == maschineId &&
          other.timestamp == timestamp &&
          other.parkdauerMinuten == parkdauerMinuten &&
          other.betragCent == betragCent &&
          other.zahlungsart == zahlungsart &&
          other.belegnummer == belegnummer &&
          other.kennzeichen == kennzeichen;

  @override
  int get hashCode => Object.hash(
    id,
    maschineId,
    timestamp,
    parkdauerMinuten,
    betragCent,
    zahlungsart,
    belegnummer,
    kennzeichen,
  );

  @override
  String toString() =>
      'Verkauf(id: $id, belegnummer: $belegnummer, '
      'betragCent: $betragCent, parkdauerMinuten: $parkdauerMinuten)';
}

/// Eingabedaten fuer `createSale` (ohne ID und Belegnummer).
class VerkaufDraft {
  const VerkaufDraft({
    required this.maschineId,
    required this.timestamp,
    required this.parkdauerMinuten,
    required this.betragCent,
    required this.zahlungsart,
    this.kennzeichen,
  });

  factory VerkaufDraft.fromJson(Map<String, dynamic> json) => VerkaufDraft(
    maschineId: jsonInt(json, 'maschine_id'),
    timestamp: jsonUtcDateTime(json, 'timestamp'),
    parkdauerMinuten: jsonInt(json, 'parkdauer_minuten'),
    betragCent: jsonInt(json, 'betrag_cent'),
    zahlungsart: Zahlungsart.fromDb(jsonString(json, 'zahlungsart')),
    kennzeichen: jsonStringOrNull(json, 'kennzeichen'),
  );

  final int maschineId;

  /// Verkaufszeitpunkt (UTC); die Repositories speichern ihn sekundengenau.
  final DateTime timestamp;

  final int parkdauerMinuten;
  final int betragCent;
  final Zahlungsart zahlungsart;

  /// Optionales Kfz-Kennzeichen in Normalform (Grossbuchstaben, ohne Trenner).
  final String? kennzeichen;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'maschine_id': maschineId,
    'timestamp': formatUtc(timestamp),
    'parkdauer_minuten': parkdauerMinuten,
    'betrag_cent': betragCent,
    'zahlungsart': zahlungsart.dbValue,
    if (kennzeichen != null) 'kennzeichen': kennzeichen,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerkaufDraft &&
          other.maschineId == maschineId &&
          other.timestamp == timestamp &&
          other.parkdauerMinuten == parkdauerMinuten &&
          other.betragCent == betragCent &&
          other.zahlungsart == zahlungsart &&
          other.kennzeichen == kennzeichen;

  @override
  int get hashCode => Object.hash(
    maschineId,
    timestamp,
    parkdauerMinuten,
    betragCent,
    zahlungsart,
    kennzeichen,
  );

  @override
  String toString() =>
      'VerkaufDraft(maschineId: $maschineId, '
      'timestamp: ${formatUtc(timestamp)}, parkdauerMinuten: $parkdauerMinuten, '
      'betragCent: $betragCent, zahlungsart: ${zahlungsart.dbValue})';
}

/// Umsatz eines UTC-Kalendertags (Ergebnis von `getTagesumsaetze`).
class Tagesumsatz {
  const Tagesumsatz({required this.tag, required this.umsatzCent});

  factory Tagesumsatz.fromJson(Map<String, dynamic> json) => Tagesumsatz(
    tag: jsonString(json, 'tag'),
    umsatzCent: jsonInt(json, 'umsatz_cent'),
  );

  /// Tag als `YYYY-MM-DD` (Gruppierung an den UTC-Tagesgrenzen, E-03/E-12).
  final String tag;

  /// Summe der Verkaeufe dieses Tages in Cent.
  final int umsatzCent;

  /// Der Tag als UTC-Zeitpunkt um Mitternacht.
  DateTime get tagUtc => DateTime.parse('${tag}T00:00:00Z');

  Map<String, dynamic> toJson() => <String, dynamic>{
    'tag': tag,
    'umsatz_cent': umsatzCent,
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tagesumsatz &&
          other.tag == tag &&
          other.umsatzCent == umsatzCent;

  @override
  int get hashCode => Object.hash(tag, umsatzCent);

  @override
  String toString() => 'Tagesumsatz(tag: $tag, umsatzCent: $umsatzCent)';
}

/// Verfuegbare Parkzone (Tabelle `parkzonen`).
///
/// Der Prototyp zeigt vier simulierte Zonen; in der Produktion liefert die
/// Datenquelle sie ueber `getParkzonen()` (`7_Neue_Zahlmoeglichkeiten.md`).
class Parkzone {
  const Parkzone({required this.id, required this.name});

  factory Parkzone.fromJson(Map<String, dynamic> json) =>
      Parkzone(id: jsonInt(json, 'id'), name: jsonString(json, 'name'));

  final int id;

  /// Anzeigename der Zone, z. B. `Zone A`.
  final String name;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id, 'name': name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Parkzone && other.id == id && other.name == name;

  @override
  int get hashCode => Object.hash(id, name);

  @override
  String toString() => 'Parkzone(id: $id, name: $name)';
}
