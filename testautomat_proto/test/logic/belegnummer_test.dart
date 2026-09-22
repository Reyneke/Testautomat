import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/logic/belegnummer.dart';

void main() {
  group('BelegnummerGenerator (E-16)', () {
    final einschaltzeit = DateTime.utc(2026, 1, 1, 8);

    test('ist deterministisch fuer gleiche Eingaben', () {
      final erster = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
      );
      final zweiter = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
      );

      expect(
        List<int>.generate(5, (_) => erster.next()),
        List<int>.generate(5, (_) => zweiter.next()),
      );
    });

    test('vergibt streng steigende, eindeutige Nummern', () {
      final generator = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
      );

      final nummern = List<int>.generate(10000, (_) => generator.next());

      expect(nummern.toSet(), hasLength(nummern.length));
      for (var index = 1; index < nummern.length; index++) {
        expect(nummern[index], greaterThan(nummern[index - 1]));
      }
    });

    test('bleibt im JSON-sicheren Zahlenbereich', () {
      final generator = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
        startZaehler: 999999,
      );

      expect(
        generator.next(),
        lessThanOrEqualTo(BelegnummerGenerator.maxBelegnummer),
      );
    });

    test('unterscheidet Geraet und Einschaltzeit', () {
      final proGeraet = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
      ).next();
      final anderesGeraet = BelegnummerGenerator(
        geraeteId: '4712',
        einschaltzeit: einschaltzeit,
      ).next();
      final andereZeit = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit.add(const Duration(seconds: 1)),
      ).next();

      expect(<int>{proGeraet, anderesGeraet, andereZeit}, hasLength(3));
    });

    test('setzt die Vergabe mit startZaehler fort', () {
      final fortsetzung = BelegnummerGenerator(
        geraeteId: '4711',
        einschaltzeit: einschaltzeit,
        startZaehler: 7,
      );

      expect(fortsetzung.zaehler, 7);
      expect(
        fortsetzung.next(),
        greaterThan(
          BelegnummerGenerator(
            geraeteId: '4711',
            einschaltzeit: einschaltzeit,
          ).next(),
        ),
      );
    });
  });
}
