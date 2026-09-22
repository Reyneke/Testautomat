import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/seed_data.dart';

void main() {
  group('Seed-Daten (E-52)', () {
    test('sind deterministisch', () {
      expect(SeedData.maschinen(), SeedData.maschinen());
      expect(SeedData.preissettings(), SeedData.preissettings());
      expect(SeedData.verkaufszeiten(), SeedData.verkaufszeiten());
      expect(SeedData.telemetrie(), SeedData.telemetrie());
    });

    test('beschreiben den Automaten 4711', () {
      final maschine = SeedData.maschinen().single;

      expect(maschine.geraeteId, '4711');
      expect(maschine.standort, 'Weiden i. d. OPf.');
      expect(maschine.status, MaschinenStatus.aktiv);
      expect(maschine.kundennummer, 'K-0001');
    });

    test('liefern Preisregel und Verkaufszeiten fuer alle Wochentage', () {
      expect(SeedData.preissettings().single.taktMinuten, 240);
      expect(SeedData.preissettings().single.preisProTaktCent, 200);
      expect(SeedData.verkaufszeiten().map((zeit) => zeit.wochentag), <int>[
        1,
        2,
        3,
        4,
        5,
        6,
        7,
      ]);
      expect(SeedData.verkaufszeiten().first.beginn, '00:00');
      expect(SeedData.verkaufszeiten().first.ende, '24:00');
    });

    test('liefern eine Telemetrie-Zeitreihe im 15-Minuten-Takt', () {
      final reihe = SeedData.telemetrie();

      expect(reihe, hasLength(SeedData.telemetriePunkte));
      expect(reihe.first.timestamp, SeedData.basisZeit);
      expect(
        reihe[1].timestamp.difference(reihe.first.timestamp),
        SeedData.telemetrieAbstand,
      );
      for (final messwert in reihe) {
        expect(messwert.stromverbrauchWatt, greaterThanOrEqualTo(0));
        expect(messwert.batteriestandProzent, inInclusiveRange(0, 100));
        expect(messwert.signalStaerkeDbm, lessThanOrEqualTo(0));
        expect(messwert.packetlossProzent, inInclusiveRange(0, 100));
      }
    });

    test('starten ohne Verkaeufe', () {
      expect(SeedData.verkaeufe(), isEmpty);
    });
  });
}
