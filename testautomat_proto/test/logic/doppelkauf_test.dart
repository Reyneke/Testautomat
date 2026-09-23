import 'package:flutter_test/flutter_test.dart';

import 'package:testautomat_proto/data/dto.dart';
import 'package:testautomat_proto/logic/doppelkauf.dart';

Verkauf _verkauf({
  required int belegnummer,
  String? kennzeichen,
  DateTime? timestamp,
  int parkdauerMinuten = 240,
}) => Verkauf(
  id: belegnummer,
  maschineId: 1,
  timestamp: timestamp ?? DateTime.utc(2026, 4, 1, 8),
  parkdauerMinuten: parkdauerMinuten,
  betragCent: 200,
  zahlungsart: Zahlungsart.bar,
  belegnummer: belegnummer,
  kennzeichen: kennzeichen,
);

void main() {
  group('Doppelkauf-Pruefung', () {
    test('meldet ein noch laufendes Ticket', () {
      final verkaeufe = <Verkauf>[
        _verkauf(belegnummer: 1, kennzeichen: 'AB123'),
      ];

      expect(
        aktivesTicket(verkaeufe, 'AB123', DateTime.utc(2026, 4, 1, 11, 59)),
        isNotNull,
      );
    });

    test('gilt nach Ablauf der Parkzeit nicht mehr', () {
      final verkaeufe = <Verkauf>[
        _verkauf(belegnummer: 1, kennzeichen: 'AB123'),
      ];

      expect(
        aktivesTicket(verkaeufe, 'AB123', DateTime.utc(2026, 4, 1, 12)),
        isNull,
      );
    });

    test('ignoriert andere Kennzeichen und Verkaeufe ohne Kennzeichen', () {
      final verkaeufe = <Verkauf>[
        _verkauf(belegnummer: 1),
        _verkauf(belegnummer: 2, kennzeichen: 'CD456'),
      ];

      expect(
        aktivesTicket(verkaeufe, 'AB123', DateTime.utc(2026, 4, 1, 10)),
        isNull,
      );
    });

    test('liefert das am spaetesten ablaufende Ticket', () {
      final verkaeufe = <Verkauf>[
        _verkauf(belegnummer: 1, kennzeichen: 'AB123'),
        _verkauf(
          belegnummer: 2,
          kennzeichen: 'AB123',
          timestamp: DateTime.utc(2026, 4, 1, 9),
        ),
      ];

      expect(
        aktivesTicket(
          verkaeufe,
          'AB123',
          DateTime.utc(2026, 4, 1, 10),
        )?.belegnummer,
        2,
      );
    });
  });
}
