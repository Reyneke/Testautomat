import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/json_utils.dart';
import 'package:testautomat_proto/data/repository_exception.dart';

void main() {
  group('JSON-Vertrag der DTOs', () {
    test('Maschine nutzt snake_case und laesst sich round-trippen', () {
      final json = <String, dynamic>{
        'id': 1,
        'geraete_id': '4711',
        'standort': 'Weiden i. d. OPf.',
        'status': 'aktiv',
        'kundennummer': 'K-0001',
      };

      final maschine = Maschine.fromJson(json);

      expect(maschine.geraeteId, '4711');
      expect(maschine.status, MaschinenStatus.aktiv);
      expect(maschine.toJson(), json);
    });

    test('Preissetting behandelt das offene Ende als null', () {
      final json = <String, dynamic>{
        'id': 1,
        'takt_minuten': 240,
        'preis_pro_takt_cent': 200,
        'waehrung': 'EUR',
        'gueltig_von': '2026-01-01T00:00:00Z',
        'gueltig_bis': null,
      };

      final setting = Preissetting.fromJson(json);

      expect(setting.gueltigVon, DateTime.utc(2026, 1, 1));
      expect(setting.gueltigBis, isNull);
      expect(setting.toJson(), json);
    });

    test('Verkaufszeit bildet Wochentag und Fenster ab', () {
      final json = <String, dynamic>{
        'id': 3,
        'wochentag': 3,
        'beginn': '08:00',
        'ende': '18:00',
        'gueltig_von': null,
        'gueltig_bis': null,
      };

      expect(Verkaufszeit.fromJson(json).toJson(), json);
    });

    test('Telemetrie bildet Messwerte ab', () {
      final json = <String, dynamic>{
        'id': 7,
        'maschine_id': 1,
        'timestamp': '2026-01-05T10:15:00Z',
        'stromverbrauch_watt': 42,
        'batteriestand_prozent': 87,
        'signal_staerke_dbm': -61,
        'packetloss_prozent': 2,
      };

      final messwert = Telemetrie.fromJson(json);

      expect(messwert.timestamp, DateTime.utc(2026, 1, 5, 10, 15));
      expect(messwert.signalStaerkeDbm, -61);
      expect(messwert.toJson(), json);
    });

    test('Verkauf bildet Zahlungsart und Belegnummer ab', () {
      final json = <String, dynamic>{
        'id': 2,
        'maschine_id': 1,
        'timestamp': '2026-02-03T09:15:00Z',
        'parkdauer_minuten': 240,
        'betrag_cent': 200,
        'zahlungsart': 'karte',
        'belegnummer': 123456,
      };

      final verkauf = Verkauf.fromJson(json);

      expect(verkauf.zahlungsart, Zahlungsart.karte);
      expect(verkauf.belegnummer, 123456);
      expect(verkauf.toJson(), json);
    });

    test('VerkaufDraft kommt ohne ID und Belegnummer aus', () {
      final draft = VerkaufDraft(
        maschineId: 1,
        timestamp: DateTime.utc(2026, 2, 3, 9, 15),
        parkdauerMinuten: 240,
        betragCent: 200,
        zahlungsart: Zahlungsart.bar,
      );

      final json = draft.toJson();

      expect(json.keys, <String>[
        'maschine_id',
        'timestamp',
        'parkdauer_minuten',
        'betrag_cent',
        'zahlungsart',
      ]);
      expect(VerkaufDraft.fromJson(json), draft);
    });

    test('Tagesumsatz liefert den Tag als UTC-Mitternacht', () {
      final umsatz = Tagesumsatz.fromJson(<String, dynamic>{
        'tag': '2026-03-02',
        'umsatz_cent': 250,
      });

      expect(umsatz.tagUtc, DateTime.utc(2026, 3, 2));
      expect(umsatz.toJson(), <String, dynamic>{
        'tag': '2026-03-02',
        'umsatz_cent': 250,
      });
    });

    test('unbekannte Enumerationswerte werden gemeldet', () {
      expect(
        () => MaschinenStatus.fromDb('wartung'),
        throwsA(isA<RepositoryException>()),
      );
      expect(
        () => Zahlungsart.fromDb('schein'),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('fehlende Pflichtfelder werden gemeldet', () {
      expect(
        () => Maschine.fromJson(<String, dynamic>{'id': 1}),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('Zeitformat des Vertrags', () {
    test('formatiert UTC auf Sekunden', () {
      expect(
        formatUtc(DateTime.utc(2026, 9, 18, 10, 42)),
        '2026-09-18T10:42:00Z',
      );
      expect(
        formatUtc(DateTime.utc(2026, 9, 18, 10, 42, 30, 500)),
        '2026-09-18T10:42:30Z',
      );
      expect(formatUtcDay(DateTime.utc(2026, 9, 18, 23, 59)), '2026-09-18');
    });

    test('wandelt lokale Zeit in UTC um', () {
      final draft = VerkaufDraft(
        maschineId: 1,
        timestamp: DateTime(2026, 9, 18, 12, 42),
        parkdauerMinuten: 240,
        betragCent: 200,
        zahlungsart: Zahlungsart.bar,
      );

      final timestamp = draft.toJson()['timestamp']! as String;

      expect(timestamp.endsWith('Z'), isTrue);
      expect(DateTime.parse(timestamp), DateTime(2026, 9, 18, 12, 42).toUtc());
    });
  });
}
