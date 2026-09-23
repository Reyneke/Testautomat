import 'dto.dart';

/// Deterministische, idempotente Seed-Daten (E-52).
///
/// Alle Zeitstempel beziehen sich auf [basisZeit] statt auf `DateTime.now()`,
/// damit Demo, Tests und CI dieselben Werte sehen. Die Stammdaten entsprechen
/// den bisherigen Platzhaltern im Startbildschirm (F-16).
abstract final class SeedData {
  /// Fester Bezugszeitpunkt (Montag, 5. Januar 2026, 08:00 UTC).
  static final DateTime basisZeit = DateTime.utc(2026, 1, 5, 8);

  static const int maschinenId = 1;
  static const String geraeteId = '4711';
  static const String standort = 'Weiden i. d. OPf.';
  static const String kundennummer = 'K-0001';

  /// Parktakt in Minuten (vier Stunden).
  static const int parktaktMinuten = 240;

  /// Preis je angefangenem Takt in Cent.
  static const int preisProTaktCent = 200;

  /// Anzahl der Telemetrie-Messpunkte (24 Stunden im 15-Minuten-Takt).
  static const int telemetriePunkte = 96;

  /// Vier simulierte Parkzonen (`7_Neue_Zahlmoeglichkeiten.md`).
  ///
  /// In der Produktion uebernimmt die Datenquelle diese Liste; der Prototyp
  /// zeigt sie fest an, damit die Auswahl vor der Parkzeit geprueft werden kann.
  static List<Parkzone> parkzonen() => const <Parkzone>[
    Parkzone(id: 1, name: 'Zone A'),
    Parkzone(id: 2, name: 'Zone B'),
    Parkzone(id: 3, name: 'Zone C'),
    Parkzone(id: 4, name: 'Zone D'),
  ];

  /// Abstand zwischen zwei Telemetrie-Messpunkten.
  static const Duration telemetrieAbstand = Duration(minutes: 15);

  static List<Maschine> maschinen() => <Maschine>[
    Maschine(
      id: maschinenId,
      geraeteId: geraeteId,
      standort: standort,
      status: MaschinenStatus.aktiv,
      kundennummer: kundennummer,
    ),
  ];

  static List<Preissetting> preissettings() => <Preissetting>[
    Preissetting(
      id: 1,
      taktMinuten: parktaktMinuten,
      preisProTaktCent: preisProTaktCent,
      waehrung: 'EUR',
      gueltigVon: DateTime.utc(2026, 1, 1),
    ),
  ];

  static List<Verkaufszeit> verkaufszeiten() => <Verkaufszeit>[
    for (var wochentag = 1; wochentag <= 7; wochentag++)
      Verkaufszeit(
        id: wochentag,
        wochentag: wochentag,
        beginn: '00:00',
        ende: '24:00',
      ),
  ];

  static List<Telemetrie> telemetrie() => <Telemetrie>[
    for (var index = 0; index < telemetriePunkte; index++)
      Telemetrie(
        id: index + 1,
        maschineId: maschinenId,
        timestamp: basisZeit.add(telemetrieAbstand * index),
        stromverbrauchWatt: 40 + (index % 7) * 3,
        batteriestandProzent: 95 - (index % 20),
        signalStaerkeDbm: -60 - (index % 10),
        packetlossProzent: index % 5,
      ),
  ];

  /// Ein frischer Automat hat noch keine Verkaeufe.
  static List<Verkauf> verkaeufe() => <Verkauf>[];
}
