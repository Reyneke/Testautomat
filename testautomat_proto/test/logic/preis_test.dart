import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/logic/preis.dart';

void main() {
  group('preisFuerParkdauer (E-15, E-02)', () {
    test('berechnet genaue Takte', () {
      expect(
        preisFuerParkdauer(
          parkdauerMinuten: 240,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        200,
      );
      expect(
        preisFuerParkdauer(
          parkdauerMinuten: 480,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        400,
      );
    });

    test('rundet angefangene Takte voll auf', () {
      expect(
        preisFuerParkdauer(
          parkdauerMinuten: 241,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        400,
      );
      expect(
        preisFuerParkdauer(
          parkdauerMinuten: 1,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        200,
      );
      expect(
        preisFuerParkdauer(
          parkdauerMinuten: 239,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        200,
      );
    });

    test('rechnet ausschliesslich in ganzen Cent', () {
      final betrag = preisFuerParkdauer(
        parkdauerMinuten: 250,
        taktMinuten: 60,
        preisProTaktCent: 155,
      );

      expect(betrag, 775);
      expect(betrag, isA<int>());
    });

    test('lehnt ungueltige Werte ab', () {
      expect(
        () => preisFuerParkdauer(
          parkdauerMinuten: 0,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        throwsArgumentError,
      );
      expect(
        () => preisFuerParkdauer(
          parkdauerMinuten: -5,
          taktMinuten: 240,
          preisProTaktCent: 200,
        ),
        throwsArgumentError,
      );
      expect(
        () => preisFuerParkdauer(
          parkdauerMinuten: 240,
          taktMinuten: 0,
          preisProTaktCent: 200,
        ),
        throwsArgumentError,
      );
      expect(
        () => preisFuerParkdauer(
          parkdauerMinuten: 240,
          taktMinuten: 240,
          preisProTaktCent: -1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('aktivesPreissetting', () {
    final basis = DateTime.utc(2026, 1, 1);

    Preissetting setting({
      required DateTime von,
      DateTime? bis,
      int preis = 200,
    }) => Preissetting(
      id: 1,
      taktMinuten: 240,
      preisProTaktCent: preis,
      waehrung: 'EUR',
      gueltigVon: von,
      gueltigBis: bis,
    );

    test('liefert die zum Zeitpunkt gueltige Regel', () {
      final settings = <Preissetting>[
        setting(von: basis, bis: DateTime.utc(2026, 6, 1), preis: 200),
        setting(von: DateTime.utc(2026, 6, 1), preis: 250),
      ];

      expect(
        aktivesPreissetting(
          settings,
          DateTime.utc(2026, 3, 1),
        )?.preisProTaktCent,
        200,
      );
      expect(
        aktivesPreissetting(
          settings,
          DateTime.utc(2026, 6, 1),
        )?.preisProTaktCent,
        250,
      );
    });

    test('liefert null ohne gueltige Regel', () {
      expect(
        aktivesPreissetting(<Preissetting>[
          setting(von: basis),
        ], DateTime.utc(2025, 12, 31)),
        isNull,
      );
      expect(aktivesPreissetting(<Preissetting>[], basis), isNull);
    });
  });
}
