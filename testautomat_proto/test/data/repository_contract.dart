import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/logic/belegnummer.dart';
import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/data/parkautomat_repository.dart';
import 'package:testautomat_proto/data/repository_exception.dart';
import 'package:testautomat_proto/data/seed_data.dart';

/// Vertragstests, die jede [ParkautomatRepository]-Implementierung bestehen muss.
///
/// Wird von den In-Memory- und den SQLite-Tests aufgerufen, damit beide
/// Fassungen denselben Vertrag erfuellen (`2_Datenbank.md`, DoD Phase 1).
void runRepositoryContractTests({
  required String name,
  required Future<ParkautomatRepository> Function() createRepository,
}) {
  group(name, () {
    late ParkautomatRepository repository;

    setUp(() async {
      repository = await createRepository();
    });

    tearDown(() async {
      await repository.close();
    });

    VerkaufDraft entwurf(
      int maschineId, {
      DateTime? zeit,
      int parkdauerMinuten = 240,
      int betragCent = 200,
      Zahlungsart zahlungsart = Zahlungsart.karte,
    }) => VerkaufDraft(
      maschineId: maschineId,
      timestamp: zeit ?? DateTime.utc(2026, 2, 3, 9, 15),
      parkdauerMinuten: parkdauerMinuten,
      betragCent: betragCent,
      zahlungsart: zahlungsart,
    );

    test('getMachine liefert die aktive Maschine', () async {
      final maschine = await repository.getMachine();

      expect(maschine.geraeteId, SeedData.geraeteId);
      expect(maschine.standort, SeedData.standort);
      expect(maschine.status, MaschinenStatus.aktiv);
    });

    test('getPreissettings liefert die Seed-Preisregel', () async {
      final settings = await repository.getPreissettings();

      expect(settings, isNotEmpty);
      expect(settings.first.taktMinuten, SeedData.parktaktMinuten);
      expect(settings.first.preisProTaktCent, SeedData.preisProTaktCent);
    });

    test('getVerkaufszeiten deckt alle sieben Wochentage ab', () async {
      final zeiten = await repository.getVerkaufszeiten();

      expect(zeiten.map((zeit) => zeit.wochentag), <int>[1, 2, 3, 4, 5, 6, 7]);
    });

    test('getTelemetrie liefert die Zeitreihe aufsteigend', () async {
      final reihe = await repository.getTelemetrie();

      expect(reihe, hasLength(SeedData.telemetriePunkte));
      for (var index = 1; index < reihe.length; index++) {
        expect(
          reihe[index].timestamp.isAfter(reihe[index - 1].timestamp),
          isTrue,
        );
      }
    });

    test('getTelemetrie filtert den Zeitraum [von, bis)', () async {
      final reihe = await repository.getTelemetrie();
      final von = reihe[10].timestamp;
      final bis = reihe[20].timestamp;

      final gefiltert = await repository.getTelemetrie(von: von, bis: bis);

      expect(gefiltert, hasLength(10));
      expect(gefiltert.first.timestamp, von);
      expect(gefiltert.last.timestamp.isBefore(bis), isTrue);
    });

    test(
      'createSale speichert Verkaeufe mit eindeutigen Belegnummern',
      () async {
        final maschine = await repository.getMachine();

        final erster = await repository.createSale(entwurf(maschine.id));
        final zweiter = await repository.createSale(entwurf(maschine.id));

        expect(erster.id, isNot(zweiter.id));
        expect(erster.belegnummer, isNot(zweiter.belegnummer));
        expect(erster.belegnummer, greaterThan(0));
        expect(
          erster.belegnummer,
          lessThanOrEqualTo(BelegnummerGenerator.maxBelegnummer),
        );
        expect(erster.timestamp, DateTime.utc(2026, 2, 3, 9, 15));
      },
    );

    test('createSale lehnt ungueltige Entwuerfe ab', () async {
      final maschine = await repository.getMachine();

      await expectLater(
        repository.createSale(entwurf(maschine.id, parkdauerMinuten: 0)),
        throwsA(isA<RepositoryException>()),
      );
      await expectLater(
        repository.createSale(entwurf(maschine.id, betragCent: -1)),
        throwsA(isA<RepositoryException>()),
      );
      await expectLater(
        repository.createSale(entwurf(maschine.id + 999)),
        throwsA(isA<RepositoryException>()),
      );

      final umsaetze = await repository.getTagesumsaetze(
        DateTime.utc(2020),
        DateTime.utc(2030),
      );
      expect(
        umsaetze,
        isEmpty,
        reason: 'Fehlversuche duerfen nichts schreiben',
      );
    });

    test('getTagesumsaetze gruppiert an den UTC-Tagesgrenzen', () async {
      final maschine = await repository.getMachine();

      await repository.createSale(
        entwurf(
          maschine.id,
          zeit: DateTime.utc(2026, 3, 1, 23, 30),
          betragCent: 100,
        ),
      );
      await repository.createSale(
        entwurf(
          maschine.id,
          zeit: DateTime.utc(2026, 3, 2, 0, 30),
          betragCent: 250,
        ),
      );

      final umsaetze = await repository.getTagesumsaetze(
        DateTime.utc(2026, 3, 1),
        DateTime.utc(2026, 3, 3),
      );

      expect(umsaetze.map((umsatz) => umsatz.tag), <String>[
        '2026-03-01',
        '2026-03-02',
      ]);
      expect(umsaetze.map((umsatz) => umsatz.umsatzCent), <int>[100, 250]);
    });

    test('updatePreissetting aendert die Preisregel', () async {
      final vorher = (await repository.getPreissettings()).first;

      await repository.updatePreissetting(
        Preissetting(
          id: vorher.id,
          taktMinuten: vorher.taktMinuten,
          preisProTaktCent: 350,
          waehrung: vorher.waehrung,
          gueltigVon: vorher.gueltigVon,
        ),
      );

      final nachher = (await repository.getPreissettings()).first;
      expect(nachher.preisProTaktCent, 350);
    });

    test('updateVerkaufszeit aendert ein Fenster', () async {
      final vorher = (await repository.getVerkaufszeiten()).first;

      await repository.updateVerkaufszeit(
        Verkaufszeit(
          id: vorher.id,
          wochentag: vorher.wochentag,
          beginn: '08:00',
          ende: '18:00',
        ),
      );

      final nachher = (await repository.getVerkaufszeiten()).first;
      expect(nachher.beginn, '08:00');
      expect(nachher.ende, '18:00');
    });

    test('getParkzonen liefert die vier Seed-Zonen', () async {
      final zonen = await repository.getParkzonen();

      expect(zonen, hasLength(SeedData.parkzonen().length));
      expect(zonen.map((zone) => zone.name), contains('Zone A'));
    });

    test('createSale speichert Zahlungsart und Kennzeichen', () async {
      final maschine = await repository.getMachine();

      final verkauf = await repository.createSale(
        VerkaufDraft(
          maschineId: maschine.id,
          timestamp: DateTime.utc(2026, 2, 3, 9, 15),
          parkdauerMinuten: 240,
          betragCent: 200,
          zahlungsart: Zahlungsart.paypal,
          kennzeichen: 'WENAB123',
        ),
      );

      expect(verkauf.zahlungsart, Zahlungsart.paypal);
      expect(verkauf.kennzeichen, 'WENAB123');

      final gefunden = await repository.getVerkaeufeZuKennzeichen('WENAB123');
      expect(
        gefunden.map((eintrag) => eintrag.belegnummer),
        contains(verkauf.belegnummer),
      );
    });

    test(
      'createSale lehnt den Doppelkauf auf ein gueltiges Kennzeichen ab',
      () async {
        final maschine = await repository.getMachine();
        VerkaufDraft entwurfMitKennzeichen(DateTime zeit) => VerkaufDraft(
          maschineId: maschine.id,
          timestamp: zeit,
          parkdauerMinuten: 240,
          betragCent: 200,
          zahlungsart: Zahlungsart.googlePay,
          kennzeichen: 'AB123',
        );

        await repository.createSale(
          entwurfMitKennzeichen(DateTime.utc(2026, 4, 1, 8)),
        );

        // Innerhalb der laufenden Parkzeit (bis 12:00): Doppelkauf.
        await expectLater(
          repository.createSale(
            entwurfMitKennzeichen(DateTime.utc(2026, 4, 1, 10)),
          ),
          throwsA(isA<RepositoryException>()),
        );

        // Nach Ablauf der Parkzeit wieder erlaubt.
        final danach = await repository.createSale(
          entwurfMitKennzeichen(DateTime.utc(2026, 4, 1, 12)),
        );
        expect(danach.kennzeichen, 'AB123');
      },
    );

    test('createSale lehnt ein ungueltiges Kennzeichen ab', () async {
      final maschine = await repository.getMachine();

      await expectLater(
        repository.createSale(
          VerkaufDraft(
            maschineId: maschine.id,
            timestamp: DateTime.utc(2026, 2, 3, 9, 15),
            parkdauerMinuten: 240,
            betragCent: 200,
            zahlungsart: Zahlungsart.bar,
            kennzeichen: '123',
          ),
        ),
        throwsA(isA<RepositoryException>()),
      );
    });

    test('updatePreissetting meldet unbekannte Datensaetze', () async {
      final vorher = (await repository.getPreissettings()).first;

      await expectLater(
        repository.updatePreissetting(
          Preissetting(
            id: vorher.id + 99,
            taktMinuten: vorher.taktMinuten,
            preisProTaktCent: vorher.preisProTaktCent,
            waehrung: vorher.waehrung,
            gueltigVon: vorher.gueltigVon,
          ),
        ),
        throwsA(isA<RepositoryException>()),
      );
    });
  });
}
