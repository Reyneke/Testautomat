import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/logic/verkaufszeit.dart';

void main() {
  Verkaufszeit fenster({
    required int wochentag,
    String beginn = '08:00',
    String ende = '18:00',
    DateTime? von,
    DateTime? bis,
  }) => Verkaufszeit(
    id: wochentag,
    wochentag: wochentag,
    beginn: beginn,
    ende: ende,
    gueltigVon: von,
    gueltigBis: bis,
  );

  group('istInVerkaufszeit (E-14, E-03)', () {
    // Montag, 5. Januar 2026.
    final montag = DateTime.utc(2026, 1, 5);

    test('prueft Wochentag und Uhrzeit in GMT', () {
      expect(montag.weekday, DateTime.monday);
      final zeiten = <Verkaufszeit>[fenster(wochentag: DateTime.monday)];

      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 9),
        ),
        isTrue,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 7, 59),
        ),
        isFalse,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 18),
        ),
        isFalse,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 6, 9),
        ),
        isFalse,
      );
    });

    test('zaehlt den Beginn mit und schliesst das Ende aus', () {
      final zeiten = <Verkaufszeit>[fenster(wochentag: DateTime.monday)];

      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 8),
        ),
        isTrue,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 17, 59),
        ),
        isTrue,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 18),
        ),
        isFalse,
      );
    });

    test('deckt den ganzen Tag ab', () {
      final zeiten = <Verkaufszeit>[
        fenster(wochentag: DateTime.monday, beginn: '00:00', ende: '24:00'),
      ];

      expect(istInVerkaufszeit(fenster: zeiten, jetztUtc: montag), isTrue);
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 23, 59),
        ),
        isTrue,
      );
    });

    test('beruecksichtigt das Gueltigkeitsfenster', () {
      final zeiten = <Verkaufszeit>[
        fenster(
          wochentag: DateTime.monday,
          von: DateTime.utc(2026, 1, 5),
          bis: DateTime.utc(2026, 1, 12),
        ),
      ];

      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 5, 9),
        ),
        isTrue,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: DateTime.utc(2026, 1, 12, 9),
        ),
        isFalse,
      );
    });

    test('wertet die Fenster in der gewaehlten Zeitzone aus', () {
      final jetzt = DateTime.utc(2026, 1, 5, 7, 30);
      final berlin = ortszeitIn(jetzt, 'Europe/Berlin');
      final zeiten = <Verkaufszeit>[fenster(wochentag: berlin.weekday)];

      expect(berlin.hour, 8);
      expect(istInVerkaufszeit(fenster: zeiten, jetztUtc: jetzt), isFalse);
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: jetzt,
          zeitzoneIana: 'Europe/Berlin',
        ),
        isTrue,
      );
    });

    test('beruecksichtigt die Sommerzeit', () {
      final jetzt = DateTime.utc(2026, 7, 6, 6, 30);
      final berlin = ortszeitIn(jetzt, 'Europe/Berlin');
      final zeiten = <Verkaufszeit>[
        fenster(wochentag: berlin.weekday, beginn: '08:00', ende: '09:00'),
      ];

      expect(berlin.hour, 8);
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: jetzt,
          zeitzoneIana: 'Europe/Berlin',
        ),
        isTrue,
      );
      expect(
        istInVerkaufszeit(
          fenster: zeiten,
          jetztUtc: jetzt.add(const Duration(hours: 1)),
          zeitzoneIana: 'Europe/Berlin',
        ),
        isFalse,
      );
    });

    test('liefert ohne Fenster false', () {
      expect(
        istInVerkaufszeit(
          fenster: <Verkaufszeit>[],
          jetztUtc: DateTime.utc(2026, 1, 5, 9),
        ),
        isFalse,
      );
    });
  });

  group('istGueltigesHhMm', () {
    test('akzeptiert gueltige Uhrzeiten', () {
      expect(istGueltigesHhMm('00:00'), isTrue);
      expect(istGueltigesHhMm('08:00'), isTrue);
      expect(istGueltigesHhMm('23:59'), isTrue);
      expect(istGueltigesHhMm('24:00'), isTrue);
    });

    test('lehnt ungueltige Uhrzeiten ab', () {
      expect(istGueltigesHhMm('8:00'), isFalse);
      expect(istGueltigesHhMm('24:01'), isFalse);
      expect(istGueltigesHhMm('25:00'), isFalse);
      expect(istGueltigesHhMm('12:60'), isFalse);
      expect(istGueltigesHhMm(''), isFalse);
      expect(istGueltigesHhMm('abends'), isFalse);
    });
  });
  group('ortszeitIn', () {
    test('laesst GMT unveraendert', () {
      final zeit = DateTime.utc(2026, 1, 5, 9, 30);

      expect(ortszeitIn(zeit, null), zeit);
    });

    test('formatiert Stunden und Minuten zweistellig', () {
      expect(alsStundenMinuten(DateTime.utc(2026, 1, 5, 7, 5)), '07:05');
    });
  });
}
